//
//  AAPLRootListViewController.swift
//  SamplePhotosApp
//
//  Translated by OOPer in cooperation with shlab.jp, on 2015/10/25.
//
//
/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information

 Abstract:
 The view controller displaying the root list of the app.
 */

import UIKit
import Photos

private let AllPhotosReuseIdentifier = "AllPhotosCell"
private let CollectionCellReuseIdentifier = "CollectionCell"

private let AllPhotosSegue = "showAllPhotos"
private let CollectionSegue = "showCollection"


class MomentRootListViewController: UITableViewController, PHPhotoLibraryChangeObserver {
    
    @IBOutlet weak var momentsListLabel: UILabel!
    
    private var sectionFetchResults: [PHFetchResult] = []
    private var sectionLocalizedTitles: [String] = []
    
    
    
    
    
    override func awakeFromNib() {
        
        
        
        // Get Lists of Photos of users based on names
        let names = ["michael", "Faces", "fiona"]
        var predicates = [NSPredicate] ()
        for name in names {
            let predicate = NSPredicate(format: "%K == %@", "title", name)
            predicates.append(predicate)
        }
        
        let compoundPedicate = NSCompoundPredicate(type: .OrPredicateType, subpredicates: predicates)
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = compoundPedicate
        
        var momentsList = [PHFetchResult]()
        
        
        let albums: PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
        
        for i in 0...albums.count-1 {
            let album: PHAssetCollection = albums[i] as! PHAssetCollection
            
            
            let photos: PHFetchResult = PHAsset.fetchAssetsInAssetCollection(album, options: nil)
            
            for j in 0...photos.count-1 {
                let photo: PHAsset = photos[j] as! PHAsset
                let moment: PHFetchResult = PHAssetCollection.fetchAssetCollectionsContainingAsset(photo, withType: .Moment, options: nil)
                momentsList.append(moment)
                self.sectionLocalizedTitles.append(photo.localIdentifier)
            }
            
            
            
        }
        
        momentsList = Array(Set(momentsList))
        
        self.sectionFetchResults = momentsList
                
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
    }
    
    deinit {
        PHPhotoLibrary.sharedPhotoLibrary().unregisterChangeObserver(self)
    }
    
    //MARK: - UIViewController
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*
        Get the AAPLAssetGridViewController being pushed and the UITableViewCell
        that triggered the segue.
        */
        guard let
            assetGridViewController = segue.destinationViewController as? MomentAssetGridViewController,
            cell = sender as? UITableViewCell
            else {
                return
        }
        
        // Set the title of the AAPLAssetGridViewController.
        assetGridViewController.title = cell.textLabel?.text
        
        
        // Get the PHFetchResult for the selected section.
        let indexPath = self.tableView.indexPathForCell(cell)!
        let fetchResult = self.sectionFetchResults[indexPath.section]
        
        if segue.identifier == CollectionSegue {
            // Get the PHAssetCollection for the selected row.
            guard let assetCollection = fetchResult[indexPath.row] as? PHAssetCollection else {
                return
            }
            
            // Configure the AAPLAssetGridViewController with the asset collection.
            let assetsFetchResult = PHAsset.fetchAssetsInAssetCollection(assetCollection, options: nil)
            
            
            assetGridViewController.assetsFetchResults = assetsFetchResult
            assetGridViewController.assetCollection = assetCollection
        }
    }
    
    //MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sectionFetchResults.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        
        
            let fetchResult = self.sectionFetchResults[section]
            numberOfRows = fetchResult.count
        
        
        return numberOfRows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
    
            let fetchResult = self.sectionFetchResults[indexPath.section]
            let collection = fetchResult[indexPath.row] as! PHCollection
            
            cell = tableView.dequeueReusableCellWithIdentifier(CollectionCellReuseIdentifier, forIndexPath: indexPath)
            cell.textLabel!.text = collection.localizedTitle
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionLocalizedTitles[section]
    }
    
    //MARK: - PHPhotoLibraryChangeObserver
    
    func photoLibraryDidChange(changeInstance: PHChange) {
        /*
        Change notifications may be made on a background queue. Re-dispatch to the
        main queue before acting on the change as we'll be updating the UI.
        */
        dispatch_async(dispatch_get_main_queue()) {
            // Loop through the section fetch results, replacing any fetch results that have been updated.
            var updatedSectionFetchResults = self.sectionFetchResults
            var reloadRequired = false
            
            self.sectionFetchResults.enumerate().forEach{index, collectionsFetchResult in
                if let changeDetails = changeInstance.changeDetailsForFetchResult(collectionsFetchResult) {
                    
                    updatedSectionFetchResults[index] = changeDetails.fetchResultAfterChanges
                    reloadRequired = true
                }
            }
            
            if reloadRequired {
                self.sectionFetchResults = updatedSectionFetchResults
                self.tableView.reloadData()
            }
            
        }
    }
    
    //MARK: - Actions
    
    @IBAction func handleAddButtonItem(_: AnyObject) {
        // Prompt user from new album title.
        let alertController = UIAlertController(title: NSLocalizedString("New Album", comment: ""), message: nil, preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler{textField in
            textField.placeholder = NSLocalizedString("Album Name", comment: "")
        }
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Create", comment: ""), style: .Default) {action in
            let textField = alertController.textFields![0]
            guard let title = textField.text where !title.isEmpty else {
                return
            }
            
            // Create a new album with the title entered.
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(title)
                }, completionHandler: {success, error in
                    if !success {
                        NSLog("Error creating album: %@", error!)
                    }
            })
            })
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
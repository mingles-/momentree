//
//  momentreeController.swift
//  momentree
//
//  Created by Michael Inglis on 04/03/2016.
//  Copyright © 2016 Michael Inglis. All rights reserved.
//

import UIKit
import Photos

var globalMomentree: PHFetchResult?

class MomentreeController: UINavigationController {

    private var sectionFetchResults: [PHFetchResult] = []
    private var sectionLocalizedTitles: [String] = []
    private var momentreeList: [PHFetchResult] = []
    private var someMoments: [PHAssetCollection] = []
    
    
    func compoundPredicateGenerator(formatter: String, formatValues: [String]) -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        var predicates = [NSPredicate] ()
        
        for formatValue in formatValues {
            let predicate = NSPredicate(format: "%K == %@", formatter, formatValue)
            predicates.append(predicate)
        }
        
        let compoundPedicate = NSCompoundPredicate(type: .OrPredicateType, subpredicates: predicates)
        fetchOptions.predicate = compoundPedicate
        
        return fetchOptions
    }
    
    override func awakeFromNib() {
        
        
        globalMomentree = nil
        let names = ["michael", "fiona", "Lesley"]
        
        
        // get albums based person inputs
        let fetchOptions = self.compoundPredicateGenerator("title", formatValues: names)
        let albums: PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
        
        // iterate through and seperate out photos
        for i in 0...albums.count-1 {
            let album: PHAssetCollection = albums[i] as! PHAssetCollection
            
            let photos: PHFetchResult = PHAsset.fetchAssetsInAssetCollection(album, options: nil)
            
            // iterate through photos and collect each moment
            for j in 0...photos.count-1 {
                let photo: PHAsset = photos[j] as! PHAsset
                let moment: PHFetchResult = PHAssetCollection.fetchAssetCollectionsContainingAsset(photo, withType: .Moment, options: nil)
                let momentCollection: PHAssetCollection = moment[0] as! PHAssetCollection
                
                // check if moment already exists before adding it
                if !(self.sectionLocalizedTitles.contains(String(momentCollection.localIdentifier))) {
                    self.sectionLocalizedTitles.append(String(momentCollection.localIdentifier))
                    someMoments.append(momentCollection)
                    self.momentreeList.append(moment)
                }
            }
            
        }
        
        // fetch all the moments from the library for display
        var momentIdentifiers = [String]()
        for moment in someMoments {
            let identifier = moment.localIdentifier
            momentIdentifiers.append(identifier)
        }
        let momentreeOption = compoundPredicateGenerator("localIdentifier", formatValues: momentIdentifiers)
        let momentreeAlbums: PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.Moment, subtype: .Any, options: momentreeOption)
        
        
        // collect all assets within the moments
        var assets = [PHAsset]()
        for i in 0...momentreeAlbums.count-1 {
            let album: PHAssetCollection = momentreeAlbums[i] as! PHAssetCollection
            let photoFetch: PHFetchResult = PHAsset.fetchAssetsInAssetCollection(album, options: nil)
            for p in 0...photoFetch.count-1 {
                let photo: PHAsset = photoFetch[p] as! PHAsset
                assets.append(photo)
            }
            
            
            
        }
        
        // get images in a format for the momentreeGridView
        
        let momentreeAssetCollection: PHAssetCollection = PHAssetCollection.transientAssetCollectionWithAssets(assets, title: "momentree Album")
        
        let momentreeCollectionList: PHCollectionList = PHCollectionList.transientCollectionListWithCollections([momentreeAssetCollection], title: nil)
        
        let momentreeFetch: PHFetchResult = PHAssetCollection.fetchCollectionsInCollectionList(momentreeCollectionList, options: nil)
        
//        self.sectionFetchResults = [momentreeFetch]
        print("got here")
        
//        
//        let assetGridViewController = MomentAssetGridViewController()
//        
//        // Set the title of the AAPLAssetGridViewController.
//        assetGridViewController.title = "momentTree"
//        
//        
//        // Get the PHFetchResult for the selected section.
//        let fetchResult = self.sectionFetchResults[0]
//        
//        let assetCollection = fetchResult[0] as! PHAssetCollection
//        
//        // Configure the AAPLAssetGridViewController with the asset collection.
//        let assetsFetchResult = PHAsset.fetchAssetsInAssetCollection(assetCollection, options: nil)
//        
//        
//        assetGridViewController.assetsFetchResults = assetsFetchResult
//        assetGridViewController.assetCollection = assetCollection
//        assetGridViewController.momentreeFetchResults = sectionFetchResults[0]
        globalMomentree = momentreeFetch

        
    

    
    
    }




}
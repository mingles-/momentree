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
    
    override func awakeFromNib() {
        
        
        globalMomentree = nil
        
        var names: [String] = []
        
        for person in momentList {
            if person.albumTitle != nil {
                names.append(person.albumTitle!)
            }
        }
                
        // get albums based person inputs
        let fetchOptions = self.compoundPredicateGenerator("localIdentifier", formatValues: names)
        let albums: PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
        
        if albums.count != 0 {
        
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
        momentreeOption.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
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
        
//        let dataOptions = PHFetchOptions()
//        dataOptions.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
        
        let momentreeFetch: PHFetchResult = PHAssetCollection.fetchCollectionsInCollectionList(momentreeCollectionList, options: nil)
        
        self.sectionFetchResults = [momentreeFetch]

        globalMomentree = momentreeFetch
            
        } else {
         globalMomentree = nil
        }
        
        
    }

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



}
//
//  MomentsController.swift
//  momentree
//
//  Created by Michael Inglis on 24/02/2016.
//  Copyright © 2016 Michael Inglis. All rights reserved.
//

import Foundation
import UIKit
import Photos

class MomentsController: UINavigationController {
    
    private var sectionFetchResults: [PHFetchResult] = []

    private let CollectionSegue = "showCollection"
    override func awakeFromNib() {
        
        let names = ["michael", "Faces"]
        var predicates = [NSPredicate] ()
        for name in names {
            let predicate = NSPredicate(format: "%K == %@", "title", name)
            predicates.append(predicate)
        }
        
        let compoundPedicate = NSCompoundPredicate(type: .OrPredicateType, subpredicates: predicates)
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = compoundPedicate
        let userAlbum: PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
        
//        self.sectionFetchResults = userAlbum
        
        let fetchResult = self.sectionFetchResults
//        var newFetchResult = self.sectionFetchResults![0]

        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        let fetchResult = self.sectionFetchResults
        var newFetchResult: PHFetchResult
        
        print("here")
//        for i in fetchResult {
//            newFetchResult.
//        }
        
        if segue.identifier == CollectionSegue {
            // Get the PHAssetCollection for the selected row.
//            guard let assetCollection = fetchResult as? PHAssetCollection else {
//                return
//            var x = self.sectionFetchResults?.objectAtIndex(0)
//            print(self.sectionFetchResults?.count)
            }
            
            // Configure the AAPLAssetGridViewController with the asset collection.
//            let assetsFetchResult = PHAsset.fetchAssetsInAssetCollection(assetCollection, options: nil)
//            
//            assetGridViewController.assetsFetchResults = assetsFetchResult
//            assetGridViewController.assetCollection = assetCollection
//        }
    }
}
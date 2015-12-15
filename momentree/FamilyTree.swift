//
//  FamilyTree.swift
//  momentree
//
//  Created by Michael Inglis on 24/10/2015.
//  Copyright © 2015 Michael Inglis. All rights reserved.
//

import Foundation
import SwiftyJSON

class FamilyTree {
    
    private var owner: Person?
    private var description = ""
    private var ancestorHeight = 0
    private var decendantHeight = 0
    private var hasSpouse = false
    
    init(owner: Person, ancestorHeight: Int, descendantHeight: Int, hasSpouse: Bool) {
        self.owner = owner
        self.description = "\(self.owner!.name)'s Family Tree"
        self.ancestorHeight = ancestorHeight
        self.decendantHeight = descendantHeight
        if self.owner?.spouse != nil {
            self.hasSpouse = hasSpouse
        }
        
    }
    
    // return the decendents based on the descendent height
    private func getDescendents() -> JSON {
        return JSON("Hello: test")
    }
    
    // return the ancestors based on the ancestor height
    private func getAncestors() -> JSON {
        return JSON("Hello: test")
    }
    
    // return specified JSON of tree
    func getJSON() -> JSON {
        return JSON("Hello: test")
    }
    
    
    func getHeight() -> Int {
        let descendentHeight = self.owner?.getDecendants(self.decendantHeight).1.count
        let ancestorHeight = self.owner?.getAncestors(self.ancestorHeight).1.count
        return descendentHeight! + ancestorHeight! + 1
    }
    
}
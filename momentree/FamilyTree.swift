//
//  FamilyTree.swift
//  momentree
//
//  Created by Michael Inglis on 24/10/2015.
//  Copyright © 2015 Michael Inglis. All rights reserved.
//

import Foundation

class FamilyTree {
    
    var owner: Person?
    var description = ""
    var ancestorHeight = 0
    var decendantHeight = 0
    
    init(owner: Person, ancestorHeight: Int, descendantHeight: Int) {
        self.owner = owner
        self.description = "\(owner.name)'s Family Tree"
        self.ancestorHeight = ancestorHeight
        self.decendantHeight = descendantHeight
    }
    
    
    func getHeight() -> Int {
        let descendentHeight = self.owner?.getDecendants(self.decendantHeight).1.count
        let ancestorHeight = self.owner?.getAncestors(self.ancestorHeight).1.count
        return descendentHeight! + ancestorHeight! + 1
    }
    
}
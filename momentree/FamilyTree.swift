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
    var maxAncestorHeight = 0
    var maxDecendantHeight = 0
    var ancestorSlider = [Int]()
    var descendantSlider = [Int]()
    var personList = [Person]()
    
    init(owner: Person, ancestorHeight: Int, descendantHeight: Int, hasSpouse: Bool) {
        self.owner = owner
        self.description = "\(self.owner!.name)'s Family Tree"
        self.ancestorHeight = ancestorHeight
        self.decendantHeight = descendantHeight
        if self.owner?.spouse != nil {
            self.hasSpouse = hasSpouse
        }
        self.maxDecendantHeight = self.owner!.getDescendantsHeightCount()
        self.maxAncestorHeight = self.owner!.getAncestorsHeightCount()
        self.ancestorSlider = [Int](0...self.maxAncestorHeight)
        self.descendantSlider = [Int](0...self.maxDecendantHeight)
        self.personList = getPersonList()
        
    }
    
    // return the decendents based on the descendent height
    private func getDescendents() -> JSON {
        return JSON("Hello: test")
    }
    
    // return the ancestors based on the ancestor height
    private func getAncestors() -> JSON {
        return JSON("Hello: test")
    }
    
    func getMembers() -> JSON {
        return JSON("Hello: test")
    }
    
    func getPersonList() -> [Person] {
        personList = [Person]()
        let ancestors = self.owner?.getAncestors(self.ancestorHeight).0
        let descendents = self.owner?.getDecendants(self.decendantHeight).0
        personList = ancestors! + descendents!
        personList.append(self.owner!)
        return personList
    }
    
    func fullTree() -> [String:AnyObject]
    {
        
        let ancestors = (self.getAncestorsDict(self.ancestorHeight))
        var decendants = (self.getDecendentsDict(self.decendantHeight))
        
        if self.owner!.name == decendants["name"] as! String {
            decendants["_parents"] = ancestors
            
        }
        
        return decendants
        
    }
    
    func getAncestorsDict(maxIterations: Int) -> [[String:AnyObject]]
    {
        // get descendent list in generations
        var decendentLayers = self.owner!.getAncestors(maxIterations).1
        // get children at highest layer
        var childrenDictionaries: [[String:AnyObject]] = []

        var adultDicts: [[String:AnyObject]] = []
        
        // iterate down layers appending the previous layer to correct children key
        for var i = decendentLayers.count-1; i >= 0; --i
        {
            adultDicts = []
            for person in decendentLayers[i].1
            {
                var currentPersonChildDicts: [[String:AnyObject]] = []
                
                if person.dad != nil {
                    for dad2 in childrenDictionaries {
                        if person.dad!.name == dad2["name"] as! String {
                            currentPersonChildDicts.append(dad2)
                        }
                    }
                    
                }
                
                if person.mum != nil {
                    for mum2 in childrenDictionaries {
                        if person.mum!.name == mum2["name"] as! String {
                            currentPersonChildDicts.append(mum2)
                        }
                    }
                }
                
                
                
                
                adultDicts.append(self.dictionaryfyAncestor(person, ancDict: currentPersonChildDicts))
            }
            
            childrenDictionaries = adultDicts
        }
        return(adultDicts)
        
    }

    
    func getDecendentsDict(maxIterations: Int) -> [String:AnyObject]
    {
        // get descendent list in generations
        var decendentLayers = self.owner!.getDecendants(maxIterations).1
        
        // get children at highest layer
        var childrenDictionaries: [[String:AnyObject]] = []
        let baseLayer = decendentLayers.last!.1
        var adultDicts: [[String:AnyObject]] = []
        
        for b in baseLayer
        {
            let child = b
            childrenDictionaries.append(self.dictionaryfyAncestor(child))
        }
        
        // iterate down layers appending the previous layer to correct children key
        
        for var i = decendentLayers.count-1; i >= 0; --i
        {
            adultDicts = []
            for person in decendentLayers[i].1
            {
                var currentPersonChildDicts: [[String:AnyObject]] = []
                for child1 in person.children {
                    for child2 in childrenDictionaries
                    {
                        if child1.name == child2["name"] as! String
                        {
                            currentPersonChildDicts.append(child2)
                        }
                    }
                }
                adultDicts.append(self.dictionaryfyChildren(person, childDict: currentPersonChildDicts))
            }
            childrenDictionaries = adultDicts
        }
        
        return(adultDicts.first)!
    }
    
    
    func dictionaryfyAncestor(person: Person) -> [String:AnyObject]
    {
        var json = [String:AnyObject]()
        
        if person.name == self.owner!.name {
            json = ["name":person.name, "id":person.name,"_children": [], "_parents": []]
        }
        if let spouse = person.spouse?.name {
            json = ["name":person.name, "id":person.name, "spouse":spouse, "_parents": []]
        } else {
            json = ["name":person.name, "id":person.name, "_parents": []]
        }
        
        return json
    }
    
    func dictionaryfyAncestor(person: Person, ancDict: [[String:AnyObject]]) -> [String:AnyObject]
    {
        var json = [String:AnyObject]()
        
        if let spouse = person.spouse?.name {
            json = ["name":person.name, "id":person.name, "spouse":spouse, "_parents": ancDict]
        } else {
            json = ["name":person.name, "id":person.name, "_parents": ancDict]
        }
        
        return json
    }
    
    
    func dictionaryfyChildren(person: Person, childDict: [[String:AnyObject]]) -> [String:AnyObject]
    {
        var json = [String:AnyObject]()
        
        if let spouse = person.spouse?.name {
            json = ["name":person.name, "id":person.name, "spouse":spouse, "_children": childDict]
            
        } else if person.children.count != 0 {
            
            json = ["name":person.name, "id":person.name, "_children": childDict]
            
        } else {
            json = ["name":person.name, "id":person.name,]
        }
        
        return json
    }
    
    
    func getHeight() -> Int {
        let descendentHeight = self.owner?.getDecendants(self.decendantHeight).1.count
        let ancestorHeight = self.owner?.getAncestors(self.ancestorHeight).1.count
        return descendentHeight! + ancestorHeight!
    }
    
}
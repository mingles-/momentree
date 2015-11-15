//
//  Person.swift
//  momentree
//
//  Created by Michael Inglis on 30/09/2015.
//  Copyright © 2015 Michael Inglis. All rights reserved.
//
import SwiftyJSON
import Foundation

class Person: CustomStringConvertible {
    
    var name: String = ""
    var dad: Person?
    var mum: Person?
//    var relationship = [Person]()
    var spouse: Person?
    var children = [Person]()
    
    var description: String {
        let string = name
        return string
    }
    
    
    init(name: String)
    {
        self.name = name
        
    }
    
    func setDad(dad: Person)
    {
        // used for singlular instance of parent
        self.dad = dad
        dad.addChild(self)
    }
    
    func setMum(mum: Person)
    {
        // used for singlular instance of parent
        self.mum = mum
        mum.addChild(self)
    }
    
    func setParents(dad:Person, mum:Person)
    {
        // used for adding both parents
        self.dad = dad
        self.mum = mum
        dad.addChild(self)
        mum.addChild(self)
        mum.setSpouse(dad)
    }
    
    func setSpouse(spouse: Person)
    {
        self.spouse = spouse
        spouse.spouse = self
    }
    
    func addChild(child: Person)
    {
        self.children.append(child)
    }
    
    func removeMum()
    {
        
        if self.mum?.spouse != nil {
            self.mum!.removeSpouse()
        }
        self.mum = nil
    }
    
    func removeDad()
    {
        
        if self.dad?.spouse != nil {
            self.dad!.removeSpouse()
        }
        self.dad = nil
    }
    
    func removeSpouse()
    {
        self.spouse?.spouse = nil
        self.spouse = nil
    }
    
    func removeParents()
    {
        self.removeDad()
        self.removeMum()
        self.removeSpouse()
    }
    
    
    func getAncestors(maxIterations: Int) -> ([Person], [(Int,[Person])])
    {
        var iteration = 0
        var thisLevel = [Person]()
        
        var ancestorListWithGeneration = [(Int,[Person])]()
        var ancestorList = [Person]()
        
        thisLevel.append(self)
        
        while !thisLevel.isEmpty
        {
            var nextLevel = [Person]()
            for n in thisLevel
            {
                if (n.dad != nil)
                {
                    nextLevel.append(n.dad!)
                }
                if (n.mum != nil)
                {
                    nextLevel.append(n.mum!)
                }
            }
            ancestorListWithGeneration.append((iteration, thisLevel))
            ancestorList += thisLevel
            thisLevel = nextLevel
            
            if iteration == maxIterations
            {
                break
            }
            
            iteration += 1

        }
        ancestorList.removeFirst()
        ancestorListWithGeneration.removeFirst()
        return (ancestorList, ancestorListWithGeneration)
    }
    
    func getDecendants(maxIterations: Int) -> ([Person], [(Int,[Person])])
    {
        var iteration = 0
        var thisLevel = [Person]()
        
        var decendantListWithGeneration = [(Int,[Person])]()
        var decendantList = [Person]()
        
        thisLevel.append(self)
        
        while !thisLevel.isEmpty
        {
            
            var nextLevel = [Person]()
            for n in thisLevel
            {
                for c in n.children
                {
                    nextLevel.append(c)
                }
            }
            decendantListWithGeneration.append((iteration, thisLevel))
            decendantList += thisLevel
            thisLevel = nextLevel
            
            if iteration == maxIterations
            {
                break
            }
            
            iteration += 1
        }
//        decendantListWithGeneration.removeFirst()
        decendantList.removeFirst()
        return  (decendantList, decendantListWithGeneration)
    }
    
    
    
    
    func getDict(maxIterations: Int) -> [String:AnyObject]
    {
        // get descendent list in generations
        var decendentLayers = self.getDecendants(maxIterations).1

        // get children at highest layer
        var childrenDictionaries: [[String:AnyObject]] = []
        let baseLayer = decendentLayers.last!.1
        var adultDicts: [[String:AnyObject]] = []
        
        for b in baseLayer
        {
           let child = b
            childrenDictionaries.append(self.dictionaryfy(child))
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

    
    
    func dictionaryfy(person: Person) -> [String:AnyObject]
    {
        var json = [String:AnyObject]()
        if let spouse = person.spouse?.name {
            json = ["name":person.name, "spouse":spouse, "children": []]
        } else {
            json = ["name":person.name, "children": []]
        }
        
        return json
    }
    
    func dictionaryfyChildren(person: Person, childDict: [[String:AnyObject]]) -> [String:AnyObject]
    {
        var json = [String:AnyObject]()
        
        if let spouse = person.spouse?.name {
            json = ["name":person.name, "spouse":spouse, "children": childDict]
        } else {
            json = ["name":person.name, "children": childDict]
        }
        
        return json
    }
    
}
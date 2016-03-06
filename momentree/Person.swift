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
    var spouse: Person?
    var albumTitle: String?
    var children = [Person]()
    
    var description: String {
        let string = name
        return string
    }
    
    
    init(name: String)
    {
        self.name = name
    }
    
    func setAlbumTitle(albumTitle: String) {
        self.albumTitle = albumTitle
    }
    
    func removeAlbumTitle() {
        self.albumTitle = nil
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
        
        if self.mum != nil {
            self.mum?.removeChild(self)
            self.mum = nil
        }
        
    }
    
    func removeDad()
    {
        

        if self.dad != nil {
            
            self.dad?.removeChild(self)
            self.dad = nil
            
        }
        
    }
    
    func removeChild(child: Person) {
        
        for childIndex in 0...self.children.count-1 {
            if self.children[childIndex] === child {
                self.children.removeAtIndex(childIndex)
            }
        }
        
        if self.children.count == 0 {
            self.removeSpouse()
        }

    }
    
    func removeSpouse()
    {
        self.spouse?.spouse = nil
        self.spouse = nil
    }
    
    func removeParents()
    {
        self.dad?.removeChild(self)
        self.mum?.removeChild(self)
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
        decendantList.removeFirst()
        return  (decendantList, decendantListWithGeneration)
    }
    
    func getDescendantsHeightCount() -> Int
    {
        var iteration = 0
        var thisLevel = [Person]()
        
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
            decendantList += thisLevel
            thisLevel = nextLevel
            
            iteration += 1
        }
        
        return iteration-1
    }
    
    func getAncestorsHeightCount() -> Int
    {
        var iteration = 0
        var thisLevel = [Person]()
        
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
            ancestorList += thisLevel
            thisLevel = nextLevel
            
            iteration += 1
            
        }
        return iteration - 1
    }

    
    
}
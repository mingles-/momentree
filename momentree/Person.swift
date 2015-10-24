//
//  Person.swift
//  momentree
//
//  Created by Michael Inglis on 30/09/2015.
//  Copyright © 2015 Michael Inglis. All rights reserved.
//

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
    
    
    func getAncestors() -> [Person]
    {
        var thisLevel = [Person]()
        thisLevel.append(self)
        
        var ancestorList = [Person]()
        
        while !thisLevel.isEmpty
        {
            var nextLevel = [Person]()
            for n in thisLevel
            {
                if (n.dad != nil)
                {
                    nextLevel.append(dad!)
                }
                if (n.mum != nil)
                {
                    nextLevel.append(mum!)
                }
            }
            ancestorList += thisLevel
            thisLevel = nextLevel
            print(ancestorList)
        }
        return ancestorList
    }
    
    func getDecendants() -> [Person]
    {
        var thisLevel = [Person]()
        thisLevel.append(self)
        var decendantList = [Person]()
        
        while !thisLevel.isEmpty
        {
            var nextLevel = [Person]()
            for n in thisLevel
            {
                for c in n.children
                {
                    print(c.name)
                    nextLevel.append(c)
                }
            }
            decendantList += thisLevel
            thisLevel = nextLevel
            print(decendantList)
        }
        return decendantList
    }
    
    func getRelatives() -> [Person]
    {
        return self.getDecendants() + self.getDecendants()
    }
    
    func toJson() -> String
    {
        return "123"
    }
    
}
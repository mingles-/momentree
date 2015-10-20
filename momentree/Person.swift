//
//  Person.swift
//  momentree
//
//  Created by Michael Inglis on 30/09/2015.
//  Copyright © 2015 Michael Inglis. All rights reserved.
//

import Foundation

class Person {
    
    var name: String = ""
    var dad: Person?
    var mum: Person?
    var relationship = [Person]()
    var spouse: Person?
    var children = [Person]()
    
    init(name: String){
        self.name = name
        
    }
    
    func setDad(dad: Person)
    {
        self.dad = dad
        dad.addChild(self)
    }
    
    func setMum(mum: Person)
    {
        self.mum! = mum
        mum.addChild(self)
    }
    
    func addChild(child: Person)
    {
        self.children.append(child)
    }
    
    func setParents(dad: Person, mum:Person)
    {
        self.dad! = dad
        self.mum! = mum
        dad.addChild(self)
        mum.addChild(self)
        mum.relationship.append(dad)
        dad.relationship.append(mum)
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
                    nextLevel.append(c)
                }
            }
            decendantList += thisLevel
            thisLevel = nextLevel
        }
        return decendantList
    }
    
    func toJson() -> String
    {
        return "123"
    }
    
}

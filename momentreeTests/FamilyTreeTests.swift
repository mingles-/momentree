//
//  FamilyTreeTests.swift
//  momentree
//
//  Created by Michael Inglis on 26/10/2015.
//  Copyright © 2015 Michael Inglis. All rights reserved.
//

import XCTest
@testable import momentree

class FamilyTreeTests: XCTestCase {
    
    var fiona = Person(name: "fiona")
    var mingles = Person(name:"mingles")
    var stuart = Person(name:"stuart")
    var lesley = Person(name:"lesley")
    
    var adam = Person(name: "adam")
    var emma = Person(name:"emma")
    var alex = Person(name: "alex")
    
    
    var francis = Person(name: "francis")
    var cathy = Person(name: "cathy")
    
    var joan = Person(name: "joan")
    var rab = Person(name: "rab")
    
    var louis = Person(name: "louis")
    
    
    override func setUp() {
        super.setUp()
        
        mingles.setParents(stuart, mum: lesley)
        fiona.setParents(stuart, mum: lesley)
        adam.setParents(alex, mum: emma)
        lesley.setParents(rab, mum: joan)
        emma.setParents(rab, mum: joan)
        stuart.setParents(francis, mum: cathy)
        francis.setDad(louis)
    
        }
    
    
    func testHeightBigTree() {
        let stuartTree = FamilyTree(owner: stuart, ancestorHeight: 10, descendantHeight: 10)
        let height = stuartTree.getHeight()
        
        XCTAssertEqual(height, 4)
    }
    
    func testHeightWeeTree() {
        let stuartTree = FamilyTree(owner: stuart, ancestorHeight: 1, descendantHeight: 0)
        let height = stuartTree.getHeight()
        XCTAssertEqual(height, 2)
    }
    
    
}
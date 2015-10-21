//
//  momentreeTests.swift
//  momentreeTests
//
//  Created by Michael Inglis on 21/09/2015.
//  Copyright © 2015 Michael Inglis. All rights reserved.
//

import XCTest
@testable import momentree

class TreeGenerationOneTests: XCTestCase {
    
    var mingles = Person(name:"mingles")
    var stuart = Person(name:"stuart")
    var lesley = Person(name:"lesley")
    var fiona = Person(name: "fiona")
    
    override func setUp() {
        super.setUp()
        
        self.mingles.setDad(stuart)
        self.mingles.setMum(lesley)
        self.fiona.setParents(stuart, mum: lesley)
        
    }
    
    func testDad() {
        
        var minglesDad = ""
        if self.mingles.dad != nil {
            minglesDad = self.mingles.dad!.name
        }
        XCTAssertEqual("stuart", minglesDad)
        
        var fionaDad = ""
        if self.fiona.dad != nil {
            fionaDad = self.fiona.dad!.name
        }
        XCTAssertEqual("stuart", fionaDad)
        
    }
    
    func testMum() {
        
        var minglesMum = ""
        if self.mingles.mum != nil {
            minglesMum = self.mingles.mum!.name
        }
        XCTAssertEqual("lesley", minglesMum)
        
        var fionaMum = ""
        if self.fiona.mum != nil {
            fionaMum = self.fiona.mum!.name
        }
        XCTAssertEqual("lesley", fionaMum)

    }
    
    func testParentOverride() {
        
        let adopted = Person(name: "adopted")
        self.fiona.setDad(adopted)
        
        var fionaDad = ""
        if self.fiona.dad != nil {
            fionaDad = self.fiona.dad!.name
        }
        XCTAssertEqual("adopted", fionaDad)
        
    }
    
    func testChildren() {
        
        var lesleysChildren1 = [String]()
        if self.lesley.children.count != 0 {
            for x in self.lesley.children {
                lesleysChildren1.append(x.name)
            }
        }
        
        let lesleysChildren2 = ["mingles", "fiona"]

        XCTAssertEqual(lesleysChildren1, lesleysChildren2)
        
        var stuartsChildren1 = [String]()
        if self.stuart.children.count != 0 {
            for x in self.stuart.children {
                stuartsChildren1.append(x.name)
            }
        }
        
        let stuartsChildren2 = ["mingles", "fiona"]
        
        XCTAssertEqual(stuartsChildren1, stuartsChildren2)
        
    }
    
//    func testRelationship() {
//        var lesleyRelationships = [String]()
//        if self.lesley.relationship.count != 0 {
//            for x in self.lesley.relationship {
//                lesleyRelationships.append(x.name)
//            }
//        }
//        
//        XCTAssertEqual(lesleyRelationships, ["stuart"])
//        
//        var stuartRelationships = [String]()
//        if self.stuart.relationship.count != 0 {
//            for x in self.stuart.relationship {
//                stuartRelationships.append(x.name)
//            }
//        }
//        let stuartRelationships2 = ["lesley"]
//        
//        XCTAssertEqual(stuartRelationships, stuartRelationships2)
//    }
    
    func testSpouse() {
        XCTAssertEqual(stuart.spouse!.name, lesley.name)
        XCTAssertEqual(lesley.spouse!.name, stuart.name)
    }
    
    func testRemoveSpouse() {
        stuart.removeSpouse()
        XCTAssertNil(stuart.spouse)
        XCTAssertNil(lesley.spouse)
    }
    
    func testRemoveParents() {
        mingles.removeParents()
        XCTAssertNil(mingles.mum)
        XCTAssertNil(mingles.dad)
    }
    
    func testRemoveParentsIndividually() {
        let dad = mingles.dad
        let mum = mingles.mum
        
        mingles.removeMum()
        XCTAssertNil(mingles.mum)
        mingles.removeDad()
        XCTAssertNil(mingles.dad)
        
        XCTAssertNil(dad?.spouse)
        XCTAssertNil(mum?.spouse)
    }
    
    
    
}

//
//  TreeMultipleGenerationTests.swift
//  momentree
//
//  Created by Michael Inglis on 21/10/2015.
//  Copyright © 2015 Michael Inglis. All rights reserved.
//

import XCTest
@testable import momentree

class TreeMultipleGenerationTests: XCTestCase {
    
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
    
    func testDescendants() {
        
        var minglesIsIn = false
        var fionaIsIn = false
        var lesleyIsIn = false
        var emmaIsIn = false
        var adamIsIn = false
        var hasNobodyElse = true
        
        let (descendants, _) = joan.getDecendants(10)
        
        for descendant in descendants {
            if descendant === mingles {
                minglesIsIn = true
            } else if descendant === fiona {
                fionaIsIn = true
            } else if descendant === adam {
                adamIsIn = true
            } else if descendant === emma {
                emmaIsIn = true
            } else if descendant === lesley {
                lesleyIsIn = true
            } else {
                hasNobodyElse = false
            }
        }
        
        let correctDescendants = minglesIsIn && fionaIsIn && lesleyIsIn && emmaIsIn && adamIsIn && hasNobodyElse
        
        XCTAssertTrue(correctDescendants)
        
    }
    
    func testDescendantsN() {
        
        var minglesIsIn = false
        var fionaIsIn = false
        var lesleyIsIn = false
        var emmaIsIn = false
        var adamIsIn = false
        var hasNobodyElse = true
        
        // stop after 1 iteration
        let (descendants, _) = joan.getDecendants(1)

        for descendant in descendants {
            if descendant === mingles {
                minglesIsIn = true
            } else if descendant === fiona {
                fionaIsIn = true
            } else if descendant === adam {
                adamIsIn = true
            } else if descendant === emma {
                emmaIsIn = true
            } else if descendant === lesley {
                lesleyIsIn = true
            } else {
                hasNobodyElse = false
            }
        }
        
        let correctDescendants = !minglesIsIn && !fionaIsIn && lesleyIsIn && emmaIsIn && !adamIsIn && hasNobodyElse
        
        XCTAssertTrue(correctDescendants)
        
    }
    
    func testAncestorsN() {
        
        var lesleyIsIn = false
        var stuartIsIn = false
        var francisIsIn = false
        var cathyIsIn = false
        var joanIsIn = false
        var rabIsIn = false
        var louisIsIn = false
        var hasNobodyElse = true
        
        let (ancestors, allAncestors) = mingles.getAncestors(10)
        for ancestor in ancestors {
            if ancestor === lesley {
                lesleyIsIn = true
            } else if ancestor === stuart {
                stuartIsIn = true
            } else if ancestor === francis {
                francisIsIn = true
            } else if ancestor === cathy {
                cathyIsIn = true
            } else if ancestor === joan {
                joanIsIn = true
            } else if ancestor === rab {
                rabIsIn = true
            } else if ancestor === louis {
                louisIsIn = true
            } else {
                hasNobodyElse = false
            }
        }
        
        let correctAncestors = lesleyIsIn && stuartIsIn && francisIsIn && cathyIsIn && joanIsIn && rabIsIn && louisIsIn && hasNobodyElse
        print(allAncestors)
        
        XCTAssertTrue(correctAncestors)
        
    }
    
    func testAncestors() {
        
        var lesleyIsIn = false
        var stuartIsIn = false
        var francisIsIn = false
        var cathyIsIn = false
        var joanIsIn = false
        var rabIsIn = false
        var louisIsIn = false
        var hasNobodyElse = true
        
        let (ancestors, _) = mingles.getAncestors(1)
        for ancestor in ancestors {
            if ancestor === lesley {
                lesleyIsIn = true
            } else if ancestor === stuart {
                stuartIsIn = true
            } else if ancestor === francis {
                francisIsIn = true
            } else if ancestor === cathy {
                cathyIsIn = true
            } else if ancestor === joan {
                joanIsIn = true
            } else if ancestor === rab {
                rabIsIn = true
            } else if ancestor === louis {
                louisIsIn = true
            } else {
                hasNobodyElse = false
            }
        }
        
        let correctAncestors = lesleyIsIn && stuartIsIn && !francisIsIn && !cathyIsIn && !joanIsIn && !rabIsIn && !louisIsIn && hasNobodyElse
        
        XCTAssertTrue(correctAncestors)
        
    }
    
    func testDescendentsHeightCounts() {
        var num = mingles.getDescendantsHeightCount()
        XCTAssertEqual(num, 0)
        num = stuart.getDescendantsHeightCount()
        XCTAssertEqual(num, 1)
        num = francis.getDescendantsHeightCount()
        XCTAssertEqual(num, 2)
        num = louis.getDescendantsHeightCount()
        XCTAssertEqual(num, 3)
    }
    
    func testAncestorsHeightCounts() {
        var num = mingles.getAncestorsHeightCount()
        XCTAssertEqual(num, 3)
        num = stuart.getAncestorsHeightCount()
        XCTAssertEqual(num, 2)
        num = francis.getAncestorsHeightCount()
        XCTAssertEqual(num, 1)
        num = louis.getAncestorsHeightCount()
        XCTAssertEqual(num, 0)
    }
    

}
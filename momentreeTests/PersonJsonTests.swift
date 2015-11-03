//
//  PersonJsonTests.swift
//  momentree
//
//  Created by Michael Inglis on 01/11/2015.
//  Copyright © 2015 Michael Inglis. All rights reserved.
//

import Foundation
import SwiftyJSON
import XCTest
@testable import momentree

class PersonJsonTests: XCTestCase {
    
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


    func testJsonSingle() {
        let json = mingles.dictionaryfy(mingles)
        let test:[String:AnyObject] = ["name":"mingles", "children":[]]
        XCTAssertEqual(JSON(json), JSON(test))
        joan.getDict(10)
    }
    
    func testJsonSpouse() {
        let json  = stuart.getDict(10)
        
        let minglesjson = ["name":"mingles", "children":[]]
        let fionajson = ["name":"fiona", "children":[]]
        let children = [minglesjson, fionajson]
        let stujson: [String: AnyObject] = ["name":"stuart", "spouse":"lesley", "children":children]

        XCTAssertTrue(NSDictionary(dictionary: json).isEqualToDictionary(stujson))
    }

}

//
//  momentreeTests.swift
//  momentreeTests
//
//  Created by Michael Inglis on 21/09/2015.
//  Copyright © 2015 Michael Inglis. All rights reserved.
//

import XCTest
@testable import momentree

class momentreeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let mingles = Person(name:"mingles")
        let stu = Person(name:"stuart")
        var name = "nothing"
        mingles.setDad(stu)
        if let dad = mingles.dad {
            name = dad.name
        }
        
        XCTAssertEqual("stuart", name)
        
    }
    
}

//
//  AttractionDataLoaderTests.swift
//  WishListTests
//
//  Created by Jessica Jesus on 17/02/2026.
//

import XCTest
@testable import WishList

final class AttractionDataLoaderTests: XCTestCase {
    var sut: AttractionDataLoader!
    
    override func setUp() {
        super.setUp()
        sut = AttractionDataLoader()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testLoadAttractionsValidJSON() {
        let attractions = sut.loadAttractionsFromFile(named: "offerings")
        
        XCTAssertEqual(attractions.count, 15)
    }
    
    func testLoadAttractionsMissingFile() {
        let attractions = sut.loadAttractionsFromFile(named: "hello")
        XCTAssert(attractions.isEmpty)
    }
}

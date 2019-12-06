//
//  RectangleDataLoaderTests.swift
//  Sorting VisualizerTests
//
//  Created by Yanik Simpson on 12/6/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Sorting_Visualizer

class RectangleDataLoaderTests: XCTestCase {

    private var sut: RectangleDataLoader!
    
    override func setUp() {
        sut = RectangleDataLoader()
        super.setUp()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init() {
        XCTAssertTrue(sut.rectangles.isEmpty)
    }
    
    func test_load() {
        XCTAssertTrue(sut.rectangles.isEmpty)
        
        sut.load(rectsToLoad: 5)
        
        XCTAssertFalse(sut.rectangles.isEmpty)
    }
    
    func test_reset() {
        sut.load(rectsToLoad: 5)
        let initialData = sut.rectangles
        
        sut.reset()
        let newResult = sut.rectangles
        
        XCTAssertNotEqual(initialData, newResult)
    }
}

//
//  Sorting_VisualizerTests.swift
//  Sorting VisualizerTests
//
//  Created by Yanik Simpson on 10/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Sorting_Visualizer

class Sorting_VisualizerTests: XCTestCase {
    
    var sut: BubbleSortAPI?
    
    override func setUp() {
        sut = BubbleSortAPI()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Initialize

    func testInit_state_waiting() {
        XCTAssertEqual(sut?.state, BubbleSortAPI.State.waiting)
    }
    
    // MARK: -
    
    
    
    
    
    // MARK: - Helpers

}

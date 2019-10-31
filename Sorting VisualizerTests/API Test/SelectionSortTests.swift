//
//  SelectionSortTests.swift
//  Sorting VisualizerTests
//
//  Created by Yanik Simpson on 10/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

import XCTest
@testable import Sorting_Visualizer

class SelectionSortTests: XCTestCase {
    
    var sut: SelectionSortAPI?
    
    // MARK: - Setup
    
    override func setUp() {
        sut = SelectionSortAPI()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Initialize

    func testInit_state_waiting() {
        XCTAssertEqual(sut?.state,
                       SelectionSortAPI.State.waiting)
    }
    
    func test_state_start() {
        // given
        sut?.datasource = [2, 1, 3]
        
        sut?.start()
        
        XCTAssertEqual(sut?.state,
                       SelectionSortAPI.State.looping(
                        currentIndex: [sut!.currentIndex, 0],
                        nextIndex: [sut!.steppingIndex, 0]))
    }
    
    

    
    
}

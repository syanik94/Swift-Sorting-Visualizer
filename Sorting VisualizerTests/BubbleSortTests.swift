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
    
    func testInit_setValues() {
        sut?.datasource = [5, 3]
        XCTAssertEqual(sut?.datasource, [5, 3])
    }
    
    // MARK: - Sorting
    
    func test_start_swap_firstAndSecondIndex() {
        // given
        sut?.datasource = [5, 3, 1]
        // when
        sut?.start()
        // then
        XCTAssertEqual(sut?.state, BubbleSortAPI.State.swap(index1: [0, 0], Index2: [0, 1]))
    }
    
    func test_start_loop_firstIndex() {
        // given
        sut?.datasource = [1, 3, 1]
        // when
        sut?.start()
        // then
        XCTAssertEqual(sut?.state, BubbleSortAPI.State.looping(currentIndex: [0, 0], previousIndex: nil))
    }
    
    
    
    // MARK: - Helpers

}

//
//  Sorting_VisualizerTests.swift
//  Sorting VisualizerTests
//
//  Created by Yanik Simpson on 10/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Sorting_Visualizer

class BubbleSortTests: XCTestCase {
    
    var sut: BubbleSortAPI?
    
    // MARK: - Setup
    
    override func setUp() {
        sut = BubbleSortAPI()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Initialize

    func testInit_state_waiting() {
        XCTAssertEqual(sut?.state,
                       BubbleSortAPI.State.waiting)
    }
    
    func testInit_setValues() {
        sut?.datasource = [5, 3]
        
        XCTAssertEqual(sut?.datasource, [5, 3])
    }
    
    // MARK: - Sorting
    
    func test_start_swap_firstAndSecondIndex() {
        sut?.datasource = [5, 3, 1]
        
        sut?.start()
        
        XCTAssertEqual(sut?.state,
                       BubbleSortAPI.State.swap(index1: [0, 0],
                                                Index2: [0, 1]))
        XCTAssertEqual(sut?.datasource, [3, 5, 1])
    }
    
    func test_start_loop_firstIndex() {
        sut?.datasource = [1, 3, 1]
        
        sut?.start()
        
        XCTAssertEqual(sut?.state,
                       BubbleSortAPI.State.looping(currentIndex: [0, 0],
                                                   previousIndex: nil))
        XCTAssertEqual(sut?.datasource, [1, 3, 1])
    }
    
    func test_start_checkForSwap_shouldSwap() {
        sut?.datasource = [3,2,1]
        
        sut?.start()
        
        XCTAssertEqual(sut?.state,
                       BubbleSortAPI.State.swap(index1: [0, 0],
                                                Index2: [0, 1]))
        XCTAssertEqual(sut?.datasource, [2, 3, 1])
    }
    
    func test_start_checkForSwap_shouldNotSwap() {
        sut?.datasource = [1,2,3]
        
        sut?.start()
        
        XCTAssertEqual(sut?.state,
                       BubbleSortAPI.State.looping(currentIndex: [0, 0],
                                                   previousIndex: nil))
        XCTAssertEqual(sut?.datasource, [1, 2, 3])
    }
    
//    func test_reset() {
//        sut?.datasource = [1,2,3]
//        
//        sut?.reset()
//        
//        XCTAssertEqual(sut?.state,
//                       BubbleSortAPI.State.waiting)
//        XCTAssertNotEqual(sut?.datasource, [1,2,3])
//    }
    
    func test_handleLooping_secondIndex_shouldResultInLooping() {
        sut?.datasource = [1, 2, 3]
        
        sut?.performLoop(1, Timer())
        
        XCTAssertEqual(sut?.state,
            BubbleSortAPI.State.looping(currentIndex: [0, 1], previousIndex: Optional([0, 0])))
    }
    
    func test_handleLooping_secondIndex_shouldResultInSwap() {
        sut?.datasource = [2, 3, 1]
        
        sut?.performLoop(1, Timer())
        
        XCTAssertEqual(sut?.state,
        BubbleSortAPI.State.swap(index1: [0, 1], Index2: [0, 2]))
        
        sut?.performLoop(0, Timer())
        XCTAssertEqual(sut?.datasource,
                        [1, 2, 3])
    }
    
}

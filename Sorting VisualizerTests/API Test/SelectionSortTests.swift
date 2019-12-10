//
//  SelectionSortTests.swift
//  Sorting VisualizerTests
//
//  Created by Yanik Simpson on 10/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Sorting_Visualizer

class SelectionSortTests: XCTestCase {
    
    var sut: SelectionSortAPI?
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        sut = makeSUT()
    }
    
    override func tearDown() {
        sut?.sendUpdates = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Initialize

    func testInit_state_notStarted() {
        XCTAssertEqual(sut?.state,
                       SelectionSortAPI.State.notStarted)
    }
    
    
    func test_start_looping() {
        sut?.start()
        
        XCTAssertEqual(sut?.state,
                       SelectionSortAPI.State.looping(currentIndex: [0,0],
                                                      startingIndex: [0, 0],
                                                      currentPossibleSwapIndex: nil, previousPossibleSwapIndex: nil, previousIndexPath: [sut!.endIndex, 0]))
    }
    
    
    // MARK: - State - Completion & Output
    
    func test_start_completion() {
        let expectated = expectation(description: #function)
        var observedState = SelectionSortAPI.State.notStarted
        
        sut?.sendUpdates = { (state) in
            observedState = state
            switch state {
            case .completed:
                expectated.fulfill()
            default:
                break
            }
        }
        sut?.start()
        
        wait(for: [expectated], timeout: 2)
        XCTAssertEqual(observedState,
                       SelectionSortAPI.State.completed)
    }

    func test_start_completionOutput() {
        let sortedData = sut?.datasource.sorted()
        let expectated = expectation(description: #function)
        
        sut?.sendUpdates = { (state) in
            switch state {
            case .completed:
                expectated.fulfill()
            default: break
            }
        }
        sut?.start()
        
        wait(for: [expectated], timeout: 1)
        XCTAssertEqual(sut?.datasource,
                      sortedData)
    }
    
    func test_pauseState() {
        sut?.start()
        sut?.pause()

        XCTAssertEqual(sut?.state, .paused)
    }
    
    func test_pauseOutput() {
        sut?.datasource = [2, 3, 1]
        let expectated = expectation(description: #function)
        
        sut?.sendUpdates = { (state) in
            print(state)
            switch state {
            case .looping(currentIndex: [1,0], startingIndex: [1,0],
                          currentPossibleSwapIndex: nil,
                          previousPossibleSwapIndex: nil,
                          previousIndexPath: [2,0]):
                self.sut?.pause()
                expectated.fulfill()
            default: break
            }
        }
        sut?.start()
        
        
        wait(for: [expectated], timeout: 2)
        XCTAssertEqual(sut?.state, .paused)
        XCTAssertEqual(sut?.datasource, [1, 3, 2])
    }
    
//    func test_start_completionWithDuplicates() {
//        sut?.datasource = [80, 28, 20, 16, 16, 27, 78, 89]
//        let sortedData = sut?.datasource.sorted()
//        let expectated = expectation(description: #function)
//        
//        sut?.sendUpdates = { (state) in
//            switch state {
//            case .completed:
//                expectated.fulfill()
//            default: break
//            }
//        }
//        sut?.start()
//        
//        wait(for: [expectated], timeout: 1)
//        XCTAssertEqual(sut?.datasource,
//                      sortedData)
//    }
    
    // MARK: - Helper Methods
    
    fileprivate func makeSUT() -> SelectionSortAPI {
        let datasource = [3, 2, 1]
        let sortAPI = SelectionSortAPI(datasource: datasource)
        sortAPI.currentSortSpeed?.speed = 0.05
        return sortAPI
    }
}

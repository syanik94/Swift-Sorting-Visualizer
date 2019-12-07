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
        sut = makeSUT()
        sut?.currentSortSpeed?.speed = 0.05
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Initialize

    func test_initial_state_notStarted() {
        XCTAssertEqual(sut?.state,
                       BubbleSortAPI.State.notStarted)
    }
    
    // MARK: - Sorting
            
    func test_start_completedState() {
        // given
        sut?.datasource = [3, 2, 1]
        var observedState = BubbleSortAPI.State.notStarted
        let expected = expectation(description: #function)

        // when
        sut?.sendStateUpdates = { (state) in
            observedState = state
            switch state {
                
            case .completed:
                expected.fulfill()
            default: break
            }
        }
        sut?.start()
        
        // then
        wait(for: [expected], timeout: 1)
        XCTAssertEqual(observedState, .completed)
    }
    
    func test_start_completedOutput() {
        // given
        sut?.datasource = [3, 2, 1]
        let expected = expectation(description: #function)
        // when
        sut?.sendStateUpdates = { (state) in
            switch state {
            case .completed:
                expected.fulfill()
            default: break
            }
        }
        sut?.start()

        // then
        wait(for: [expected], timeout: 1)
        XCTAssertEqual(sut?.datasource, [1, 2, 3])

    }
    
    func test_start_swapState() {
        // given
        sut?.datasource = [3, 2, 1]
        var observedState = BubbleSortAPI.State.notStarted
        let expected = expectation(description: #function)
        
        // when
        sut?.sendStateUpdates = { (state) in
            switch state {
            case .swap(_ , _):
                observedState = state
                expected.fulfill()
            default: break
            }
        }
        sut?.start()
        
        // then
        wait(for: [expected], timeout: 1)
        XCTAssertEqual(observedState, .swap(index1: [0, 0], Index2: [0, 1]))
    }
    
    func test_start_swapOutput() {
        // given
        sut?.datasource = [3, 2, 1]
        let expected = expectation(description: #function)

        // when
        sut?.sendStateUpdates = { (state) in
            switch state {
                
            case .swap(_, _):
                expected.fulfill()
            default: break
            }
        }
        sut?.start()
        
        // then
        wait(for: [expected], timeout: 1)
        XCTAssertEqual(sut?.datasource, [2, 3, 1])
    }
    
    func test_start_after_run() {
        // first run
        sut?.datasource = [3, 2, 1]
        let firstEndIndex = sut?.endIndex
        let firstExpectation = expectation(description: #function)
        sut?.sendStateUpdates = { (state) in
            if state == .completed { firstExpectation.fulfill() }
        }
        sut?.start()
        wait(for: [firstExpectation], timeout: 1)
        XCTAssertEqual(sut?.datasource, [1,2,3])
        
        // second run
        sut?.update(datasource: [10, 9, 8])
        let secondEndIndex = sut?.endIndex
        let finalExpectation = expectation(description: #function)
        sut?.sendStateUpdates = { (state) in
            if state == .completed { finalExpectation.fulfill() }
        }
        sut?.start()
        wait(for: [finalExpectation], timeout: 1)
        XCTAssertEqual(sut?.datasource, [8,9,10])
        XCTAssertEqual(firstEndIndex, secondEndIndex)
    }
    
    // MARK: - Helpers
    
    func makeSUT() -> BubbleSortAPI {
        let sortAPI = BubbleSortAPI(datasource: [1, 2, 3])
        sortAPI.currentSortSpeed?.speed = 0.2
        return sortAPI
    }
}

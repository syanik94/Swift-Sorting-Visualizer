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
        sut = SelectionSortAPI(datasource: [5])
        sut?.selectedSortSpeed = sut!.minSortSpeed
    }

    override func tearDown() {
        sut?.sendUpdates = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Initialize

    func testInit_state_waiting() {
        XCTAssertEqual(sut?.state,
                       SelectionSortAPI.State.notStarted)
    }
    
    
    func test_start_looping() {
        // given
        sut?.datasource = [3, 2, 1]
        
        // when
        sut?.start()
        
        // then
        XCTAssertEqual(sut?.state,
                       SelectionSortAPI.State.looping(currentIndex: [0,0]))
    }
    
    
    // MARK: - State - Completion & Output
    
    func test_start_completion() {
        // given
        let expectated = expectation(description: #function)
        var observedState = SelectionSortAPI.State.notStarted
        
        // when
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
        XCTAssertEqual(sut?.state,
                       SelectionSortAPI.State.completed)
    }

    func test_start_completionOutput() {
        // given
        sut?.datasource = [80, 28, 20, 16, 16, 27, 78, 89]
        let sortedData = sut?.datasource.sorted()
        let expectated = expectation(description: #function)
        
        // when
        sut?.sendUpdates = { (state) in
            switch state {
            case .completed:
                expectated.fulfill()
            default: break
            }
        }
        sut?.start()
        // [28, 20, 80, 16, 16, 27, 78, 89]
        wait(for: [expectated], timeout: 2)
        XCTAssertEqual(sut?.datasource,
                      sortedData)
    }
    
}

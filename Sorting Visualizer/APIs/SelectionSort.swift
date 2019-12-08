//
//  SelectionSortAPI.swift
//  Sorting Visualizer
//
//  Created by Yanik Simpson on 10/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

class SelectionSortAPI: SortingAlgorithm {
    enum State: Equatable {
        case notStarted
        case paused
        case looping(currentIndex: IndexPath)
        case restarting(startingIndexPath: IndexPath, swappingIndexPath: IndexPath?)
        case completed
    }
    
    var state: State = .notStarted {
        didSet {
            sendUpdates?(state)
        }
    }
    var datasource: [Int]
    lazy var endIndex = datasource.count - 1

    var currentSortSpeed: SortSpeed? {
        didSet {
            sendSpeedUpdates?(currentSortSpeed!)
        }
    }
    
    var currentIndex = 0
    var startingIndex = 0
    var possibleSwaps: [Int] = []
    
    var sendUpdates: ((State) -> ())?
    var sendSpeedUpdates: ((SortSpeed) -> Void)?

    // MARK: - Initializer

    init(datasource: [Int]) {
        self.datasource = datasource
        self.currentSortSpeed = speeds.first
    }
    
    // MARK: - API

    var timer: Timer?

    func start() {
        currentIndex = startingIndex
        state = .looping(currentIndex: [currentIndex, 0])
        timer = Timer.scheduledTimer(withTimeInterval: currentSortSpeed?.speed ?? 0.2, repeats: true, block: { [weak self] (t) in
            guard let self = self else { return }
            self.handleIndexIncrement()
            self.state = .looping(currentIndex: [self.currentIndex, 0])
            self.handleSwap()
            self.handleLoopEnd(t)
        })
    }

    func pause() {
        timer?.invalidate()
        state = .paused
    }
    
    func update(datasource: [Int]) {
        self.datasource = datasource
        startingIndex = 0
    }
        
    // MARK: - Helpers
    
    fileprivate func handleSwap() {
        if startingIndex != endIndex {
            if datasource[currentIndex] < datasource[startingIndex] {
                possibleSwaps.append(datasource[currentIndex])
                possibleSwaps.sort()
            }
        }
    }
    
    fileprivate func handleLoopEnd(_ t: Timer) {
        let didReachEndIndex = currentIndex >= endIndex
        if didReachEndIndex {
            if startingIndex == endIndex {
                state = .completed
                print(datasource)
            }
            
            if startingIndex != endIndex {
                if !possibleSwaps.isEmpty {
                    let swappingIndex: Int = datasource.findFirstIndex(from: startingIndex, of: possibleSwaps[0])
//                        datasource.firstIndex(of: possibleSwaps[0])!
                    
                    datasource.swapAt(startingIndex,
                                           swappingIndex)
                    
                    state = .restarting(startingIndexPath: [startingIndex, 0],
                                             swappingIndexPath: [swappingIndex,0])
                }
                state = .restarting(startingIndexPath: [startingIndex, 0],
                                         swappingIndexPath: nil)
                possibleSwaps.removeAll()
                startingIndex += 1
                start()
            }
            t.invalidate()
        }
    }
    
    fileprivate func handleIndexIncrement() {
        if startingIndex != endIndex {
            currentIndex += 1
        }
    }
    
}

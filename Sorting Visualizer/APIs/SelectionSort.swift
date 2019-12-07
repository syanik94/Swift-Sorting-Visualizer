//
//  SelectionSortAPI.swift
//  Sorting Visualizer
//
//  Created by Yanik Simpson on 10/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

class SelectionSortAPI: SortingAlgorithm {
    func update(datasource: [Int]) {
        
    }
    
    enum State: Equatable {
        case notStarted
        case looping(currentIndex: IndexPath)
        case restarting(startingIndexPath: IndexPath, swappingIndexPath: IndexPath?)
        case completed
    }
    
    var state: State = .notStarted {
        didSet {
            sendUpdates?(state)
        }
    }
    var sendUpdates: ((State) -> ())?
    var datasource: [Int]
    lazy var endIndex = datasource.count - 1

    
    var minSortSpeed = 0.05
    var selectedSortSpeed = 0.5
    var maxSortSpeed = 0.5
    
    var currentIndex = 0
    var startingIndex = 0
    var possibleSwaps: [Int] = []
    
    
    init(datasource: [Int]) {
        self.datasource = datasource
    }

    func start() {
        currentIndex = startingIndex
        state = .looping(currentIndex: [currentIndex, 0])
        _ = Timer.scheduledTimer(withTimeInterval: selectedSortSpeed, repeats: true, block: { [weak self] (t) in
            guard let self = self else { return }
            self.handleIndexIncrement()
            self.state = .looping(currentIndex: [self.currentIndex, 0])
            self.handleSwap()
            self.handleLoopEnd(t)
        })
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

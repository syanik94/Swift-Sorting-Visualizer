//
//  SelectionSortAPI.swift
//  Sorting Visualizer
//
//  Created by Yanik Simpson on 10/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

extension Int {
    func toIndexPath() -> IndexPath {
        return IndexPath(row: self, section: 0)
    }
}

class SelectionSortAPI: SortAPI {
    
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
    
    var minSortSpeed = 0.05
    var selectedSortSpeed = 0.5
    var maxSortSpeed = 0.5
    
    var datasource: [Int] = RectangleDataLoader().loadRectangles(6)
    lazy var endIndex = datasource.count - 1

    var sendUpdates: ((State) -> ())?
    
    
    private var currentIndex = 0
    var startingIndex = 0
    var possibleSwaps: [Int] = []
    

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
        // MARK: End of looping
        let didReachEndIndex = self.currentIndex >= self.endIndex
        if didReachEndIndex {
            if self.startingIndex == self.endIndex {
                self.state = .completed
            }
            
            if self.startingIndex != self.endIndex {
                if !self.possibleSwaps.isEmpty {
                    let swappingIndex: Int = self.datasource.firstIndex(of: self.possibleSwaps.first!)!
                    self.datasource.swapAt(self.startingIndex,
                                           swappingIndex)
                    
                    self.state = .restarting(startingIndexPath: [self.startingIndex, 0],
                                             swappingIndexPath: [swappingIndex,0])
                    self.possibleSwaps.removeAll()
                }
                self.state = .restarting(startingIndexPath: [self.startingIndex, 0],
                                         swappingIndexPath: nil)
                self.startingIndex += 1
                self.start()
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

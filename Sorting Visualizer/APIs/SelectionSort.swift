//
//  SelectionSortAPI.swift
//  Sorting Visualizer
//
//  Created by Yanik Simpson on 10/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

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
    var selectedSortSpeed = 0.1
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
        _ = Timer.scheduledTimer(withTimeInterval: maxSortSpeed, repeats: true, block: { [weak self] (t) in
            guard let self = self else { return }
            
            if self.startingIndex != self.endIndex {
                self.currentIndex += 1
            }
            self.state = .looping(currentIndex: [self.currentIndex, 0])
            
            if self.startingIndex != self.endIndex {
                if self.datasource[self.currentIndex] < self.datasource[self.startingIndex] {
                    self.possibleSwaps.append(self.datasource[self.currentIndex])
                    self.possibleSwaps.sort()
                }
            }
            
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
        })
        
    }
}

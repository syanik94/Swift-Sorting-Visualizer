//
//  BubbleSort.swift
//  Sorting Visualizer
//
//  Created by Yanik Simpson on 10/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

class BubbleSortAPI: SortAPI {
    enum State: Equatable {
        case notStarted
        case looping(currentIndex: IndexPath, previousIndex: IndexPath?)
        case restarting(endIndex: IndexPath)
        case swap(index1: IndexPath, Index2: IndexPath)
        case completed
    }
    
    var state: State = .notStarted {
        didSet {
            sendUpdates?(state)
        }
    }
    
    var minSortSpeed = 0.05
    var selectedSortSpeed = 0.1
    var maxSortSpeed = 1
    
    var datasource: [Int] 
    fileprivate lazy var endIndex = datasource.count - 1

    var sendUpdates: ((State) -> ())?
    
    init(datasource: [Int]) {
        self.datasource = datasource
    }
    
    // MARK: - API
    
    fileprivate var didPerformSwap = false

    fileprivate func performSwap(_ currentIndex: Int) {
        let shouldSwap = datasource[currentIndex] > datasource[currentIndex + 1]
        if shouldSwap {
            self.datasource.swapAt(currentIndex + 1, currentIndex)
            self.state = .swap(index1: IndexPath(row: currentIndex, section: 0),
                               Index2: IndexPath(row: currentIndex + 1, section: 0))
            didPerformSwap = true
        }
    }
    
    fileprivate func performLoop(_ currentIndex: Int, _ t: Timer) {
        let previousIndex = currentIndex - 1
        
        self.state = .looping(currentIndex: IndexPath(row: currentIndex, section: 0),
                              previousIndex: IndexPath(row: previousIndex, section: 0))
        
        let hasNotReachedEndIndex = currentIndex != self.endIndex
        if hasNotReachedEndIndex {
            self.performSwap(currentIndex)
        }
        
        let hasReachedEndIndex = currentIndex >= self.endIndex
        if hasReachedEndIndex {
            self.state = .restarting(endIndex: IndexPath(row: self.endIndex, section: 0))
            if !self.didPerformSwap {
                self.state = .completed
                t.invalidate()
            }
            if self.didPerformSwap {
                self.start()
                self.endIndex -= 1
            }
            t.invalidate()
        }
    }
    
    func start() {
        var currentIndex = 0
        didPerformSwap = false
        state = .looping(currentIndex: IndexPath(row: currentIndex, section: 0), previousIndex: nil)
        performSwap(currentIndex)
        
        _ = Timer.scheduledTimer(withTimeInterval: selectedSortSpeed, repeats: true, block: { [weak self] (t) in
            guard let self = self else { return }
            currentIndex += 1
            self.performLoop(currentIndex, t)
        })
    }
    
}


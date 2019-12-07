//
//  BubbleSort.swift
//  Sorting Visualizer
//
//  Created by Yanik Simpson on 10/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

class BubbleSortAPI: SortingAlgorithm {
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
    var maxSortSpeed = 0.7
    var selectedSortSpeed = 0.2
    
    var datasource: [Int] 
    lazy var endIndex = datasource.count - 1
    
    var sendUpdates: ((State) -> ())?
    
    // MARK: - Initializer
    
    init(datasource: [Int]) {
        self.datasource = datasource
    }
    
    // MARK: - API
    
    fileprivate var didPerformSwap = false

    fileprivate func performSwap(_ currentIndex: Int) {
        let shouldSwap = datasource[currentIndex] > datasource[currentIndex + 1]
        if shouldSwap {
            datasource.swapAt(currentIndex + 1, currentIndex)
            state = .swap(index1: IndexPath(row: currentIndex, section: 0),
                               Index2: IndexPath(row: currentIndex + 1, section: 0))
            didPerformSwap = true
        }
    }
    
    fileprivate func performLoop(_ currentIndex: Int, _ t: Timer) {
        let previousIndex = currentIndex - 1
        
        state = .looping(currentIndex: IndexPath(row: currentIndex, section: 0),
                              previousIndex: IndexPath(row: previousIndex, section: 0))
        
        let hasNotReachedEndIndex = currentIndex != endIndex
        if hasNotReachedEndIndex {
            performSwap(currentIndex)
        }
        
        let hasReachedEndIndex = currentIndex >= endIndex
        if hasReachedEndIndex {
            state = .restarting(endIndex: IndexPath(row: endIndex, section: 0))
            if !didPerformSwap {
                state = .completed
                t.invalidate()
            }
            if didPerformSwap {
                start()
                endIndex -= 1
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
    
    func update(datasource: [Int]) {
        self.datasource = datasource
        self.endIndex = datasource.count - 1
    }
}


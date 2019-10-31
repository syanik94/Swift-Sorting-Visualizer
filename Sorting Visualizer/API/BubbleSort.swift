//
//  ContentView.swift
//  Sorting Visualizer
//
//  Created by Yanik Simpson on 10/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class BubbleSortAPI {
    
    enum State: Equatable {
        case waiting
        case looping(currentIndex: IndexPath, previousIndex: IndexPath?)
        case restarting(endIndex: IndexPath)
        case swap(index1: IndexPath, Index2: IndexPath)
    }
    
    var state: State = .waiting {
        didSet {
            sendUpdates?(state)
        }
    }
    
    var datasource: [Int] = RectangleDataLoader().loadRectangles(6)
    lazy var endIndex = datasource.count - 1

    var sendUpdates: ((State) -> ())?
    
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
    
    func performLoop(_ currentIndex: Int, _ t: Timer) {
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
            if self.didPerformSwap {
                self.start()
            }
            if !self.didPerformSwap { self.state = .waiting }
            self.endIndex -= 1
            t.invalidate()
        }
    }
    
    func start() {
        var currentIndex = 0
        state = .looping(currentIndex: IndexPath(row: currentIndex, section: 0), previousIndex: nil)
        performSwap(currentIndex)
        
        _ = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true, block: { [weak self] (t) in
            guard let self = self else { return }
            currentIndex += 1
            self.performLoop(currentIndex, t)
        })
    }
}


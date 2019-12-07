//
//  BubbleSortViewController.swift
//  Sorting Visualizer
//
//  Created by Yanik Simpson on 10/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class BubbleSortViewController: GenericSortDisplayViewController {
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Bubble Sort"
        sortAPI = BubbleSortAPI(datasource: rectDataLoader.rectangles)
        observeStateUpdates()
    }
    
    // MARK: - State Observation
    
    fileprivate func observeStateUpdates() {
        guard let sortAPI = sortAPI as? BubbleSortAPI else { return }
        sortAPI.sendUpdates = { [weak self] (state) in
            guard let self = self else { return }
            print(state)
            switch state {
                
            case .notStarted:
                self.startButton.isEnabled = true
                
            case .looping(let currentIndex, let previousIndex):
                self.startButton.isEnabled = false
                if let previousIndex = previousIndex {
                    guard let previousCell = self.collectionView.cellForItem(at: previousIndex) as? RectangleCollectionViewCell else { return }
                    previousCell.rectangleView.backgroundColor = .cyan
                }
                guard let currentCell = self.collectionView.cellForItem(at: currentIndex) as? RectangleCollectionViewCell else { return }
                currentCell.rectangleView.backgroundColor = .green
                
            case .swap(let index1, let index2):
                guard let cell1 = self.collectionView.cellForItem(at: index1) as? RectangleCollectionViewCell else { return }
                guard let cell2 = self.collectionView.cellForItem(at: index2) as? RectangleCollectionViewCell else { return }
                cell1.rectangleView.backgroundColor = .green
                cell2.rectangleView.backgroundColor = .green
                
                self.collectionView.moveItem(at: index2, to: index1)

            case .restarting(let endIndex):
                guard let lastCell = self.collectionView.cellForItem(at: endIndex) as? RectangleCollectionViewCell else { return }
                lastCell.rectangleView.backgroundColor = .green
                
            case .completed:
                self.startButton.isEnabled = true
            }
        }
    }
    
}



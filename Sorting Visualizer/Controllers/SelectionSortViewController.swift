//
//  SelectionSortViewController.swift
//  Sorting Visualizer
//
//  Created by Yanik Simpson on 10/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class SelectionSortViewController: GenericSortDisplayViewController {
    
    // MARK: - Initializer

    init() {
        super.init()
        sortAPI = SelectionSortAPI(datasource: rectDataLoader.rectangles)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Selection Sort"
        observeSortingAlgorithmStateUpdates()
    }
    
    // MARK: - State Observation

    fileprivate func observeSortingAlgorithmStateUpdates() {
         guard let sortAPI = sortAPI as? SelectionSortAPI else { return }
         sortAPI.sendUpdates = { [weak self] (state) in
            guard let self = self else { return }
            switch state {
                
            case .notStarted:
                break
                
            case .looping(let currentIndex, let startingIndex, let currentPossibleSwapIndex, let previousPossibleSwapIndex,let previousIndexPath):
                
                guard let currentCell = self.collectionView.cellForItem(at: IndexPath(row: currentIndex.section, section: 0)) as? RectangleCollectionViewCell else { return }
                currentCell.rectangleView.backgroundColor = .orange
                
                
                guard let previousCell = self.collectionView.cellForItem(at: IndexPath(row: previousIndexPath.section, section: 0)) as? RectangleCollectionViewCell else { return }
                previousCell.rectangleView.backgroundColor = .cyan
                
                if let currentPossibleSwapIndex = currentPossibleSwapIndex {
                    guard let currentPossibleSwapCell = self.collectionView.cellForItem(at: IndexPath(row: currentPossibleSwapIndex.section, section: 0)) as? RectangleCollectionViewCell else { return }
                    currentPossibleSwapCell.rectangleView.backgroundColor = .green
                }
                
                if let previousPossibleSwapIndex = previousPossibleSwapIndex {
                    guard let previousPossibleSwapCell = self.collectionView.cellForItem(at: IndexPath(row: previousPossibleSwapIndex.section, section: 0)) as? RectangleCollectionViewCell else { return }
                    previousPossibleSwapCell.rectangleView.backgroundColor = .cyan
                }
                
                guard let startingCell = self.collectionView.cellForItem(at: IndexPath(row: startingIndex.section, section: 0)) as? RectangleCollectionViewCell else { return }
                startingCell.rectangleView.backgroundColor = .green
                
            case .restarting(let startingIndexPath, let swappingIndexPath, _):
                if let swappingIndexPath = swappingIndexPath {
                    self.collectionView.moveItem(at: IndexPath(row: swappingIndexPath.section, section: 0),
                                                 to: IndexPath(row: startingIndexPath.section, section: 0))
                    self.collectionView.moveItem(at: IndexPath(row: startingIndexPath.section + 1, section: 0),
                                                 to: IndexPath(row: swappingIndexPath.section, section: 0))
                    
                    guard let swappingCell = self.collectionView.cellForItem(at: IndexPath(row: swappingIndexPath.section, section: 0)) as? RectangleCollectionViewCell else { return }
                    swappingCell.rectangleView.backgroundColor = .cyan
                }
                guard let startingCell = self.collectionView.cellForItem(at: IndexPath(row: startingIndexPath.section, section: 0)) as? RectangleCollectionViewCell else { return }
                startingCell.rectangleView.backgroundColor = .cyan

            case .completed:
                self.resetRectangleColors()
                self.playerView.playButton.isSelected = false
                self.playerView.stopButton.isEnabled = true
                
            case .paused:
                self.playerView.stopButton.isEnabled = true
            }
         }
     }
}


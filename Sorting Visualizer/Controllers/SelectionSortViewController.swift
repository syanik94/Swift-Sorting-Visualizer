//
//  SelectionSortViewController.swift
//  Sorting Visualizer
//
//  Created by Yanik Simpson on 10/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class SelectionSortViewController: GenericSortDisplayViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        sortAPI = SelectionSortAPI()
        setupButtonActions()
        observeStateUpdates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       navigationItem.title = "Selection Sort"
   }
    
    // MARK: - State Observation

    fileprivate func observeStateUpdates() {
         guard let sortAPI = sortAPI as? SelectionSortAPI else { return }
         sortAPI.sendUpdates = { [weak self] (state) in

             guard let self = self else { return }
            switch state {
                
            case .notStarted:
                self.startButton.isEnabled = true
                
            case .looping(let currentIndex):
                self.startButton.isEnabled = false
                guard let cell = self.collectionView.cellForItem(at: IndexPath(row: currentIndex.section, section: 0)) as? RectangleCollectionViewCell else { return }
                cell.rectangleView.backgroundColor = .orange
                
//                guard let previousCell = self.collectionView.cellForItem(at: IndexPath(row: currentIndex.section - 1, section: 0)) as? RectangleCollectionViewCell else { return }
                
            case .restarting(let startingIndexPath, let swappingIndexPath):
                guard let cell1 = self.collectionView.cellForItem(at: IndexPath(row: startingIndexPath.section, section: 0)) as? RectangleCollectionViewCell else { return }
                cell1.rectangleView.backgroundColor = .green

                if let swappingIndexPath = swappingIndexPath {
                    guard let cell2 = self.collectionView.cellForItem(at: IndexPath(row: swappingIndexPath.section, section: 0)) as? RectangleCollectionViewCell else { return }
                    cell2.rectangleView.backgroundColor = .green
                    
                    self.collectionView.moveItem(at: IndexPath(row: swappingIndexPath.section, section: 0),
                                                 to: IndexPath(row: startingIndexPath.section, section: 0))
                    
                    self.collectionView.moveItem(at: IndexPath(row: startingIndexPath.section + 1, section: 0),
                                                 to: IndexPath(row: swappingIndexPath.section, section: 0))
                }
                
            case .completed:
                self.startButton.isEnabled = true
            }
         }
     }
    

    // MARK: - View Setup
    
    fileprivate func setupButtonActions() {
        resetButton.addTarget(self, action: #selector(handleResetTap), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(handleStartTap), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc fileprivate func handleStartTap(_ sender: UIButton) {
        sortAPI?.start()
    }
    
    @objc fileprivate func handleResetTap(_ sender: UIButton) {
        // TODO: - Handle Reset
    }
}

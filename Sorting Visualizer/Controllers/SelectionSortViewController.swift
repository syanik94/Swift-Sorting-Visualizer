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

         }
     }
    

    // MARK: - View Setup
    
    private func setupButtonActions() {
        resetButton.addTarget(self, action: #selector(handleResetTap), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(handleStartTap), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc fileprivate func handleStartTap(_ sender: UIButton) {
        guard let sortAPI = sortAPI as? SelectionSortAPI else { return }
        sortAPI.start()
    }
    
    @objc fileprivate func handleResetTap(_ sender: UIButton) {
        // TODO: - Handle Reset
    }
}

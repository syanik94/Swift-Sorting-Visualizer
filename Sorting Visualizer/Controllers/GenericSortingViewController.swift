//
//  GenericSortingViewController.swift
//  Sorting Visualizer
//
//  Created by Yanik Simpson on 10/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class GenericSortDisplayViewController: UIViewController {
    
    // MARK: - Dependencies
    
    var rectDataLoader: RectangleDataLoader
    var sortAPI: SortingAlgorithm?
    
    // MARK: - Views
    
    lazy var layout: UICollectionViewFlowLayout = {
        let flow = UICollectionViewFlowLayout()
        return flow
    }()
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(RectangleCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .tertiarySystemGroupedBackground
        cv.isScrollEnabled = false
        cv.allowsSelection = false
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    lazy var playerView: PlayerView = {
        let v = PlayerView()
        v.playButton.addTarget(self, action: #selector(handleStartTap), for: .touchUpInside)
        v.stopButton.addTarget(self, action: #selector(handleResetTap), for: .touchUpInside)
        v.speedButton.addTarget(self, action: #selector(handleSpeedChangeTap), for: .touchUpInside)
        return v
    }()
    

    init(rectLoader: RectangleDataLoader = .init(rectsToLoad: 5)) {
        self.rectDataLoader = rectLoader
        super.init(nibName: nil, bundle: nil)
        rectDataLoader.load(rectsToLoad: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle Methods
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
        setupCollectionView()
        setupPlayerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        receiveSpeedUpdates()
    }
    
    // MARK: - View Set up
    
    fileprivate func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 32).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 3).isActive = true
    }
    
    fileprivate func setupPlayerView() {
        view.addSubview(playerView)
        playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    // MARK: - View Updates
    
    fileprivate func receiveSpeedUpdates() {
        sortAPI?.sendSpeedUpdates = { [weak self] (speed) in
            guard let self = self else { return }
            self.playerView.speedButton.setTitle(speed.description, for: .normal)
        }
    }
    
    // MARK: - Actions

    @objc fileprivate func handleStartTap(_ sender: UIButton) {
        let playState = sender.isSelected
        if !playState {
            sortAPI?.start()
            playerView.stopButton.isEnabled = false
        }
        if playState {
            sortAPI?.pause()
        }
        sender.isSelected = !sender.isSelected
    }
    
    @objc fileprivate func handleResetTap(_ sender: UIButton) {
        rectDataLoader.reset()
        sortAPI?.update(datasource: rectDataLoader.rectangles)
        resetRectangleColors()
        collectionView.reloadData()
    }
    
    @objc fileprivate func handleSpeedChangeTap(_ sender: UIButton) {
        sortAPI?.toggleSortSpeed()
    }
    
    fileprivate func resetRectangleColors() {
        guard let rectangleCollectionViewCells = collectionView.visibleCells as? [RectangleCollectionViewCell] else { return }
        
        rectangleCollectionViewCells.forEach { (cell) in
            cell.rectangleView.backgroundColor = .cyan
        }
    }
}

// MARK: - CollectionView Delegate & Datasource Methods

extension GenericSortDisplayViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortAPI?.datasource.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? RectangleCollectionViewCell else { return UICollectionViewCell() }
        cell.rectHeight = sortAPI?.datasource[indexPath.item]
        return cell
    }
}

extension GenericSortDisplayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: collectionView.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 24, bottom: 4, right: 24)
    }
}






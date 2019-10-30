//
//  BubbleSortViewController.swift
//  Sorting Visualizer
//
//  Created by Yanik Simpson on 10/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class BubbleSortViewController: UIViewController {
    
    // MARK: - Dependencies
    
    let bubbleSortAPI = BubbleSortAPI()

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
        cv.allowsSelection = false
        cv.delegate = self
        cv.dataSource = self
        cv.layer.masksToBounds = true
        cv.layer.cornerRadius = 12
        return cv
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleStartTap), for: .touchUpInside)
        button.setTitle("START", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        button.backgroundColor = UIColor(white: 0.15, alpha: 0.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        return button
    }()
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        setupButton()
        observeStateUpdates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Bubble Sort"
    }
    
    // MARK: - State Observation
    
    fileprivate func observeStateUpdates() {
        bubbleSortAPI.sendUpdates = { [weak self] (state) in
            guard let self = self else { return }
            switch state {
                
            case .waiting:
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
            }
        }
    }
    
    // MARK: - View Setup
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 32).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 3).isActive = true
    }
    
    private func setupButton() {
        view.addSubview(startButton)
        startButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 50).isActive = true
        startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -32).isActive = true
    }
    
    // MARK: - Actions
    
    @objc fileprivate func handleStartTap(_ sender: UIButton) {
        bubbleSortAPI.start()
    }
}

// MARK: - CollectionView Delegate & Datasource Methods

extension BubbleSortViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bubbleSortAPI.datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? RectangleCollectionViewCell else { return UICollectionViewCell() }
        cell.rectHeight = bubbleSortAPI.datasource[indexPath.item]
        return cell
    }
}

extension BubbleSortViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: collectionView.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 24, bottom: 4, right: 24)
    }
}



//
//  GenericSortingViewController.swift
//  Sorting Visualizer
//
//  Created by Yanik Simpson on 10/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

protocol SortAPI {
    var datasource: [Int] { get set }
    var minSortSpeed: Double { get set }
    var maxSortSpeed: Double { get set }
    var selectedSortSpeed: Double { get set }
    func start()
}

class GenericSortDisplayViewController: UIViewController {
    
    lazy var rectDataLoader: RectangleDataLoader = {
        let dl = RectangleDataLoader(rectsToLoad: 5)
        return dl
    }()
    
    var sortAPI: SortAPI?
    
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
        cv.layer.masksToBounds = true
        cv.layer.cornerRadius = 12
        return cv
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("START", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        button.backgroundColor = UIColor(white: 0.15, alpha: 0.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        return button
    }()
    
    lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("Reset", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .heavy)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCollectionView()
        setupButtons()
        rectDataLoader.load(rectsToLoad: 5)
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 32).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 3).isActive = true
    }
    
    private func setupButtons() {
        view.addSubview(startButton)
        startButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 50).isActive = true
        startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -32).isActive = true
        
        view.addSubview(resetButton)
        resetButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 16).isActive = true
        resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -32).isActive = true
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






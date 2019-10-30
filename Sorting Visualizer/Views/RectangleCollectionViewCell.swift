//
//  RectangleCollectionViewCell.swift
//  Sorting Visualizer
//
//  Created by Yanik Simpson on 10/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class RectangleCollectionViewCell: UICollectionViewCell {
    var rectHeight: Int? {
        didSet {
            if let rectHeight = rectHeight {
                let heightRatio = CGFloat(rectHeight) / 100
                let adjustedHeight = (self.frame.height) * heightRatio
                valueLabel.text = "\(rectHeight)"
                setupRectView(adjustedHeight)
            }
        }
    }
        
    let valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var rectangleView: UIView = {
        let v = UIView()
        v.layer.masksToBounds = true
        v.backgroundColor = .cyan
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupRectView(_ height: CGFloat) {
        addSubview(rectangleView)
        rectangleView.translatesAutoresizingMaskIntoConstraints = false
        rectangleView.heightAnchor.constraint(equalToConstant: height).isActive = true
        rectangleView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        rectangleView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        rectangleView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        addSubview(valueLabel)
        valueLabel.bottomAnchor.constraint(equalTo: rectangleView.bottomAnchor).isActive = true
        valueLabel.leadingAnchor.constraint(equalTo: rectangleView.leadingAnchor).isActive = true
        valueLabel.trailingAnchor.constraint(equalTo: rectangleView.trailingAnchor).isActive = true
        
        rectangleView.layoutIfNeeded()
    }
}

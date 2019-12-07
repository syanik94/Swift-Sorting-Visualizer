//
//  SpeedAdjustmentStackView.swift
//  Sorting Visualizer
//
//  Created by Yanik Simpson on 12/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class SpeedAdjustmentStackView: UIStackView {
    
    fileprivate lazy var descriptionText: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        l.text = "Sort Speed:"
        return l
    }()
    
    lazy var valueLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        l.text = "0.2s"
        return l
    }()
    
    fileprivate lazy var descriptionStackview: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [descriptionText, valueLabel])
        sv.axis = .horizontal
        sv.spacing = 1
        sv.distribution = .fill
        return sv
    }()
    
    lazy var speedAdjustment: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.isContinuous = true
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .horizontal
        spacing = 6
        distribution = .fill
        translatesAutoresizingMaskIntoConstraints = false
        addArrangedSubview(descriptionStackview)
        addArrangedSubview(speedAdjustment)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

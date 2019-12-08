//
//  PlayerView.swift
//  Sorting Visualizer
//
//  Created by Yanik Simpson on 12/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class PlayerView: UIView {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 70)
    }
    
    let playButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("", for: .normal)
        b.setTitle("", for: .selected)
        b.tintColor = .clear
        let playImage = UIImage(systemName: "play.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let stopImage = UIImage(systemName: "pause.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        b.setImage(playImage, for: .normal)
        b.setImage(stopImage, for: .selected)
        return b
    }()
    
    let stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("RESET", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        return button
    }()
    
    let speedButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("1x", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        return b
    }()
    
    fileprivate lazy var actionButtonStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [playButton, stopButton])
        sv.axis = .horizontal
        sv.spacing = 18
        sv.distribution = .fill
        return sv
    }()
    
    fileprivate lazy var contentStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [actionButtonStackView, speedButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 45
        sv.distribution = .fill
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.systemGray4.withAlphaComponent(0.35)
        addSubview(contentStackView)
        contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 8
    }
    
}

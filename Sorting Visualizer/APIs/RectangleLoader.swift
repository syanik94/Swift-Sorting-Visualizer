//
//  RectangleLoader.swift
//  Sorting Visualizer
//
//  Created by Yanik Simpson on 10/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

struct RectangleDataLoader {
    
    private(set) var rectangles: [Int] = []
    private var rectsToLoad: Int
    
    init(rectsToLoad: Int) {
        self.rectsToLoad = rectsToLoad
    }
    
    mutating func load(rectsToLoad: Int) {
        self.rectsToLoad = rectsToLoad
        for _ in 0..<rectsToLoad {
            let number = Int.random(in: 5 ..< 100)
                rectangles.append(number)
        }
    }
    
    mutating func reset() {
        rectangles.removeAll()
        load(rectsToLoad: rectsToLoad)
    }
}

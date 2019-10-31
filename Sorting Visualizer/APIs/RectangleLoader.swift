//
//  RectangleLoader.swift
//  Sorting Visualizer
//
//  Created by Yanik Simpson on 10/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

struct RectangleDataLoader {
    func loadRectangles(_ rectsToLoad: Int) -> [Int] {
        var rectangles: [Int] = []
        for _ in 0..<rectsToLoad {
            let number = Int.random(in: 5 ..< 100)
                    rectangles.append(number)
        }
        return rectangles
    }
}

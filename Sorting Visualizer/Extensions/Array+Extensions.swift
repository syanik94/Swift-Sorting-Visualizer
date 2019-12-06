//
//  Extensions.swift
//  Sorting Visualizer
//
//  Created by Yanik Simpson on 12/6/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    func findFirstIndex(from starting: Int, of: Element) -> Int {
        var count = starting
        for index in starting..<self.count - 1 {
            if self[index] == of {
                return count
            }
            count += 1
        }
        return count
    }
}

extension Array where Element: Equatable {
    mutating func removeAllExcept(_ index: Int) -> [Element] {
        let itemToKeep = [self[index]]
        self.removeAll()
        return itemToKeep
    }
}

//  Created by Krys Jurgowski on 12/2/18.
//  Copyright © 2018 United States. All rights reserved.

import Foundation

func day1a(_ input: String) -> String {
    let numbers = input.components(separatedBy: CharacterSet.newlines).map { Int($0)! }
    let sum = numbers.reduce(0, +)
    return "\(sum)"
}

func day1b(_ input: String) -> String {
    let numbers = input.components(separatedBy: CharacterSet.newlines).map { Int($0)! }
    var currentFrequency = 0
    var allFrequencies = Set<Int>()
    while (true) {
        for delta in numbers {
            currentFrequency += delta
            if allFrequencies.contains(currentFrequency) {
                return "\(currentFrequency)"
            }
            allFrequencies.insert(currentFrequency)
        }
    }
}

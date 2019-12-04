//  Created by Krys Jurgowski on 12/1/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func day4a(_ input: String) -> Int {
    let range = input
        .components(separatedBy: "-")
        .compactMap { Int($0) }

    return (range[0]...range[1]).filter { _hasPair($0) && _continuous($0)}.count
}

func day4b(_ input: String) -> Int {
    let range = input
        .components(separatedBy: "-")
        .compactMap { Int($0) }

    return (range[0]...range[1]).filter { _hasExactPair($0) && _continuous($0)}.count
}

private func _hasPair(_ num: Int) -> Bool {
    var curr = num
    while curr > 10 {
        if (curr % 100) % 11 == 0 {
            return true
        }
        curr /= 10
    }
    return false
}

private func _continuous(_ num: Int) -> Bool {
    var curr = num
    var digit = curr % 10
    while curr > 10 {
        curr /= 10
        if digit < curr % 10 {
            return false
        }
        digit = curr % 10
    }
    return true
}

private func _hasExactPair(_ num: Int) -> Bool {
    var curr = num
    while curr > 10 {
        if (curr % 100) % 11 == 0 {
            if (curr % 1000) % 111 != 0 {
                return true
            }
            let digit = curr % 10
            while curr % 10 == digit {
                curr /= 10
            }
            continue
        }
        curr /= 10
    }
    return false
}

//  Created by Krys Jurgowski on 12/1/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func day1a(_ input: String) -> Int {
    let masses = input.components(separatedBy: CharacterSet.newlines).map { Int($0)! }
    return masses.map(_fuel(mass:)).reduce(0, +)
}

func day1b(_ input: String) -> Int {
    var masses = input.components(separatedBy: CharacterSet.newlines).map { Int($0)! }
    var totalFuel = 0
    while masses.count > 0 {
        masses = masses.map(_fuel(mass:)).filter {$0 > 0}
        totalFuel += masses.reduce(0, +)
    }
    return totalFuel
}

private func _fuel(mass: Int) -> Int {
    return (mass / 3) - 2
}

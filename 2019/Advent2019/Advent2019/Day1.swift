//  Created by Krys Jurgowski on 12/1/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func day1a(_ input: String) -> String {
    let masses = input.components(separatedBy: CharacterSet.newlines).map { Int($0)! }
    let totalFuel = masses.reduce(0) { (currentFuel, mass) -> Int in
        return currentFuel + _fuel(mass: mass)
    }
    return "\(totalFuel)"
}

func day1b(_ input: String) -> String {
    let masses = input.components(separatedBy: CharacterSet.newlines).map { Int($0)! }
    let totalFuel = masses.reduce(0) { (currentFuel, mass) -> Int in
        var fuel = _fuel(mass: mass)
        var fuelSum = 0
        while fuel > 0 {
            fuelSum += fuel
            fuel = _fuel(mass: fuel)
        }
        return currentFuel + fuelSum
    }
    return "\(totalFuel)"
}

private func _fuel(mass: Int) -> Int {
    return (mass / 3) - 2
}

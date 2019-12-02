//  Created by Krys Jurgowski on 12/1/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func day1a(_ input: String) -> Int {
    let masses = input.components(separatedBy: CharacterSet.newlines).map { Int($0)! }
    return masses.reduce(0) { (currentFuel, mass) -> Int in
        return currentFuel + _fuel(mass: mass)
    }
}

func day1b(_ input: String) -> Int {
    let masses = input.components(separatedBy: CharacterSet.newlines).map { Int($0)! }
    return masses.reduce(0) { (currentFuel, mass) -> Int in
        var fuelSum = 0
        var fuel = _fuel(mass: mass)
        while fuel > 0 {
            fuelSum += fuel
            fuel = _fuel(mass: fuel)
        }
        return currentFuel + fuelSum
    }
}

private func _fuel(mass: Int) -> Int {
    return (mass / 3) - 2
}

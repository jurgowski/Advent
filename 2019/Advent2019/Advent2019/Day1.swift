//  Created by Krys Jurgowski on 12/1/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func day1a(_ input: String) -> String {
    let masses = input.components(separatedBy: CharacterSet.newlines).map { Int($0)! }
    let totalFuel = masses.reduce(0) { (currentFuel, mass) -> Int in
        return currentFuel + (mass / 3) - 2
    }
    return "\(totalFuel)"
}

func day1b(_ input: String) -> String {
    let masses = input.components(separatedBy: CharacterSet.newlines).map { Int($0)! }
    let totalFuel = masses.reduce(0) { (currentFuel, mass) -> Int in
        var fuel = (mass / 3) - 2
        var fuelSum = 0
        while fuel > 0 {
            fuelSum += fuel
            fuel = (fuel / 3) - 2
        }
        return currentFuel + fuelSum
    }
    return "\(totalFuel)"
}

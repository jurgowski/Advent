//  Created by Krys Jurgowski on 12/1/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func day1a(_ input: String) -> Int {
    let masses = input.components(separatedBy: CharacterSet.newlines).map { Int($0)! }
    return masses
        .compactMap(_fuel(mass:))
        .reduce(0, +)
}

func day1b(_ input: String) -> Int {
    let masses = input.components(separatedBy: CharacterSet.newlines).map { Int($0)! }
    return masses
        .compactMap(_fuel(mass:))
        .compactMap({
            sequence(first: $0, next:_fuel(mass:)).reduce(0, +)
        })
        .reduce(0, +)
}

private func _fuel(mass: Int) -> Int? {
    return mass < 6 ? nil : (mass / 3) - 2
}

//  Created by Krys Jurgowski on 12/1/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func day1(_ input: String) -> (Int, Int) {
    let masses = input
        .components(separatedBy: CharacterSet.newlines)
        .compactMap { Int($0) }

    return (
        masses
            .compactMap(_fuel)
            .reduce(0, +),
        masses
            .compactMap(_fuel)
            .map { sequence(first: $0, next:_fuel).reduce(0, +) }
            .reduce(0, +))
}

private func _fuel(_ mass: Int) -> Int? {
    return mass < 6 ? nil : (mass / 3) - 2
}

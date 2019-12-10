//  Created by Krys Jurgowski on 12/1/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func day6(_ input: String) -> (Int, Int) {
    let orbits = input
        .components(separatedBy: CharacterSet.newlines)
        .map { $0.components(separatedBy: ")") }

    let map = orbits.reduce(into: [:]) { $0[$1[1]] = $1[0] }
    let totalOrbits = map.keys.reduce(0) { $0 + Array(sequence(first: $1) { map[$0] }).count - 1 }

    let path:  [String] = sequence(first: "YOU") { map[$0] }.reversed()
    let sPath: [String] = sequence(first: "SAN") { map[$0] }.reversed()
    let matchCount = zip(path, sPath).reduce(0) { $0 + ($1.0 == $1.1 ? 1 : 0) } + 1

    return (totalOrbits,
            path.count + sPath.count - (matchCount * 2))
}

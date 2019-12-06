//  Created by Krys Jurgowski on 12/1/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func day6a(_ input: String) -> Int {
    let orbits = input
        .components(separatedBy: CharacterSet.newlines)
        .map { $0.components(separatedBy: ")") }

    var map = [String: String]()
    orbits.forEach { map[$0[1]] = $0[0] }

    return map.keys.reduce(0) { $0 + Array(sequence(first: $1) { map[$0] }).count - 1 }
}

func day6b(_ input: String) -> Int {
    let orbits = input
        .components(separatedBy: CharacterSet.newlines)
        .map { $0.components(separatedBy: ")") }

    var map = [String: String]()
    orbits.forEach { map[$0[1]] = $0[0] }

    var path: [String] = Array(sequence(first: "YOU") { map[$0] }).reversed()
    var sPath: [String] = Array(sequence(first: "SAN") { map[$0] }).reversed()

    while path.first == sPath.first {
        path.removeFirst()
        sPath.removeFirst()
    }

    return path.count + sPath.count - 2
}

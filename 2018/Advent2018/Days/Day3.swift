//  Created by Krys Jurgowski on 12/3/18.
//  Copyright © 2018 United States. All rights reserved.

import Foundation

func day3a(_ input: String) -> String {
    let claims = input.components(separatedBy: CharacterSet.newlines).map() { Claim(string: $0) }
    var grid = Array(repeating: Array(repeating: 0, count: 1000), count: 1000)
    for claim in claims {
        for i in 0..<claim.width {
            for j in 0..<claim.length {
                grid[claim.x + i][claim.y + j] += 1
            }
        }
    }
    return "\(grid.reduce(0) { $1.reduce($0) { $0 + ($1 > 1 ? 1 : 0) }})"
}

func day3b(_ input: String) -> String {
    let claims = input.components(separatedBy: CharacterSet.newlines).map() { Claim(string: $0) }
    var grid = Array(repeating: Array(repeating: 0, count: 1000), count: 1000)
    var cleanClaims = Set<Int>()
    for claim in claims {
        var isClean = true
        for i in 0..<claim.width {
            for j in 0..<claim.length {
                let currentClaim = grid[claim.x + i][claim.y + j]
                if currentClaim != 0 {
                    isClean = false
                }
                if cleanClaims.contains(currentClaim) {
                    cleanClaims.remove(currentClaim)
                }
                grid[claim.x + i][claim.y + j] = claim.id
            }
        }
        if isClean {
            cleanClaims.insert(claim.id)
        }
    }
    return "\(cleanClaims.first!)"
}

struct Claim {
    let id: Int
    let x: Int
    let y: Int
    let width: Int
    let length: Int

    init(string: String) {
        let components = string.components(separatedBy: CharacterSet.whitespaces)
        id = Int(components[0].dropFirst())!
        let coordinates = components[2].dropLast().components(separatedBy: ",")
        x = Int(coordinates[0])!
        y = Int(coordinates[1])!
        let area = components[3].components(separatedBy: "x")
        width = Int(area[0])!
        length = Int(area[1])!
    }
}

//  Created by Krys Jurgowski on 12/2/18.
//  Copyright © 2018 United States. All rights reserved.

import Foundation

func day6a(_ input: String) -> String {
    var coords = input.components(separatedBy: CharacterSet.newlines).map { Position(string: $0) }
    let maxY = coords.max { $0.y < $1.y }!.y + 1
    let maxX = coords.max { $0.x < $1.x }!.x + 1

    var ineligible = Set<Int>()
    var instances = [Int:Int]()

    for x in 0...maxX {
        for y in 0...maxY {
            coords.sort { $0.distance(x:x, y:y) < $1.distance(x:x, y:y) }
            if coords[0].distance(x: x, y: y) < coords[1].distance(x: x, y: y) {
                instances[coords[0].id] = (instances[coords[0].id] ?? 0) + 1
                if x == 0 || x == maxX || y == 0 || y == maxY {
                    ineligible.insert(coords[0].id)
                }
            }
        }
    }
    ineligible.forEach { instances.removeValue(forKey: $0) }
    return "\(instances.values.max()!)"
}

func day6b(_ input: String) -> String {
    let coords = input.components(separatedBy: CharacterSet.newlines).map { Position(string: $0) }
    let maxY = coords.max { $0.y < $1.y }!.y + 1
    let maxX = coords.max { $0.x < $1.x }!.x + 1

    var spots = 0

    for y in 0...maxY {
        for x in 0...maxX {
            let distances = coords.reduce(0) { $0 + $1.distance(x: x, y: y) }
            if 10000 > distances {
                spots += 1
            }
        }
    }

    return "\(spots)"
}

fileprivate struct Position {
    static var index: Int = 0
    let id: Int
    let x: Int
    let y: Int

    init(string: String) {
        let coords = string.components(separatedBy: ",")
        Position.index += 1
        id = Position.index
        x = Int(coords[0].trimmingCharacters(in: CharacterSet.whitespaces))!
        y = Int(coords[1].trimmingCharacters(in: CharacterSet.whitespaces))!
    }

    func distance(x aX: Int, y aY: Int) -> Int {
        return abs(x - aX) + abs(y - aY)
    }
}



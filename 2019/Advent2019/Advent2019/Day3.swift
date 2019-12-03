//  Created by Krys Jurgowski on 12/1/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

struct Point: Hashable {
    let x :Int
    let y: Int
}

func day3a(_ input: String) -> Int {
    let wires = input
        .components(separatedBy: CharacterSet.newlines)

    let wireSet1 = _wireSet(wire: wires[0])
    let wireSet2 = _wireSet(wire: wires[1])

    let joined = wireSet1.0.intersection(wireSet2.0)
    return joined.map { abs($0.x) + abs($0.y) }.min() ?? 0
}

func day3b(_ input: String) -> Int {
    let wires = input
        .components(separatedBy: CharacterSet.newlines)

    let wireSet1 = _wireSet(wire: wires[0])
    let wireSet2 = _wireSet(wire: wires[1])

    let joined = wireSet1.0.intersection(wireSet2.0)
    return joined.map { wireSet1.1[$0]! + wireSet2.1[$0]! }.min() ?? 0
}

private func _wireSet(wire: String) -> (Set<Point>, [Point:Int]) {
    var currPoint = Point(x: 0, y: 0)
    var totalDistance = 0

    var wireSet = Set<Point>()
    var wireMap = [Point: Int]()
    let wirePath = wire.components(separatedBy: ",")

    let progress = { (dirDistance: Int, update:(Point) -> Point) in
        var distance = dirDistance
        while distance > 0 {
            currPoint = update(currPoint)
            wireSet.insert(currPoint)
            distance -= 1
            totalDistance += 1
            wireMap[currPoint] = totalDistance
        }
    }

    for wireMove in wirePath {
        let distance = Int(wireMove.dropFirst())!
        switch wireMove.first {
        case "R": progress(distance, { Point(x: $0.x + 1, y: $0.y) })
        case "D": progress(distance, { Point(x: $0.x, y: $0.y - 1) })
        case "U": progress(distance, { Point(x: $0.x, y: $0.y + 1) })
        case "L": progress(distance, { Point(x: $0.x - 1, y: $0.y) })
        default: fatalError()
        }
    }
    return (wireSet, wireMap)
}

//  Created by Krys Jurgowski on 12/1/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func day3(_ input: String) -> (Int, Int) {
    let wires = input.components(separatedBy: CharacterSet.newlines)
    let wireMap1 = _wireMap(wire: wires[0])
    let wireMap2 = _wireMap(wire: wires[1])
    let intersections = Set(wireMap1.keys).intersection(Set(wireMap2.keys))
    return (intersections.map { abs($0.x) + abs($0.y) }.min() ?? 0,
            intersections.map { wireMap1[$0]! + wireMap2[$0]! }.min() ?? 0)
}

private func _wireMap(wire: String) -> [Point:Int] {
    var currPoint = Point(x: 0, y: 0)
    var totalDistance = 0
    var wireMap = [Point: Int]()
    let wirePath = wire.components(separatedBy: ",")

    let progress = { (dirDistance: Int, update:(Point) -> Point) in
        (0..<dirDistance).forEach { _ in
            currPoint = update(currPoint)
            totalDistance += 1
            wireMap[currPoint] = totalDistance
        }
    }

    wirePath.forEach { wireMove in
        let distance = Int(wireMove.dropFirst())!
        switch wireMove.first {
        case "R": progress(distance, { Point(x: $0.x + 1, y: $0.y) })
        case "D": progress(distance, { Point(x: $0.x, y: $0.y - 1) })
        case "U": progress(distance, { Point(x: $0.x, y: $0.y + 1) })
        case "L": progress(distance, { Point(x: $0.x - 1, y: $0.y) })
        default: fatalError()
        }
    }
    return wireMap
}

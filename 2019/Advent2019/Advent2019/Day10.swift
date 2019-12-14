//  Created by Krys Jurgowski on 12/9/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation
import Accelerate

func day10(_ input: String) -> (Int, Int) {
    let map = input
        .components(separatedBy: CharacterSet.newlines)
        .compactMap { $0.map { String($0) } }

    var points = Set<Point>()
    for (y, rows) in map.enumerated() {
        for (x, _) in rows.enumerated() {
            if map[y][x] == "#" {
                points.insert(Point(x: x, y: y))
            }
        }
    }

    var pointCount = [Point: Int]()
    for point in points {
        var count = 0
        for other in points {
            count += _visible(map, start: point, goal: other) ? 1 : 0
        }
        pointCount[point] = count
    }

    let bestPoint = pointCount.max { $0.value < $1.value }!

    var visiblePoints = Set<Point>()
    for other in points {
        if _visible(map, start: bestPoint.key, goal: other) {
            visiblePoints.insert(other)
        }
    }

    let polar = visiblePoints
        .map { return ($0, _polar(start:bestPoint.key, goal:$0)) }
        .map { ($0.0, ($0.1 < -90 ? $0.1 + 360 : $0.1)) }
        .sorted { $0.1 < $1.1 }
        .map { $0.0 }

    let target = polar[199]
    return (bestPoint.value, target.x * 100 + target.y)
}

private func _visible(_ map: [[String]], start: Point, goal: Point) -> Bool {
    if start == goal {
        return false
    }
    let dx = goal.x - start.x
    let dy = goal.y - start.y

    let common = _gcd(abs(dx), abs(dy))
    let stepdx = dx / common
    let stepdy = dy / common
    var steps = 1
    var next = Point(x: start.x + (stepdx * steps), y: start.y + (stepdy * steps))
    while next != goal {
        if _read(map, point: next) == "#" {
            return false
        }
        steps += 1
        next = Point(x: start.x + (stepdx * steps), y: start.y + (stepdy * steps))
    }
    return true
}

private func _polar(start: Point, goal: Point) -> Double {
    let rectangularCoordinates = [Double(goal.x - start.x),
                                  Double(goal.y - start.y)]
    var polarCoordinates: [Double] = [0, 0]

    let stride = vDSP_Stride(2)
    vDSP_polarD(rectangularCoordinates, stride,
                &polarCoordinates, stride,
                vDSP_Length(1))
    return Measurement(value: polarCoordinates[1], unit: UnitAngle.radians)
        .converted(to: UnitAngle.degrees)
        .value
}

private func _read(_ map: [[String]], point: Point) -> String {
    return map[point.y][point.x]
}

private func _gcd(_ m: Int, _ n: Int) -> Int {
    var a: Int = 0
    var b: Int = max(m, n)
    var r: Int = min(m, n)

    while r != 0 {
        a = b
        b = r
        r = a % b
    }
    return b
}

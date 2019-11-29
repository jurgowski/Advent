//  Created by Krys Jurgowski on 12/2/18.
//  Copyright © 2018 United States. All rights reserved.

import Foundation

func day10a(_ input: String) -> String {
    let points = input.components(separatedBy: CharacterSet.newlines).map() { Point($0) }
    points.forEach() { $0.advance(10942) }
    printPoints(points, x: 400, y: 300)
    return ""
}

func day10b(_ input: String) -> String {
    return ""
}

fileprivate func printPoints(_ points: [Point], x: Int, y: Int) {
    let pointSet: Set<GridPoint> = Set(points.map() {$0.position })
    for j in 0..<y {
        for i in 0..<x {
            print(pointSet.contains(GridPoint(x: i, y: j)) ? "#" : " ", terminator: "")
        }
        print()
    }
}

fileprivate class Point {
    var position: GridPoint
    let velocity: (Int, Int)

    init(_ input: String) {
        let parts = input.components(separatedBy: "> velocity=<")
        let posText = parts[0].components(separatedBy: "<")[1].components(separatedBy: ", ")
        position = GridPoint(x: Int(posText[0].trimmingCharacters(in: CharacterSet.whitespaces))!,
                             y: Int(posText[1].trimmingCharacters(in: CharacterSet.whitespaces))!)
        let velText = parts[1].dropLast().components(separatedBy: ", ")
        velocity = (Int(velText[0].trimmingCharacters(in: CharacterSet.whitespaces))!,
                    Int(velText[1].trimmingCharacters(in: CharacterSet.whitespaces))!)
    }

    func advance(_ seconds: Int) {
        position.x += (velocity.0 * seconds)
        position.y += (velocity.1 * seconds)
    }
}

fileprivate struct GridPoint: Hashable {
    var x: Int
    var y: Int

    static func == (lhs: GridPoint, rhs: GridPoint) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

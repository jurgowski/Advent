//  Created by Krys Jurgowski on 12/2/18.
//  Copyright © 2018 United States. All rights reserved.

import Foundation

func day17a(_ input: String) -> String {
    let rows = input.components(separatedBy: CharacterSet.newlines)
    var clay = Set<GridPoint>()
    rows.forEach { (row) in
        let coords = row.components(separatedBy: ", ")
        let left = Int(coords[0].components(separatedBy: "=").last!)!
        let range = coords[1].components(separatedBy: "=").last!.components(separatedBy: "..")
        for i in Int(range[0])!...Int(range[1])! {
            clay.insert(GridPoint(x: row.first == "x" ? left : i, y: row.first == "x" ? i : left))
        }
    }
    let minX = clay.map() { $0.x }.min()!
    let maxX = clay.map() { $0.x }.max()! + 2
    let minY = clay.map() { $0.y }.min()!
    let maxY = clay.map() { $0.y }.max()!

    var water = Set<GridPoint>()
    var flow = Set<GridPoint>()
    let start = GridPoint(x: 500, y: minY)
    flow.insert(start)

    var current = [GridPoint]()
    current.append(start.below())

    let emptyCheck: (GridPoint) -> Bool = {
        return !water.contains($0) && !clay.contains($0) && !flow.contains($0)
    }

    let wallCheck: (GridPoint) -> Bool = {
        return water.contains($0) || clay.contains($0)
    }

    let stagnate: (GridPoint) -> Void = {
        water.insert($0)
        flow.remove($0)
    }

    let hitsLeftWall: (GridPoint) -> Bool = {
        var leftPoint = $0
        while flow.contains(leftPoint.left()) {
            leftPoint = leftPoint.left()
        }
        return wallCheck(leftPoint.left())
    }

    let hitsRightWall: (GridPoint) -> Bool = {
        var rightPoint = $0
        while flow.contains(rightPoint.right()) {
            rightPoint = rightPoint.right()
        }
        return wallCheck(rightPoint.right())
    }

    let stagnateRow: (GridPoint) -> Void = {
        var leftPoint = $0
        while flow.contains(leftPoint.left()) {
            leftPoint = leftPoint.left()
        }
        while flow.contains(leftPoint.right()) {
            stagnate(leftPoint)
            leftPoint = leftPoint.right()
        }
        stagnate(leftPoint)
    }

    while !current.isEmpty {
        let point = current.last!
        flow.insert(point)

        if emptyCheck(point.below()) {
            if point.below().y <= maxY {
                flow.insert(point.below())
                current.append(point.below())
            } else {
                current.removeLast()
            }
            continue
        }

        if flow.contains(point.below()) {
            current.removeLast()
            continue
        }

        if wallCheck(point.below()) {
            if emptyCheck(point.left()) {
                var leftPoint = point
                while emptyCheck(leftPoint.left()) && wallCheck(leftPoint.below()) {
                    leftPoint = leftPoint.left()
                    flow.insert(leftPoint)
                }
                if !wallCheck(leftPoint.below()) {
                    current.append(leftPoint)
                    continue
                }
            }

            if emptyCheck(point.right()) {
                var rightPoint = point
                while emptyCheck(rightPoint.right()) && wallCheck(rightPoint.below()) {
                    rightPoint = rightPoint.right()
                    flow.insert(rightPoint)
                }
                if !wallCheck(rightPoint.below()) {
                    current.append(rightPoint)
                    continue
                }
            }

            if hitsLeftWall(point) && hitsRightWall(point) {
                stagnateRow(point)
            }

            current.removeLast()
            continue
        }
    }

    for y in minY...maxY {
        for x in minX...maxX {
            let point = GridPoint(x: x, y: y)
            let char = flow.contains(point) ? "|" : clay.contains(point) ? "#" : water.contains(point) ? "~" : " "
            print(char, terminator: "")
        }
        print()
    }
    return "\(flow.count + water.count)"
}

func day17b(_ input: String) -> String {
    let rows = input.components(separatedBy: CharacterSet.newlines)
    var clay = Set<GridPoint>()
    rows.forEach { (row) in
        let coords = row.components(separatedBy: ", ")
        let left = Int(coords[0].components(separatedBy: "=").last!)!
        let range = coords[1].components(separatedBy: "=").last!.components(separatedBy: "..")
        for i in Int(range[0])!...Int(range[1])! {
            clay.insert(GridPoint(x: row.first == "x" ? left : i, y: row.first == "x" ? i : left))
        }
    }
    let minX = clay.map() { $0.x }.min()!
    let maxX = clay.map() { $0.x }.max()! + 2
    let minY = clay.map() { $0.y }.min()!
    let maxY = clay.map() { $0.y }.max()!

    var water = Set<GridPoint>()
    var flow = Set<GridPoint>()
    let start = GridPoint(x: 500, y: minY)
    flow.insert(start)

    var current = [GridPoint]()
    current.append(start.below())

    let emptyCheck: (GridPoint) -> Bool = {
        return !water.contains($0) && !clay.contains($0) && !flow.contains($0)
    }

    let wallCheck: (GridPoint) -> Bool = {
        return water.contains($0) || clay.contains($0)
    }

    let stagnate: (GridPoint) -> Void = {
        water.insert($0)
        flow.remove($0)
    }

    let hitsLeftWall: (GridPoint) -> Bool = {
        var leftPoint = $0
        while flow.contains(leftPoint.left()) {
            leftPoint = leftPoint.left()
        }
        return wallCheck(leftPoint.left())
    }

    let hitsRightWall: (GridPoint) -> Bool = {
        var rightPoint = $0
        while flow.contains(rightPoint.right()) {
            rightPoint = rightPoint.right()
        }
        return wallCheck(rightPoint.right())
    }

    let stagnateRow: (GridPoint) -> Void = {
        var leftPoint = $0
        while flow.contains(leftPoint.left()) {
            leftPoint = leftPoint.left()
        }
        while flow.contains(leftPoint.right()) {
            stagnate(leftPoint)
            leftPoint = leftPoint.right()
        }
        stagnate(leftPoint)
    }

    while !current.isEmpty {
        let point = current.last!
        flow.insert(point)

        if emptyCheck(point.below()) {
            if point.below().y <= maxY {
                flow.insert(point.below())
                current.append(point.below())
            } else {
                current.removeLast()
            }
            continue
        }

        if flow.contains(point.below()) {
            current.removeLast()
            continue
        }

        if wallCheck(point.below()) {
            if emptyCheck(point.left()) {
                var leftPoint = point
                while emptyCheck(leftPoint.left()) && wallCheck(leftPoint.below()) {
                    leftPoint = leftPoint.left()
                    flow.insert(leftPoint)
                }
                if !wallCheck(leftPoint.below()) {
                    current.append(leftPoint)
                    continue
                }
            }

            if emptyCheck(point.right()) {
                var rightPoint = point
                while emptyCheck(rightPoint.right()) && wallCheck(rightPoint.below()) {
                    rightPoint = rightPoint.right()
                    flow.insert(rightPoint)
                }
                if !wallCheck(rightPoint.below()) {
                    current.append(rightPoint)
                    continue
                }
            }

            if hitsLeftWall(point) && hitsRightWall(point) {
                stagnateRow(point)
            }

            current.removeLast()
            continue
        }
    }

    for y in minY...maxY {
        for x in minX...maxX {
            let point = GridPoint(x: x, y: y)
            let char = clay.contains(point) ? "#" : water.contains(point) ? "~" : " "
            print(char, terminator: "")
        }
        print()
    }
    return "\(water.count)"
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

    func below() -> GridPoint {
        return GridPoint(x: self.x, y: self.y + 1)
    }

    func above() -> GridPoint {
        return GridPoint(x: self.x, y: self.y - 1)
    }

    func left() -> GridPoint {
        return GridPoint(x: self.x - 1, y: self.y)
    }

    func right() -> GridPoint {
        return GridPoint(x: self.x + 1, y: self.y)
    }
}

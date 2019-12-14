//  Created by Krys Jurgowski on 12/11/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

struct Point: Hashable {
    let x: Int
    let y: Int
}

struct Position: Hashable {
    let x: Int
    let y: Int
    let z: Int

    public func add(other: Position) -> Position {
        return Position(x:self.x + other.x,
                        y:self.y + other.y,
                        z:self.z + other.z)
    }
}

enum Direction {
    case up
    case down
    case left
    case right

    func turn(right: Bool) -> Direction {
        switch right {
        case false:
            switch self {
            case .up: return .left
            case .left: return .down
            case .down: return .right
            case .right: return .up
            }
        case true:
            switch self {
                case .up: return .right
                case .left: return .up
                case .down: return .left
                case .right: return .down
            }
        }
    }

    func move(p: Point) -> Point {
        switch self {
        case .up:     return Point(x: p.x, y: p.y-1)
        case .down:   return Point(x: p.x, y: p.y+1)
        case .left:   return Point(x: p.x-1, y: p.y)
        case .right:  return Point(x: p.x+1, y: p.y)
        }
    }
}

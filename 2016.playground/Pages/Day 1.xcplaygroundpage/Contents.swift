//: Day 1

import Foundation

let fileURL = Bundle.main.url(forResource: "Day1", withExtension: "input")
let input = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

enum Direction {
    case north
    case east
    case west
    case south
    
    func turn(isLeft: Bool) -> Direction {
        switch self {
        case .north: return isLeft ? .west : .east
        case .south: return isLeft ? .east : .west
        case .west: return isLeft ? .south : .north
        case .east: return isLeft ? .north : .south
        }
    }
}

func calcDistance(input: String) -> Int {
    let steps = input.components(separatedBy: ", ")
    
    var direction = Direction.north
    var x = 0
    var y = 0
    
    for step in steps {
        assert(step.hasPrefix("L") || step.hasPrefix("R"))
        let isLeft = step.hasPrefix("L")
        let distance = Int(step.substring(from: step.characters.index(step.startIndex, offsetBy: 1)))!
        direction = direction.turn(isLeft: isLeft)
        switch direction {
        case .north: y = y + distance
        case .south: y = y - distance
        case .east: x = x + distance
        case .west: x = x - distance
        }
    }
    
    return abs(x) + abs(y)
}

print(calcDistance(input: input))

struct Location: Hashable {
    let x: Int
    let y: Int
    var hashValue: Int { return x.hashValue ^ y.hashValue }
    static func ==(lhs: Location, rhs: Location) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

func firstDoubleLocation(input: String) -> Int {
    let steps = input.components(separatedBy: ", ")
    
    var direction = Direction.north
    var x = 0
    var y = 0
    var visited = Set<Location>()
    visited.insert(Location(x: 0, y: 0))
    
    for step in steps {
        assert(step.hasPrefix("L") || step.hasPrefix("R"))
        let isLeft = step.hasPrefix("L")
        var distance = Int(step.substring(from: step.characters.index(step.startIndex, offsetBy: 1)))!
        direction = direction.turn(isLeft: isLeft)
        while (distance > 0) {
            switch direction {
            case .north: y = y + 1
            case .south: y = y - 1
            case .east: x = x + 1
            case .west: x = x - 1
            }
            let location = Location(x: x, y: y)
            if visited.contains(location) {
                return abs(x) + abs(y)
            }
            visited.insert(location)
            distance = distance - 1
        }
    }
    
    return abs(x) + abs(y)
}

print(firstDoubleLocation(input: input))

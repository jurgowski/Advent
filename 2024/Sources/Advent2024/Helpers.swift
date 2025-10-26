
public enum Dir: Hashable {
    case nort
    case sout
    case east
    case west
    
    public var rotate: Dir {
        switch self {
        case .nort: return .east
        case .east: return .sout
        case .sout: return .west
        case .west: return .nort
        }
    }
}

public struct Pos: Hashable {
    public let x: Int
    public let y: Int
    
    public init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    public func inside(map: [[String.Element]]) -> Bool {
        map.indices.contains(y) && map[y].indices.contains(x)
    }
    
    public var all: [Pos] {
        [left, right, up, down]
    }
    
    public func reachable(map: [[String.Element]]) -> [Pos] {
        [left, right, up, down].filter { $0.inside(map:map) }
    }
    
    public var left:  Pos { Pos(x - 1, y) }
    public var right: Pos { Pos(x + 1, y) }
    public var up:    Pos { Pos(x, y - 1) }
    public var down:  Pos { Pos(x, y + 1) }
    
    public subscript (dir: Dir) -> Pos {
        switch dir {
        case .nort: return up
        case .sout: return down
        case .east: return right
        case .west: return left
        }
    }
}



public extension Array where Element == [String.Element] {
    subscript(pos: Pos) -> String.Element {
        return self[pos.y][pos.x]
    }
}

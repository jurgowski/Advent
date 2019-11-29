//: [Previous](@previous)

import Foundation

struct Point: Hashable {
    let x: Int
    let y: Int
    
    var hashValue: Int { get { return x << 32 ^ y } }
    static func ==(lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

func maxMoves(start: Point, maxDistance: Int, c: Int) -> Int {
    var distances:[Point: Int] = [start:0]
    var queue = [start]
    while !queue.isEmpty {
        let currentMove = queue.removeFirst()
        let moves = possibleMoves(currentMove, c: c).filter({
            return distances[$0] == nil
        })
        for move in moves {
            distances[move] = distances[currentMove]! + 1
            if (distances[move]! < maxDistance) {
                queue.append(move)
            }
        }
    }
    return distances.count
}

func shortestPath(start: Point, end: Point, c: Int) -> Int {
    var distances:[Point: Int] = [start:0]
    var queue = [start]
    while !queue.isEmpty {
        let currentMove = queue.removeFirst()
        let moves = possibleMoves(currentMove, c: c).filter({
            return distances[$0] == nil
        })
        for move in moves {
            distances[move] = distances[currentMove]! + 1
            if (move == end) {
                return distances[move]!
            }
            queue.append(move)
        }
    }
    return 0
}

func possibleMoves(_ point: Point, c: Int) -> [Point] {
    var moves:[Point] = []
    for (x, y) in [(point.x,     point.y - 1),
                   (point.x,     point.y + 1),
                   (point.x - 1, point.y),
                   (point.x + 1, point.y)]
    {
        if x >= 0 && y >= 0 && noWall(x: x, y: y, c: c) {
            moves.append(Point(x: x, y: y))
        }
    }
    return moves
}

func noWall(x: Int, y: Int, c: Int) -> Bool {
    return numberOfSetBits(x*x + 3*x + 2*x*y + y + y*y + c) % 2 == 0
}

func numberOfSetBits(_ num: Int) -> Int {
    var current: Int = num
    var bits = 0
    while (current != 0) {
        bits += (current % 2 == 0) ? 0 : 1
        current /= 2
    }
    return bits
}

//shortestPath(start: Point(x:1, y:1), end: Point(x:31, y:39), c: 1358)
//maxMoves(start: Point(x: 1, y: 1), maxDistance: 50, c: 1358)


// Debug

func printGrid(_ size:Int, c: Int) {
    for y in 0..<size {
        for x in 0..<size {
            p(noWall(x: x, y: y, c: c) ?
                ((x == 31 && y == 39) ? "G" : " ") :
                "█")
        }
        print("")
    }
}

func p(_ str: Any) {
    print(str, terminator: "")
}

printGrid(50, c: 1358)
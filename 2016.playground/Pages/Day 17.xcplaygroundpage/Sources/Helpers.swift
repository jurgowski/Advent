import Foundation

struct Position {
    let path: String
    let x: Int
    let y: Int
    let distance: Int
    
    func possibleNextPositions(_ str: String) -> [Position] {
        let hash = MD5(str + path)
        let chars = hash.characters
        var positions = [Position]()
        var currentIndex = chars.startIndex
        if isOpen(chars[currentIndex]) {
            positions.append(Position(path: path + "U",
                                      x: x,
                                      y: y - 1,
                                      distance: distance + 1))
        }
        currentIndex = chars.index(after: currentIndex)
        if isOpen(chars[currentIndex]) {
            positions.append(Position(path: path + "D",
                                      x: x,
                                      y: y + 1,
                                      distance: distance + 1))
        }
        currentIndex = chars.index(after: currentIndex)
        if isOpen(chars[currentIndex]) {
            positions.append(Position(path: path + "L",
                                      x: x - 1,
                                      y: y,
                                      distance: distance + 1))
        }
        currentIndex = chars.index(after: currentIndex)
        if isOpen(chars[currentIndex]) {
            positions.append(Position(path: path + "R",
                                      x: x + 1,
                                      y: y,
                                      distance: distance + 1))
        }
        return positions
    }
    
    func isOpen(_ char: Character) -> Bool {
        switch char {
        case "b", "c", "d", "e", "f":   return true
        default:                        return false
        }
    }
    
    func isValid() -> Bool {
        return x >= 0 && x < 4 && y >= 0 && y < 4
    }
    
    func isFinal() -> Bool {
        return x == 3 && y == 3
    }
}

public func longestPath(_ input: String) -> Int {
    var positions: [Position] = [Position(path: "", x: 0, y: 0, distance: 0)]
    var length = 0
    while !positions.isEmpty {
        let currentPosition = positions.removeFirst()
        if currentPosition.distance > length {
            length = currentPosition.distance
            print(length)
        }
        let nextPositions = currentPosition.possibleNextPositions(input)
            .filter({
                if $0.isFinal() { print($0) }
                return $0.isValid() && !$0.isFinal()
            })
        positions.append(contentsOf: nextPositions)
    }
    return length
}

public func shortestPath(_ input: String) -> String {
    var positions: [Position] = [Position(path: "", x: 0, y: 0, distance: 0)]
    while !positions.isEmpty {
        let currentPosition = positions.removeFirst()
        let nextPositions = currentPosition.possibleNextPositions(input).filter({ return $0.isValid() })
        for finalPosition in nextPositions {
            if finalPosition.isFinal() {
                return finalPosition.path
            }
        }
        positions.append(contentsOf: nextPositions)
    }
    return ""
}

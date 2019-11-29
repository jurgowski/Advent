//  Created by Krys Jurgowski on 12/2/18.
//  Copyright © 2018 United States. All rights reserved.

import Foundation

func day13a(_ input: String) -> String {
    let rows = input.components(separatedBy: CharacterSet.newlines)
    var carts = [Cart]()
    var tracks = [GridPoint : Track]()
    for (i, row) in rows.enumerated() {
        for (j, char) in row.enumerated() {
            let point = GridPoint(x: j, y: i)
            switch char {
            case " ": continue
            case "-":  tracks[point] = Track.horizontal
            case "|":  tracks[point] = Track.vertical
            case "+":  tracks[point] = Track.intersection
            case "\\": tracks[point] = Track.broadway
            case "/":  tracks[point] = Track.slash
            case ">":
                tracks[point] = Track.horizontal
                carts.append(Cart(direction: .right, gridPoint: point))
            case "<":
                tracks[point] = Track.horizontal
                carts.append(Cart(direction: .left, gridPoint: point))
            case "^":
                tracks[point] = Track.vertical
                carts.append(Cart(direction: .up, gridPoint: point))
            case "v":
                tracks[point] = Track.vertical
                carts.append(Cart(direction: .down, gridPoint: point))
            default: fatalError()
            }
        }
    }
    var time = 0
    var crash: GridPoint? = nil
    while crash == nil {
        let sortedCarts = carts.sorted { (cartA, cartB) -> Bool in
            if cartA.gridPoint.x == cartB.gridPoint.x {
                return cartA.gridPoint.y < cartB.gridPoint.y
            }
            return cartA.gridPoint.x < cartB.gridPoint.x
        }
        for cart in sortedCarts {
            let positions = Set(carts.map { $0.gridPoint })
            cart.progress(tracks[cart.gridPoint]!)
            if positions.contains(cart.gridPoint) {
                crash = cart.gridPoint
                break
            }
        }
        time += 1
    }
    return "\(crash!)"
}

func day13b(_ input: String) -> String {
    let rows = input.components(separatedBy: CharacterSet.newlines)
    var carts = [Cart]()
    var tracks = [GridPoint : Track]()
    for (i, row) in rows.enumerated() {
        for (j, char) in row.enumerated() {
            let point = GridPoint(x: j, y: i)
            switch char {
            case " ": continue
            case "-":  tracks[point] = Track.horizontal
            case "|":  tracks[point] = Track.vertical
            case "+":  tracks[point] = Track.intersection
            case "\\": tracks[point] = Track.broadway
            case "/":  tracks[point] = Track.slash
            case ">":
                tracks[point] = Track.horizontal
                carts.append(Cart(direction: .right, gridPoint: point))
            case "<":
                tracks[point] = Track.horizontal
                carts.append(Cart(direction: .left, gridPoint: point))
            case "^":
                tracks[point] = Track.vertical
                carts.append(Cart(direction: .up, gridPoint: point))
            case "v":
                tracks[point] = Track.vertical
                carts.append(Cart(direction: .down, gridPoint: point))
            default: fatalError()
            }
        }
    }
    var time = 0
    while carts.count > 2 {
        let sortedCarts = carts.sorted { (cartA, cartB) -> Bool in
            if cartA.gridPoint.x == cartB.gridPoint.x {
                return cartA.gridPoint.y < cartB.gridPoint.y
            }
            return cartA.gridPoint.x < cartB.gridPoint.x
        }
        for cart in sortedCarts {
            let positions = Set(carts.map { $0.gridPoint })
            cart.progress(tracks[cart.gridPoint]!)
            if positions.contains(cart.gridPoint) {
                carts.removeAll { $0.gridPoint == cart.gridPoint }
            }
        }
        time += 1
    }
    return "\(carts.first!.gridPoint)"
}

fileprivate enum Track {
    case horizontal
    case vertical
    case intersection
    case broadway
    case slash
}

fileprivate class Cart {
    enum Direction {
        case up
        case down
        case left
        case right
    }

    enum Turn {
        case left
        case right
        case straight

        func next() -> Turn {
            switch self {
            case .left:     return .straight
            case .straight: return .right
            case .right:    return .left
            }
        }
    }

    var turn: Turn
    var direction: Direction
    var gridPoint: GridPoint

    init(direction: Direction, gridPoint: GridPoint) {
        self.direction = direction
        self.gridPoint = gridPoint
        turn = .left
    }

    func progress(_ track:Track) {
        switch self.direction {
        case .up:
            switch track {
            case .horizontal: fatalError()
            case .vertical: break
            case .slash: direction = .right
            case .broadway: direction = .left
            case .intersection:
                switch turn {
                case .left:     direction = .left
                case .right:    direction = .right
                case .straight: direction = .up
                }
                turn = turn.next()
            }
        case .down:
            switch track {
            case .horizontal: fatalError()
            case .vertical: break
            case .slash: direction = .left
            case .broadway: direction = .right
            case .intersection:
                switch turn {
                case .left:     direction = .right
                case .right:    direction = .left
                case .straight: direction = .down
                }
                turn = turn.next()
            }
        case .left:
            switch track {
            case .horizontal: break
            case .vertical: fatalError()
            case .slash: direction = .down
            case .broadway: direction = .up
            case .intersection:
                switch turn {
                case .left:     direction = .down
                case .right:    direction = .up
                case .straight: direction = .left
                }
                turn = turn.next()
            }
        case .right:
            switch track {
            case .horizontal: break
            case .vertical: fatalError()
            case .slash: direction = .up
            case .broadway: direction = .down
            case .intersection:
                switch turn {
                case .left:     direction = .up
                case .right:    direction = .down
                case .straight: direction = .right
                }
                turn = turn.next()
            }
        }
        switch self.direction {
        case .up:    gridPoint = GridPoint(x: gridPoint.x, y: gridPoint.y - 1)
        case .down:  gridPoint = GridPoint(x: gridPoint.x, y: gridPoint.y + 1)
        case .left:  gridPoint = GridPoint(x: gridPoint.x - 1, y: gridPoint.y)
        case .right: gridPoint = GridPoint(x: gridPoint.x + 1, y: gridPoint.y)
        }
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

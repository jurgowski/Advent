//  Created by Krys Jurgowski on 12/2/18.
//  Copyright © 2018 United States. All rights reserved.

import Foundation

fileprivate struct Position: Hashable, Comparable {
    let x: Int
    let y: Int

    static func < (l: Position, r: Position) -> Bool {
        if l.y == r.y {
            return l.x < r.x
        }
        return l.y < r.y
    }
}

fileprivate class Unit: CustomDebugStringConvertible {
    var pos: Position
    let attack = 3
    var hp = 200
    let type: Character

    init(position: Position, type: Character) {
        self.pos = position
        self.type = type
    }

    var debugDescription: String {
        return "\(type) @ x:\(pos.x), y:\(pos.y) - \(hp))"
    }
}

func day15a(_ input: String) -> String {
    let columns = input.components(separatedBy: CharacterSet.newlines)
    var grid = columns.map { Array($0) }
    var units = _makeUnits(grid: grid)


    var round = 0
    var combat = true

    while combat {
        round += 1
        // Attack Order
        units.sort { $0.pos < $1.pos }

        units.forEach { unit in
            let enemies = _enemies(unit, units: units)
            if enemies.count == 0 {
                combat = false
                return
            }
            let attackPositions = _attackPositions(enemies: enemies, grid: grid)
        }
    }




    return ""
}

func day15b(_ input: String) -> String {
    return ""
}

private func _makeUnits(grid: [[Character]]) -> [Unit] {
    var units = [Unit]()
    grid.enumerated().forEach { (row) in
        row.element.enumerated().forEach { (square) in
            switch square.element {
            case "G", "E": units.append(Unit(position: Position(x: square.offset, y: row.offset),
                                             type: square.element))
            default: break
            }
        }
    }
    return units
}

private func _enemies(_ unit: Unit, units: [Unit]) -> [Unit] {
    return units.filter { enemy -> Bool in
        return unit.type != enemy.type
    }
}

private func _attackPositions(enemies: [Unit], grid: [[Character]]) -> Set<Position> {
    var positions = Set<Position>()
    enemies.forEach { enemy in
        let insertIfEmpty = { (dx: Int, dy: Int) in
            if grid[enemy.pos.y+dy][enemy.pos.x+dx] == "." {
                positions.insert(Position(x: enemy.pos.x+dx, y: enemy.pos.y+dy))
            }
        }
        insertIfEmpty( 1, 0)
        insertIfEmpty( 0, 1)
        insertIfEmpty(-1, 0)
        insertIfEmpty( 0,-1)
    }
    return positions
}

//  Created by Krys Jurgowski on 12/2/18.
//  Copyright © 2018 United States. All rights reserved.

import Foundation

fileprivate struct Position: Hashable, Comparable {
    let x: Int
    let y: Int

    static func < (l: Position, r: Position) -> Bool {
        return l.y == r.y ? l.x < r.x : l.y < r.y
    }
}

fileprivate class Unit: CustomDebugStringConvertible {
    var pos: Position
    let attack: Int
    var hp = 200
    let type: Character

    init(position: Position, type: Character, attack: Int) {
        self.pos = position
        self.type = type
        self.attack = attack
    }

    var debugDescription: String {
        return "\(type) @ x:\(pos.x), y:\(pos.y) - \(hp))"
    }

    var dead: Bool { hp <= 0 }
}

//184470 Too High
func day15a(_ input: String) -> Int {
    let columns = input.components(separatedBy: CharacterSet.newlines)
    let result = _executeCombat(columns.map { Array($0) }, elfPower: 3)
    return result.0.map { $0.hp }.reduce(0, +) * (result.1)
}

func day15b(_ input: String) -> Int {
    let columns = input.components(separatedBy: CharacterSet.newlines)
    let map = columns.map { Array($0) }
    let elfCount = map.reduce(0) { $0 + $1.reduce(0) { $0 + ($1 == "E" ? 1 : 0) }}
    var elfSurvived = 0
    var elfPower = 3
    var result : ([Unit], Int)
    repeat {
        elfPower += 1
        result = _executeCombat(map, elfPower: elfPower)
        elfSurvived = result.0.filter { $0.type == "E" }.count
    } while elfCount > elfSurvived
    return result.0.map { $0.hp }.reduce(0, +) * (result.1)
}

private func _executeCombat(_ map: [[Character]], elfPower: Int) -> ([Unit], Int) {
    var grid = map
    var units = _makeUnits(grid: grid, elfPower: elfPower)

    var rounds = 0
    var combat = true

    while combat {
        units.sort { $0.pos < $1.pos } // Turn Order
        units.forEach { unit in
            guard combat else { return }
            guard !unit.dead else { return }
            let enemies = _enemies(unit, units: units)
            guard enemies.count > 0 else { combat = false; return }

            if let targetEnemy = _targetEnemy(unit: unit, enemies: enemies) {
                _attack(unit: unit, enemy: targetEnemy, grid: &grid)
            } else {
                let attackPositions = _attackPositions(enemies: enemies, grid: grid)
                guard let targetPosition = _nearestTarget(unit.pos, grid, attackPositions) else { return }
                guard let targetNextPosition = _nearestTarget(targetPosition, grid, _adjPositions(unit.pos)) else { fatalError() }
                _move(unit: unit, grid: &grid, position: targetNextPosition)
                if let targetEnemy = _targetEnemy(unit: unit, enemies: enemies) {
                    _attack(unit: unit, enemy: targetEnemy, grid: &grid)
                }
            }
        }
        units.removeAll { $0.dead }
        if combat {
            rounds += 1
        }
    }
    return (units, rounds)
}

private func _makeUnits(grid: [[Character]], elfPower: Int) -> [Unit] {
    return grid
        .enumerated()
        .flatMap { row -> [(Position, Character)] in
            row.element.enumerated().map { element -> (Position, Character) in
                (Position(x: element.0, y: row.offset), element.1)
            }}
        .filter { $0.1 == "G" || $0.1 == "E" }
        .map { Unit(position: $0.0, type: $0.1, attack: $0.1 == "E" ? elfPower : 3) }
}

private func _enemies(_ unit: Unit, units: [Unit]) -> [Unit] {
    return units
        .filter { unit.type != $0.type }
        .filter { !$0.dead }
        .sorted { $0.pos < $1.pos }
}

private func _attackPositions(enemies: [Unit], grid: [[Character]]) -> [Position] {
    return enemies
        .flatMap { _adjPositions($0.pos) }
        .filter { _read(grid, pos:$0) == "." }
        .sorted { $0 < $1 }
}

private func _targetEnemy(unit: Unit, enemies:[Unit]) -> Unit? {
    return _adjPositions(unit.pos)
        .compactMap { pos in enemies.filter { $0.pos == pos }.first }
        .sorted { $0.hp == $1.hp ? $0.pos < $1.pos : $0.hp < $1.hp }
        .first
}

private func _read(_ grid: [[Character]], pos:Position) -> Character {
    return grid[pos.y][pos.x]
}

private func _adjPositions(_ pos: Position) -> [Position] {
    return [
        Position(x: pos.x + 1, y: pos.y),
        Position(x: pos.x - 1, y: pos.y),
        Position(x: pos.x, y: pos.y + 1),
        Position(x: pos.x, y: pos.y - 1),
    ]
}

private func _nearestTarget(_ position: Position, _ grid: [[Character]], _ targets: [Position]) -> Position? {
    var distances = [position: 0]
    var distance = 0
    var nearestTarget = targets.filter { position == $0 }.first

    while nearestTarget == nil {
        let nextPositions = distances
            .filter { $0.value == distance }
            .flatMap { _adjPositions($0.key) }
            .filter { _read(grid, pos: $0) == "." }
            .filter { distances[$0] == nil }
        if nextPositions.count == 0 {
            break
        }
        distance += 1
        nextPositions.forEach { distances[$0] = distance }
        nearestTarget = targets
            .filter { nextPositions.contains($0) }
            .sorted { $0 < $1 }
            .first
    }

    return nearestTarget
}

private func _move(unit: Unit, grid: inout [[Character]], position: Position) {
    assert(_read(grid, pos: unit.pos) == unit.type)
    grid[unit.pos.y][unit.pos.x] = "."
    grid[position.y][position.x] = unit.type
    unit.pos = position
}

private func _attack(unit: Unit, enemy: Unit, grid: inout [[Character]]) {
    assert(!enemy.dead)
    assert(unit.type != enemy.type)
    enemy.hp -= unit.attack
    if enemy.dead {
        grid[enemy.pos.y][enemy.pos.x] = "."
    }
}

func _print(grid: [[Character]]) {
    grid.map { String($0) }
        .forEach { print($0) }
}

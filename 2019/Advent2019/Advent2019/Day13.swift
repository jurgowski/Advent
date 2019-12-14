//  Created by Krys Jurgowski on 12/11/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func day13(_ input: String) -> (Int, Int) {
    let program = input
        .components(separatedBy: ",")
        .compactMap { Int($0) }

    var machine = IntCode(program: program)
    var tiles = [Point:Int]()

    while !machine.terminated {
        let x = machine.run()
        if machine.terminated { break }
        let y = machine.run()
        tiles[Point(x: x, y: y)] = machine.run()
    }

    let blocks = tiles.reduce(0) { $0 + ($1.value == 2 ? 1 : 0) }
    tiles.removeAll()

    var playProgram = program
    playProgram[0] = 2
    machine = IntCode(program: playProgram)

    machine.inputer { () -> Int in
        let ball = tiles.filter { $0.value == 4 }.first!.key
        let pad =  tiles.filter { $0.value == 3 }.first!.key
        return pad.x < ball.x ? 1 : pad.x > ball.x ? -1 : 0
    }

    var score = 0
    while !machine.terminated {
        let x = machine.run()
        if machine.terminated { break }
        let y = machine.run()
        if x == -1 && y == 0 {
            score = machine.run()
            //_print(tiles)
        } else {
            tiles[Point(x: x, y: y)] = machine.run()
        }
    }

    return (blocks, score)
}

private func _print(_ tiles: [Point:Int]) {
    let xMin = tiles.keys.map { $0.x }.min()!
    let yMin = tiles.keys.map { $0.y }.min()!
    let xMax = tiles.keys.map { $0.x }.max()!
    let yMax = tiles.keys.map { $0.y }.max()!

    for y in yMin...yMax {
        var string = ""
        for x in xMin...xMax {
            var char = "."
            switch tiles[Point(x:x, y:y)] {
            case 0: char = " "
            case 1: char = "#"
            case 2: char = "@"
            case 3: char = "-"
            case 4: char = "O"
            default: char = "?"
            }
            string += char

        }
        print(string)
    }
}

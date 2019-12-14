//  Created by Krys Jurgowski on 12/10/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func day11(_ input: String) -> Int {
    let program = input
    .components(separatedBy: ",")
    .compactMap { Int($0) }

    let map1 = _paintMap(IntCode(program: program))
    let map2 = _paintMap(IntCode(program: program).queueInput(1))

    let xMin = map2.map { $0.key }.map { $0.x }.min()!
    let xMax = map2.map { $0.key }.map { $0.x }.max()!
    let yMin = map2.map { $0.key }.map { $0.y }.min()!
    let yMax = map2.map { $0.key }.map { $0.y }.max()!

    for y in yMin...yMax {
        var string = ""
        for x in xMin...xMax {
            string += (map2[Point(x:x, y:y)] ?? 0) == 1 ? "#" : " "
        }
        print(string)
    }

    return map1.count
}

private func _paintMap(_ machine: IntCode) -> [Point: Int] {
    var map = [Point: Int]()

    var spot = Point(x: 0, y: 0)
    var direction = Direction.up
    var paint = 0
    var turn = 0

    while !machine.terminated {
        machine.inputer { () -> Int in
            print("in \(map[spot] ?? 0)")
            return map[spot] ?? 0
        }

        paint = machine.run()
        if machine.terminated {
            break
        }
        turn = machine.run()

        map[spot] = paint
        direction = direction.turn(right: turn == 1)
        spot = direction.move(p: spot)
    }
    return map
}

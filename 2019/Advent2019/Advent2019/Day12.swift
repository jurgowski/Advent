//  Created by Krys Jurgowski on 12/11/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func day12(_ input: String) -> (Int, Int) {
    let moonData = input
        .components(separatedBy: CharacterSet.newlines)
        .map { $0.dropFirst().dropLast() }

    var moons = [Position]()

    for moonD in moonData {
        let moonStats = moonD
            .components(separatedBy: ", ")
            .compactMap { $0.components(separatedBy: "=").last }
            .compactMap { Int($0) }
        moons.append(Position(x: moonStats[0], y: moonStats[1], z: moonStats[2]))
    }

    var vels = moons.map { _ in return Position(x: 0, y: 0, z: 0) }

    var energy = 0

    var steps = 0

    var moonXs = [[Int]:[Int]]()
    var moonYs = [[Int]:[Int]]()
    var moonZs = [[Int]:[Int]]()

    while steps < 100000 {
        let changes = moons.map { moon in
            moons.reduce(Position(x: 0, y: 0, z: 0)) {
                return Position(x: $0.x + (moon.x > $1.x ? -1 : (moon.x < $1.x) ? 1 : 0),
                                y: $0.y + (moon.y > $1.y ? -1 : (moon.y < $1.y) ? 1 : 0),
                                z: $0.z + (moon.z > $1.z ? -1 : (moon.z < $1.z) ? 1 : 0))
            }
        }
        vels = zip(vels, changes).map { $0.0.add(other: $0.1) }
        moons = zip(moons, vels).map { $0.0.add(other: $0.1) }
        steps += 1

        if steps == 1000 {
            let pots = moons.map { abs($0.x) + abs($0.y) + abs($0.z) }
            let kins =  vels.map { abs($0.x) + abs($0.y) + abs($0.z) }
            let zipped = zip(pots, kins)
            energy = zipped.reduce(0) { (partial, next) -> Int in
                return partial + (next.0 * next.1)
            }
        }

//        let moonX = moons.map{ $0.x }
//        if (moonXs[moonX] != nil) {
//            print("x \(moonXs[moonX]!) -> \(steps) : \(moonX) : v \(vels.map { $0.x })")
//        }
//        moonXs[moonX] = (moonXs[moonX] ?? []) + [steps]

//        let moonY = moons.map{ $0.y }
//        if (moonYs[moonY] != nil) {
//            print("y \(moonYs[moonY]!) -> \(steps) : \(moonY) : v \(vels.map { $0.y })")
//        }
//        moonYs[moonY] = (moonYs[moonY] ?? []) + [steps]

        let moonZ = moons.map{ $0.z }
        if (moonZs[moonZ] != nil) {
            print("z \(moonZs[moonZ]!) -> \(steps) : \(moonZ) : v \(vels.map { $0.z })")
        }
        moonZs[moonZ] = (moonZs[moonZ] ?? []) + [steps]
    }



    return (energy, 0)
}

//  Created by Krys Jurgowski on 12/11/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

struct Position: Hashable {
    let x: Int
    let y: Int
    let z: Int

    public func add(other: Position) -> Position {
        return Position(x:self.x + other.x,
                        y:self.y + other.y,
                        z:self.z + other.z)
    }
}

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

    var loopX = 0
    var loopY = 0
    var loopZ = 0

    while loopX == 0 || loopY == 0 || loopZ == 0 {
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

        let velsX = vels.map { $0.x }.reduce(true) { $0 && ($1 == 0) }
        let velsY = vels.map { $0.y }.reduce(true) { $0 && ($1 == 0) }
        let velsZ = vels.map { $0.z }.reduce(true) { $0 && ($1 == 0) }

        if velsX && loopX == 0 { loopX = steps }
        if velsY && loopY == 0 { loopY = steps }
        if velsZ && loopZ == 0 { loopZ = steps }

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

//        let moonZ = moons.map{ $0.z }
//        if (moonZs[moonZ] != nil) {
//            print("z \(moonZs[moonZ]!) -> \(steps) : \(moonZ) : v \(vels.map { $0.z })")
//        }
//        moonZs[moonZ] = (moonZs[moonZ] ?? []) + [steps]
    }

    let primes = _common([_primes(loopX), _primes(loopY), _primes(loopZ)])

    return (energy, primes * 2)
}

private func _common(_ ints: [[Int]]) -> Int {
    var ints = ints
    var final = [Int]()
    while !ints.allSatisfy { $0.isEmpty } {
        var next: Int?
        var i = 0
        while next == nil {
            next = ints[i].first
            i += 1
        }
        final.append(next!)
        for aI in 0..<ints.count {
            let curr = ints[aI]
            if let index = curr.firstIndex(of: next!) {
                ints[aI].remove(at: index)
            }
        }
    }
    return final.reduce(1, *)
}

private func _primes(_ num: Int) -> [Int] {
    var num = num
    var factors = [Int]()
    var i = 2
    while i <= num {
        while num % i == 0 {
            factors.append(i)
            num /= i
        }
        i += 1
    }
    return factors
}

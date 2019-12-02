//  Created by Krys Jurgowski on 12/1/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func day2a(_ input: String) -> Int {
    let program = input
        .components(separatedBy: ",")
        .compactMap { Int($0) }

    return _run(program, 12, 2)
}

//(368640 * a) + 152702 + b
func day2b(_ input: String) -> Int {
    let program = input
        .components(separatedBy: ",")
        .compactMap { Int($0) }

    for i in 0...100 {
        for j in 0...100 {
            if _run(program, i, j) == 19690720 {
                return (i * 100) + j
            }
        }
    }

    return 0
}

private func _run(_ program: [Int], _ noun: Int, _ verb: Int) -> Int {
    var mem = program
    mem[1] = noun
    mem[2] = verb

    var i = 0
    while mem[i] != 99 {
        switch mem[i] {
        case 1: mem[mem[i+3]] = mem[mem[i+1]] + mem[mem[i+2]]
        case 2: mem[mem[i+3]] = mem[mem[i+1]] * mem[mem[i+2]]
        default: fatalError()
        }
        i += 4
    }

    return mem[0]
}

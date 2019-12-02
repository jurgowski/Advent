//  Created by Krys Jurgowski on 12/1/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func day2a(_ input: String) -> Int {
    let program = input
        .components(separatedBy: ",")
        .compactMap { Int($0) }

    return _run(program, 12, 2)
}

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
    var ops = program
    ops[1] = noun
    ops[2] = verb

    var i = 0
    while ops[i] != 99 {
        switch ops[i] {
        case 1: ops[ops[i+3]] = ops[ops[i+1]] + ops[ops[i+2]]
        case 2: ops[ops[i+3]] = ops[ops[i+1]] * ops[ops[i+2]]
        default: fatalError()
        }
        i += 4
    }

    return ops[0]
}

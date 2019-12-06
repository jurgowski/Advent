//  Created by Krys Jurgowski on 12/5/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func day16a(_ input: String) -> Int {
    input.components(separatedBy: CharacterSet.newlines)

    return 0
}

func day16b(_ input: String) -> String {
    return ""
}

private func _runOperation(op: Int, ins: [Int], mem: inout [Int]) {
    switch op {
    case 0:  mem[ins[3]] = mem[ins[1]]  + mem[ins[2]]
    case 1:  mem[ins[3]] = mem[ins[1]]  +     ins[2]
    case 2:  mem[ins[3]] = mem[ins[1]]  * mem[ins[2]]
    case 3:  mem[ins[3]] = mem[ins[1]]  *     ins[2]
    case 4:  mem[ins[3]] = mem[ins[1]]  & mem[ins[2]]
    case 5:  mem[ins[3]] = mem[ins[1]]  &     ins[2]
    case 6:  mem[ins[3]] = mem[ins[1]]  | mem[ins[2]]
    case 7:  mem[ins[3]] = mem[ins[1]]  |     ins[2]
    case 8:  mem[ins[3]] = mem[ins[1]]
    case 9:  mem[ins[3]] =     ins[1]
    case 10: mem[ins[3]] =     ins[1]   > mem[ins[2]] ? 1 : 0
    case 11: mem[ins[3]] = mem[ins[1]]  >     ins[2]  ? 1 : 0
    case 12: mem[ins[3]] = mem[ins[1]]  > mem[ins[2]] ? 1 : 0
    case 13: mem[ins[3]] =     ins[1]  == mem[ins[2]] ? 1 : 0
    case 14: mem[ins[3]] = mem[ins[1]] ==     ins[2]  ? 1 : 0
    case 15: mem[ins[3]] = mem[ins[1]] == mem[ins[2]] ? 1 : 0
    default: fatalError()
    }
}

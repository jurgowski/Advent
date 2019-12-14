//  Created by Krys Jurgowski on 12/5/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func day16a(_ input: String) -> Int {
    let lines = input.components(separatedBy: CharacterSet.newlines)

    var i = 0
    var threeOrMore = 0

    while lines[i].hasPrefix("Before") {
        let before = lines[i]
            .components(separatedBy: "[")[1].dropLast()
            .components(separatedBy: ", ")
            .compactMap { Int($0) }
        i += 1
        let ins = lines[i]
            .components(separatedBy: " ")
            .compactMap { Int($0) }
        i += 1
        let after = lines[i]
            .components(separatedBy: "[")[1].dropLast()
            .components(separatedBy: ", ")
            .compactMap { Int($0) }

        let matches = (0...15).filter {
            _runOperation(op: $0, ins: ins, prog: before) == after
        }

        threeOrMore += matches.count >= 3 ? 1 : 0
        i += 2
    }

    return threeOrMore
}

func day16b(_ input: String) -> Int {
    let lines = input.components(separatedBy: CharacterSet.newlines)

    var i = 0
    var opMap = [Int:Set<Int>]()

    while lines[i].hasPrefix("Before") {
        let before = lines[i]
            .components(separatedBy: "[")[1].dropLast()
            .components(separatedBy: ", ")
            .compactMap { Int($0) }
        i += 1
        let ins = lines[i]
            .components(separatedBy: " ")
            .compactMap { Int($0) }
        i += 1
        let after = lines[i]
            .components(separatedBy: "[")[1].dropLast()
            .components(separatedBy: ", ")
            .compactMap { Int($0) }

        let matches = (0...15).filter {
            _runOperation(op: $0, ins: ins, prog: before) == after
        }

        if let currentSet = opMap[ins[0]] {
            opMap[ins[0]] = currentSet.intersection(matches)
        } else {
            opMap[ins[0]] = Set(matches)
        }
        i += 2
    }

    while !(opMap.allSatisfy { $0.value.count == 1 }) {
        let soloSets = opMap.filter { $0.value.count == 1 }.compactMapValues { $0.first }.values
        //opMap = opMap.
    }

    return 0
}

private func _runOperation(op: Int, ins: [Int], prog: [Int]) -> [Int] {
    var mem = prog
    _runOperation(op: op, ins: ins, mem: &mem)
    return mem
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

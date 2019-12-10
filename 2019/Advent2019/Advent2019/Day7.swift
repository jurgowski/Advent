//  Created by Krys Jurgowski on 12/1/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func day7(_ input: String) -> (Int, Int) {
    let program = input
        .components(separatedBy: ",")
        .compactMap { Int($0) }

    let highSingle = _permutations(Array(0...4))
        .reduce(0) {
            (current, signal) -> Int in
            var out = 0
            let machines = signal.map { IntCode(program: program).queueInput($0) }
            machines.forEach { out = $0.queueInput(out).run() }
            return current > out ? current : out
        }

    let highContinuous = _permutations(Array(5...9))
        .reduce(0) {
            (current, signal) -> Int in
            var out = 0
            var machines = signal.map { IntCode(program: program).queueInput($0) }
            while !machines.isEmpty {
                machines.forEach { out = $0.queueInput(out).run() }
                machines = machines.filter { !$0.terminated }
            }
            return current > out ? current : out
    }

    return (highSingle, highContinuous)
}

private func _split<T>(_ list: [T]) -> (T, [T])? {
    guard let first = list.first else { return nil }
    return (first, Array(list.dropFirst()))
}

private func _between<T>(_ item: T, _ list: [T]) -> [[T]] {
    guard let (first, rest) = _split(list) else { return [[item]] }
    return [[item] + list] + _between(item, rest).map { [first] + $0 }
}

private func _permutations<T>(_ list: [T]) -> [[T]] {
    guard let (head, tail) = _split(list) else { return [[]] }
    return _permutations(tail).flatMap { _between(head, $0) }
}

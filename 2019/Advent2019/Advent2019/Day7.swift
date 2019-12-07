//  Created by Krys Jurgowski on 12/1/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func day7a(_ input: String) -> Int {
    let program = input
        .components(separatedBy: ",")
        .compactMap { Int($0) }

    return _permutations([0,1,2,3,4])
        .reduce(0) {
            (current, signal) -> Int in
            var out = 0
            let machines = signal.map { IntCode(program: program).queueInput($0) }
            machines.forEach { out = $0.queueInput(out).run() }
            return current > out ? current : out
        }
}

func day7b(_ input: String) -> Int {
    let program = input
        .components(separatedBy: ",")
        .compactMap { Int($0) }

    return _permutations([5,6,7,8,9])
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
}

private func _split<T>(_ list: [T]) -> (T, [T])? {
    guard let first = list.first else { return nil }
    return (first, Array(list.dropFirst()))
}

private func _between<T>(_ first: T, _ list: [T]) -> [[T]] {
    guard let (head, tail) = _split(list) else { return [[first]] }
    return [[first] + list] + _between(first, tail).map { [head] + $0 }
}

private func _permutations<T>(_ list: [T]) -> [[T]] {
    guard let (head, tail) = _split(list) else { return [[]] }
    return _permutations(tail).flatMap { _between(head, $0) }
}

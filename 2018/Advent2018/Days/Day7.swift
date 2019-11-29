//  Created by Krys Jurgowski on 12/2/18.
//  Copyright © 2018 United States. All rights reserved.

import Foundation

func day7a(_ input: String) -> String {
    let pairs = input.components(separatedBy: CharacterSet.newlines).map {
        (line) -> (String, String) in
        let words = line.components(separatedBy: CharacterSet.whitespaces)
        return (words[1], words[7])
    }

    var deps: [String: Set<String>] = [:]
    pairs.forEach() {
        var set = deps[$0.1] ?? Set()
        set.insert($0.0)
        deps[$0.1] = set
        if deps[$0.0] == nil {
            deps[$0.0] = Set()
        }
    }
    var completed = [String]()
    var seen = Set<String>()
    while deps.count > 0 {
        let candidates = deps.filter() {
            let diffSet = $0.value.subtracting(seen)
            return diffSet.count == 0
            }.map() { $0.key }
        let current = candidates.sorted() { $0 < $1 }.first!
        completed.append(current)
        seen.insert(current)
        deps.removeValue(forKey: current)
    }
    return completed.joined()
}

// not 234

func day7b(_ input: String) -> String {
    let MAX_WORKERS = 5
    let pairs = input.components(separatedBy: CharacterSet.newlines).map {
        (line) -> (String, String) in
        let words = line.components(separatedBy: CharacterSet.whitespaces)
        return (words[1], words[7])
    }

    var deps: [String: Set<String>] = [:]
    pairs.forEach() {
        var set = deps[$0.1] ?? Set()
        set.insert($0.0)
        deps[$0.1] = set
        if deps[$0.0] == nil {
            deps[$0.0] = Set()
        }
    }
    var timeSpent = 0
    var seen = Set<String>()
    var workers = [String:Int]()
    while deps.count > 0 {
        if !workers.isEmpty {
            timeSpent += 1
            workers = workers.mapValues() { $0 - 1 }
            let done = workers.filter() { $0.value == 0 }
            done.forEach() {
                seen.insert($0.key)
                workers.removeValue(forKey: $0.key)
            }
        }

        if workers.count == MAX_WORKERS {
            continue
        }

        let candidates = deps.filter() {
            let diffSet = $0.value.subtracting(seen)
            return diffSet.count == 0
            }.map() { $0.key }
        var readyWorkItems = candidates.sorted() { $0 < $1 }
        while workers.count < MAX_WORKERS && !readyWorkItems.isEmpty {
            let nextItem = readyWorkItems.removeFirst()
            workers[nextItem] = Int(nextItem.unicodeScalars.first!.value) - 4
            deps.removeValue(forKey: nextItem)
        }
    }
    timeSpent += workers.values.max() ?? 0
    return "\(timeSpent)"
}

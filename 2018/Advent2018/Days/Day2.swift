//  Created by Krys Jurgowski on 12/2/18.
//  Copyright © 2018 United States. All rights reserved.

import Foundation

func day2a(_ input: String) -> String {
    let ids = input.components(separatedBy: CharacterSet.newlines)
    var doubles = 0
    var triples = 0
    for id in ids {
        var charMap = [Character:Int]()
        var hasDouble = false
        var hasTriple = false
        id.forEach { charMap[$0] = (charMap[$0] ?? 0) + 1 }
        for pair in charMap {
            if pair.value == 2 { hasDouble = true }
            if pair.value == 3 { hasTriple = true }
        }
        doubles += hasDouble ? 1 : 0
        triples += hasTriple ? 1 : 0
    }
    return "\(doubles * triples)"
}

func day2b(_ input: String) -> String {
    let ids = input.components(separatedBy: CharacterSet.newlines)
    var indicies = ids.map { $0.startIndex }
    var pairs = zip(ids, indicies)


    let stringLength = ids[0].count
    for _ in 0..<stringLength {

        let reducedStrings = pairs.map { $0.0.removed(at: $0.1) }
        if let dup = duplicate(reducedStrings) {
            return dup
        }
        indicies = pairs.map { $0.0.index(after: $0.1) }
        pairs = zip(ids, indicies)
    }
    return ""
}

private func duplicate(_ list: [String]) -> String? {
    var seen = Set<String>()
    for item in list {
        if seen.contains(item) {
            return item
        }
        seen.insert(item)
    }
    return nil
}

extension String {
    public func removed(at position: String.Index) -> String {
        var copy = self
        copy.remove(at: position)
        return copy
    }
}

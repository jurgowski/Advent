//: Day 20

import Foundation

let fileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let input =
    try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
        .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

struct IPRange {
    let start: Int
    let end: Int
}

func firstUnblockedIndex(_ input: String) -> Int {
    let ranges = input.components(separatedBy: CharacterSet.newlines).map { (range) -> IPRange in
        let rangeComponents = range.components(separatedBy: "-")
        return IPRange(start: Int(rangeComponents[0])!, end: Int(rangeComponents[1])!)
    }.sorted { (lhs, rhs) -> Bool in
        return lhs.start < rhs.start
    }
    var x = 0
    for range in ranges {
        if range.start > x {
            return x
        }
        x = max(x, range.end + 1)
    }
    return x
}

func totalBlockedIndexes(_ input: String) -> Int {
    let ranges = input.components(separatedBy: CharacterSet.newlines).map { (range) -> IPRange in
        let rangeComponents = range.components(separatedBy: "-")
        return IPRange(start: Int(rangeComponents[0])!, end: Int(rangeComponents[1])!)
        }.sorted { (lhs, rhs) -> Bool in
            return lhs.start < rhs.start
    }
    var total = 0
    var x = 0
    for range in ranges {
        let addition = max(0, (range.end + 1 - max(x, range.start)))
        print("\(range) adds \(addition) new x: \(max(x, range.end + 1)) new total: \(total + addition) missing: \(max(x, range.end + 1) - (total + addition))")
        total += addition
        x = max(x, range.end + 1)
    }
    return total
}

totalBlockedIndexes(input)

//firstUnblockedIndex(input)
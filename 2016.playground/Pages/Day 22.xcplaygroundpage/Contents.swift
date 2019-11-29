//: Day 22

import Foundation

let fileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let input =
    try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
        .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

//viablePairs(input)

shortestPath(input, target: (0, 0))
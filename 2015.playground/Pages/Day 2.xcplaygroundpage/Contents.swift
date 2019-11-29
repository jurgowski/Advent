//: [Previous](@previous)

import Foundation

let fileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let input =
    try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
        .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

func totalWrappingPaper(_ input: String) -> Int {
    let dimentions = input.components(separatedBy: CharacterSet.newlines)
    return dimentions.reduce(0, { (current, dimention) -> Int in
        let sides = dimention.components(separatedBy: "x").map({ return Int($0)!}).sorted()
        return
            current +
            (sides[0] * sides[1]) +
            (2 * sides[0] * sides[1] + 2 * sides[1] * sides[2] + 2 * sides[0] * sides[2])
    })
}

totalWrappingPaper(input)

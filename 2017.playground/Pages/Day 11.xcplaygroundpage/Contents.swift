//: [Previous](@previous)

import Foundation

let fileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let input = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

distance(input: input)

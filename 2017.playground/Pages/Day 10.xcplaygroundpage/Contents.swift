//: [Previous](@previous)

import Foundation

let fileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let input = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

print(knotHash(listSize: 256, input: ("".utf8.map { Int($0) })))
print(knotHash(listSize: 256, input: ("AoC 2017".utf8.map { Int($0) })))
print(knotHash(listSize: 256, input: ("1,2,3".utf8.map { Int($0) })))
print(knotHash(listSize: 256, input: ("1,2,4".utf8.map { Int($0) })))
print(knotHash(listSize: 256, input: (input.utf8.map { Int($0) })))

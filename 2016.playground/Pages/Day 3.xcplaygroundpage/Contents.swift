//: [Previous](@previous)

import Foundation

let fileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let input =
    try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
        .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

func numOfTriangles(_ input: String) -> Int {
    let triangles = input.components(separatedBy: CharacterSet.newlines)
    var validTris = 0
    for triangle in triangles {
        var sides = triangle.components(separatedBy: CharacterSet.whitespaces).filter({ (side) -> Bool in
            return !side.isEmpty
        }).map({ (side) -> Int in
            return Int(side)!
        })
        sides.sort()
        if sides[0] + sides[1] > sides[2] {
            validTris += 1
        }
    }
    
    return validTris
}

//numOfTriangles(input)
numOfWierdTriangles(input)
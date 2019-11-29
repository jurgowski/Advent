//: Day 12

import Foundation

let fileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let input =
    try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
        .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

//valueOfA(input, c: 0)
//valueOfA(input, c: 1)


func decompiled(cStart: Int) -> Int {
    var a = 1
    var b = 1
    var c = cStart
    var d = 26
    
    if c > 0 {
        d += 7
    }
    
    while d > 0 {
        c = a
        a += b
        b = c
        d -= 1
    }
    
    c = 18
    
    while c > 0 {
        d = 11
        a += d
        c -= 1
    }
    return a
}

decompiled(cStart: 1)
//: [Previous](@previous)

import Foundation

let fileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let input =
    try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
        .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

valueOfA(input, a: 182)

/*
func flips(_ start: Int) -> Bool {
    var a = 2548 + start
    var even = a % 2 == 0
    
    while a > 0 {
        if !even
        a /= 2
    }
}

decompiled(0)

func findFlop() -> Int {
    var test = 0
    
    while true {
        
        
        
    }
    
    return test
}

*/
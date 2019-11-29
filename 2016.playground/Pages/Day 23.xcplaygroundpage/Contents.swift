//: 23

import Foundation

let fileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let input =
    try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
        .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

//valueOfA(input, a: 7)  // 11514

func decompiled(_ startA:Int) -> Int {
    var a = startA
    var b = 0
    
    b = a - 1
    while (b > 1) {
        a *= b
        b -= 1
    }
    
    a += (78 * 83)
    return a
}

decompiled(12)
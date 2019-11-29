//: Day 2

import Foundation

let fileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let input =
    try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
        .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

struct Position {
    let x: Int
    let y: Int
    
    func move(_ direction: Character) -> Position {
        switch direction {
        case "L": return x == -1 ? self : Position(x: x - 1, y: y)
        case "R": return x ==  1 ? self : Position(x: x + 1, y: y)
        case "U": return y == -1 ? self : Position(x: x, y: y - 1)
        case "D": return y ==  1 ? self : Position(x: x, y: y + 1)
        default:
            assertionFailure("Unknown")
            return Position(x: x, y: y)
        }
    }
    
    func position() -> Character {
        switch (x, y) {
        case (-1, -1):  return "1"
        case ( 0, -1):  return "2"
        case ( 1, -1):  return "3"
        case (-1,  0):  return "4"
        case ( 0,  0):  return "5"
        case ( 1,  0):  return "6"
        case (-1,  1):  return "7"
        case ( 0,  1):  return "8"
        case ( 1,  1):  return "9"
        default: return "?"
        }
    }
}

func genCode(_ input: String) -> String {
    let combos = input.components(separatedBy: CharacterSet.newlines)
    var position = Position(x: 0, y: 0)
    var code = ""
    for combo in combos {
        for move in combo.characters {
            position = position.move(move)
        }
        code.append(position.position())
    }
    return code
}

struct LargePosition {
    let x: Int
    let y: Int
    
    func move(_ direction: Character) -> LargePosition {
        switch direction {
        case "L": return x + -abs(y) == -2 ? self : LargePosition(x: x - 1, y: y)
        case "R": return x +  abs(y) ==  2 ? self : LargePosition(x: x + 1, y: y)
        case "U": return -abs(x) + y == -2 ? self : LargePosition(x: x, y: y - 1)
        case "D": return  abs(x) + y ==  2 ? self : LargePosition(x: x, y: y + 1)
        default:
            assertionFailure("Unknown")
            return LargePosition(x: x, y: y)
        }
    }
    
    func position() -> Character {
        switch (x, y) {
        case ( 0, -2):  return "1"
        case (-1, -1):  return "2"
        case ( 0, -1):  return "3"
        case ( 1, -1):  return "4"
        case (-2,  0):  return "5"
        case (-1,  0):  return "6"
        case ( 0,  0):  return "7"
        case ( 1,  0):  return "8"
        case ( 2,  0):  return "9"
        case (-1,  1):  return "A"
        case ( 0,  1):  return "B"
        case ( 1,  1):  return "C"
        case ( 0,  2):  return "D"
        default: return "?"
        }
    }
}

func genLargeCode(_ input: String) -> String {
    let combos = input.components(separatedBy: CharacterSet.newlines)
    var position = LargePosition(x: -2, y: 0)
    var code = ""
    for combo in combos {
        for move in combo.characters {
            position = position.move(move)
        }
        code.append(position.position())
    }
    return code
}

genCode(input)
genLargeCode(input)

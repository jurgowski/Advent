import Foundation

let fileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let input =
    try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
        .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

func scramble(_ input: String, password: String) -> String {
    var letters = Array(password.characters)
    let instructions = input.components(separatedBy: CharacterSet.newlines)
    for instruction in instructions {
        let command = instruction.components(separatedBy: " ")
        switch command[0] {
        case "swap":
            switch command[1] {
            case "position":
                let x = Int(command[2])!
                let y = Int(command[5])!
                swap(&letters[x], &letters[y])
            case "letter":
                let x = letters.index(of: Character(command[2]))!
                let y = letters.index(of: Character(command[5]))!
                swap(&letters[x], &letters[y])
            default: assertionFailure()
            }
        case "rotate":
            switch command[1] {
            case "left":
                let amount = Int(command[2])!
                letters = shiftLeft(letters, amount: amount)
            case "right":
                let amount = Int(command[2])!
                letters = shiftRight(letters, amount: amount)
            case "based":
                let index = letters.index(of: Character(command[6]))!
                letters = shiftRight(letters, amount: 1)
                letters = shiftRight(letters, amount: index)
                if index >= 4 {
                    letters = shiftRight(letters, amount: 1)
                }
            default: assertionFailure()
            }
        case "reverse":
            let x = Int(command[2])!
            let y = Int(command[4])!
            letters = Array(letters[0 ..< x] + letters[x ..< y+1].reversed() + letters[y+1 ..< letters.count])
        case "move":
            let x = Int(command[2])!
            let y = Int(command[5])!
            let letter = letters.remove(at: x)
            letters.insert(letter, at: y)
        default: assertionFailure()
        }
        print("\(instruction) -> \(String(letters))")
    }
    return String(letters)
}

func unscramble(_ input: String, password: String) -> String {
    var letters = Array(password.characters)
    let instructions = input.components(separatedBy: CharacterSet.newlines)
    for instruction in instructions.reversed() {
        let command = instruction.components(separatedBy: " ")
        switch command[0] {
        case "swap":
            switch command[1] {
            case "position":
                let x = Int(command[2])!
                let y = Int(command[5])!
                swap(&letters[x], &letters[y])
            case "letter":
                let x = letters.index(of: Character(command[2]))!
                let y = letters.index(of: Character(command[5]))!
                swap(&letters[x], &letters[y])
            default: assertionFailure()
            }
        case "rotate":
            switch command[1] {
            case "left":
                let amount = Int(command[2])!
                letters = shiftRight(letters, amount: amount)
            case "right":
                let amount = Int(command[2])!
                letters = shiftLeft(letters, amount: amount)
            case "based":
                var index = letters.index(of: Character(command[6]))!
                if index == 0 { index = 8 }
                let amount = (index % 2 == 0) ? ((index  + 10) / 2) : ((index + 1) / 2)
                letters = shiftLeft(letters, amount: amount)
            default: assertionFailure()
            }
        case "reverse":
            let x = Int(command[2])!
            let y = Int(command[4])!
            letters = Array(letters[0 ..< x] + letters[x ..< y+1].reversed() + letters[y+1 ..< letters.count])
        case "move":
            let x = Int(command[2])!
            let y = Int(command[5])!
            let letter = letters.remove(at: y)
            letters.insert(letter, at: x)
        default: assertionFailure()
        }
        print("\(instruction) -> \(String(letters))")
    }
    return String(letters)
}

func shiftLeft<T>(_ arr: [T], amount: Int) -> [T] {
    let shift = amount % arr.count
    return Array(arr[shift ..< arr.count] + arr[0 ..< shift])
}

func shiftRight<T>(_ arr: [T], amount: Int) -> [T] {
    let shift = (arr.count - amount) % arr.count
    return Array(arr[shift ..< arr.count] + arr[0 ..< shift])
}

//scramble(input, password:"abcdefgh") // gfdhebac
unscramble(input, password: "fbgdceah")

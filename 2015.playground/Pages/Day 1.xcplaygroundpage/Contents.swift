import Foundation

let fileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let input =
    try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
        .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

func floor(_ input: String) -> Int {
    var floor = 0
    for char in input.characters {
        switch char {
        case "(":
            floor += 1
        case ")":
            floor -= 1
        default:
            assertionFailure()
        }
    }
    return floor
}

func basement(_ input: String) -> Int {
    var floor = 0
    var i = 0
    for char in input.characters {
        i += 1
        switch char {
        case "(":
            floor += 1
        case ")":
            floor -= 1
        default:
            assertionFailure()
        }
        if floor < 0 {
            return i
        }
    }
    return -1
}

//floor(input)
basement(input)
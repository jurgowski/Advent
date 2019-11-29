//: Day 6

import Foundation

let fileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let input =
    try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
        .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

func columnString(_ input: String) -> String {
    let rows = input.components(separatedBy: CharacterSet.newlines)
    var columnMaps: [[Character:Int]] = []
    for _ in rows.first!.characters {
        columnMaps.append([:])
    }
    for row in rows {
        var index = 0
        for char in row.characters {
            var map = columnMaps[index] 
            map[char] = (map[char] ?? 0) + 1
            columnMaps[index] = map
            index += 1
        }
    }
    var answer = ""
    for map in columnMaps {
        answer.append(largestChar(map))
    }
    return answer
}

func largestChar(_ map: [Character:Int]) -> Character {
    return map.sorted(by: { (left:(key: Character, value: Int), right:(key: Character, value: Int)) -> Bool in
        if left.value == right.value {
            return left.key > right.key
        }
        return left.value < right.value
    }).first!.key
}

columnString(input)
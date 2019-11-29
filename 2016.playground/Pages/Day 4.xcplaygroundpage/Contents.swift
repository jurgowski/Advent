//: Day 4

import Foundation

let fileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let input =
    try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
        .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

func countOfRealRooms(_ input: String) -> Int {
    let roomCodes = input.components(separatedBy: CharacterSet.newlines)
    var realRooms = 0
    for roomCode in roomCodes {
        let codeParts = roomCode.components(separatedBy: "-")
        let letterParts = codeParts[0...codeParts.count - 2]
        let checksumParts = codeParts.last!.trimmingCharacters(in: CharacterSet(charactersIn:"]")).components(separatedBy: "[")
        if (checksumMatches(letterParts.joined(), checksum: checksumParts[1])) {
            realRooms += Int(checksumParts[0])!
            print("\(checksumParts[0]) - \(decipher(Array(letterParts), shift: Int(checksumParts[0])!).joined(separator: " "))")
        }
    }
    return realRooms
}

func checksumMatches(_ letters: String, checksum: String) -> Bool {
    var countedLetters: [Character:Int] = [:]
    for character in letters.characters {
        countedLetters[character] = (countedLetters[character] ?? 0) + 1
    }
    let expectedChecksum = String(
        countedLetters
            .sorted { return $0.value != $1.value ? $0.value > $1.value : $0.key < $1.key}
            .map { return $0.key } [0...4])
    
    return expectedChecksum == checksum
}

func decipher(_ letterParts: [String], shift: Int) -> [String] {
    return letterParts.map({
        return String($0.unicodeScalars.map({
            let offset = (Int($0.value) - 97 + shift) % 26
            return Character(UnicodeScalar(offset + 97)!)
        }))
    })
}

countOfRealRooms(input)

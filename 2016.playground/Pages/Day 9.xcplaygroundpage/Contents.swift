// : Day 9

import Foundation

let fileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let input =
    try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
        .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

func decompressedLength(_ input: String) -> Int {
    let scanner = Scanner(string: input)
    var previousLocation = scanner.scanLocation
    var decompressedCount = 0
    
    var reps = 0
    var letters = 0
    
    while (true) {
        scanner.scanUpTo("(", into: nil)
        decompressedCount += scanner.scanLocation - previousLocation
        if (scanner.isAtEnd) {
            break
        }
        
        scanner.scanString("(", into: nil)
        scanner.scanInt(&letters)
        scanner.scanString("x", into: nil)
        scanner.scanInt(&reps)
        scanner.scanString(")", into: nil)
        decompressedCount += reps * letters
        
        scanner.scanLocation += letters
        previousLocation = scanner.scanLocation
    }
    
    return decompressedCount
}

func decompressedV2Length(_ input: String) -> Int {
    let scanner = Scanner(string: input)
    var previousLocation = scanner.scanLocation
    var decompressedCount = 0
    
    var reps = 0
    var letters = 0
    
    while (true) {
        scanner.scanUpTo("(", into: nil)
        decompressedCount += scanner.scanLocation - previousLocation
        if (scanner.isAtEnd) {
            break
        }
        
        scanner.scanString("(", into: nil)
        scanner.scanInt(&letters)
        scanner.scanString("x", into: nil)
        scanner.scanInt(&reps)
        scanner.scanString(")", into: nil)
        
        let startRange = input.index(input.startIndex, offsetBy: scanner.scanLocation)
        let endRange = input.index(startRange, offsetBy: letters)
        let substring = input.substring(with: startRange ..< endRange)
        decompressedCount += reps * decompressedV2Length(substring)
        
        scanner.scanLocation += letters
        previousLocation = scanner.scanLocation
    }
    
    return decompressedCount
}

decompressedV2Length(input)
//decompressedLength(input)
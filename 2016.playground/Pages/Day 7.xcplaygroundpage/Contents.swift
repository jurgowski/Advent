//: Day 7

import Foundation

let fileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let input =
    try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
        .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

func numberOfTLSIps(_ input: String) -> Int {
    let ipv7s = input.components(separatedBy: CharacterSet.newlines)
    return ipv7s.reduce(0, { (current, ipv7) -> Int in
        return current + (supportsTLS(ipv7) ? 1 : 0)
    })
}

func supportsTLS(_ ipv7: String) -> Bool {
    let splits = ipv7.components(separatedBy: "[")
    
    var insides: [String] = []
    
    let outsides = splits.map { (str: String) -> String in
        let split = str.components(separatedBy: "]")
        if (split.count > 1) {
            insides.append(split[0])
            return split[1]
        }
        return str
    }
    
    return !hasAbba(insides) && hasAbba(outsides)
}

func hasAbba(_ codes: [String]) -> Bool {
    for code in codes {
        let charView = code.characters
        for index in charView.indices {
            if doesAbbaStart(charView, at: index) {
                return true
            }
        }
    }
    return false
}

func doesAbbaStart(_ chars: String.CharacterView, at index: String.CharacterView.Index) -> Bool {
    guard let lastCharIndex = chars.index(index, offsetBy: 3, limitedBy: chars.endIndex) else {
        return false
    }
    if lastCharIndex == chars.endIndex {
        return false
    }
    let secondCharIndex = chars.index(index, offsetBy: 1)
    let thirdCharIndex = chars.index(index, offsetBy: 2)
    return
        chars[lastCharIndex] == chars[index] &&
        chars[secondCharIndex] == chars[thirdCharIndex] &&
        chars[index] != chars[secondCharIndex]
    
}

func numberOfSSLIps(_ input: String) -> Int {
    let ipv7s = input.components(separatedBy: CharacterSet.newlines)
    return ipv7s.reduce(0, { (current, ipv7) -> Int in
        return current + (supportsSSL(ipv7) ? 1 : 0)
    })
}

func supportsSSL(_ ipv7: String) -> Bool {
    let splits = ipv7.components(separatedBy: "[")
    
    var insides: [String] = []
    
    let outsides = splits.map { (str: String) -> String in
        let split = str.components(separatedBy: "]")
        if (split.count > 1) {
            insides.append(split[0])
            return split[1]
        }
        return str
    }
    
    return matchAbaCodes(insides, abaCodes: abaCodes(outsides))
}

func abaCodes(_ codes: [String]) -> [String] {
    var abaCodes: [String] = []
    for code in codes {
        let charView = code.characters
        for index in charView.indices {
            if doesAbaStart(charView, at: index) {
                let char = charView[charView.index(after: index)]
                let aba = String([char, charView[index], char])
                abaCodes.append(aba)
            }
        }
    }
    return abaCodes
}

func doesAbaStart(_ chars: String.CharacterView, at index: String.CharacterView.Index) -> Bool {
    guard let lastCharIndex = chars.index(index, offsetBy: 2, limitedBy: chars.endIndex) else {
        return false
    }
    if lastCharIndex == chars.endIndex {
        return false
    }
    let secondCharIndex = chars.index(index, offsetBy: 1)
    return
        chars[lastCharIndex] == chars[index] &&
        chars[index] != chars[secondCharIndex]
    
}

func matchAbaCodes(_ codes: [String], abaCodes: [String]) -> Bool {
    for code in codes {
        for abaCode in abaCodes {
            if code.range(of: abaCode) != nil {
                return true
            }
        }
    }
    return false
}



// 110
// numberOfTLSIps(input)

numberOfSSLIps(input)

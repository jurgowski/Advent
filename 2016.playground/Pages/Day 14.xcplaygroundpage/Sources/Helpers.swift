import Foundation

public func findIndex(salt: String, keys: Int, stretch: Bool) -> Int {
    var pendingFives: [(Character, Int)] = []
    var confirmed = 0
    var index = 0
    
    while (confirmed < keys) {
        let str = "\(salt)\(index)"
        let hash = stretch ? stretchedHash(str) : str.md5
        pendingFives = pendingFives.filter {
            let complete = hasFive(hash, testChar: $0.0)
            if (complete) {
                print("Completed \(confirmed) five for \($0.1)-\($0.0) at index \(index) hash \(hash)")
            }
            confirmed += complete ? 1 : 0
            return !complete && (index < 1000 + $0.1)
        }
        if let char = hasTriple(hash) {
            print("Triple \(char) at \(index) in hash \(hash)")
            pendingFives.append((char, index))
        }
        index += 1
    }
    return index - 1
}

func hasTriple(_ str: String) -> Character? {
    var chars: [Character] = []
    for char in str.characters {
        chars.append(char)
        if (chars.count > 3) {
            chars.removeFirst()
        }
        if (chars.count == 3 && Set(chars).count == 1) {
            return chars[0]
        }
    }
    return nil
}

func hasFive(_ str: String, testChar: Character) -> Bool {
    var count = 0
    for char in str.characters {
        if (char == testChar) {
            count += 1
            if (count >= 5) {
                return true
            }
        } else {
            count = 0
        }
    }
    return false
}

func stretchedHash(_ str: String) -> String {
    var hash = str
    for _ in 0..<2017 {
        hash = hash.md5
    }
    return hash
}

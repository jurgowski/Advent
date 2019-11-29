import Foundation

public func generateMap(input: String) -> [String: [String: Int]] {
    var map = [String: [String: Int]]()
    
    let statements = input.components(separatedBy: CharacterSet.newlines)
    
    for statement in statements {
        let words = statement.components(separatedBy: " ")
        let source = words[0]
        let isPositive = "gain" == words[2]
        let amount = (isPositive ? 1 : -1) * Int(words[3])!
        let target = words[10].trimmingCharacters(in: CharacterSet.punctuationCharacters)
        
        var connections = map[source] ?? Dictionary()
        connections[target] = amount
        map[source] = connections
    }
    
    return map
}

public func optimalSeating(map: [String: [String: Int]]) -> Int {
    let allGuests = Array(map.keys)
    let allPermutations = permutations(Array(allGuests[1 ..< allGuests.endIndex]))
    var max = Int.min
    for permutation in allPermutations {
        let score = seatingScore(map: map, seating: [allGuests[0]] + permutation)
        if (score > max) {
            max = score
        }
    }
    return max
}

public func optimalSeatingWithMe(map: [String: [String: Int]]) -> Int {
    let allGuests = Array(map.keys)
    let allPermutations = permutations(allGuests)
    var max = Int.min
    for permutation in allPermutations {
        let score = seatingScoreWithMe(map: map, seating: permutation)
        if (score > max) {
            max = score
        }
    }
    return max
}

func seatingScore(map: [String: [String: Int]], seating: [String]) -> Int {
    var score = 0
    for i in 0..<seating.count {
        let guest = seating[i]
        let prevGuest = seating[i == 0 ? seating.count - 1 : i - 1]
        let nextGuest = seating[i == seating.count - 1 ? 0 : i + 1]
        score += map[guest]![prevGuest]!
        score += map[guest]![nextGuest]!
    }
    return score
}

func seatingScoreWithMe(map: [String: [String: Int]], seating: [String]) -> Int {
    var score = 0
    for i in 0..<seating.count {
        let guest = seating[i]
        let prevGuest = i == 0 ? "me" : seating[i - 1]
        let nextGuest = i == seating.count - 1 ? "me" : seating[i + 1]
        score += prevGuest == "me" ? 0 : map[guest]![prevGuest]!
        score += nextGuest == "me" ? 0 : map[guest]![nextGuest]!
    }
    return score
}

func permutations<Element>(_ arr: [Element]) -> [[Element]] {
    var counters = Array(repeating: 0, count: arr.count)
    var elements = Array(arr)
    var permutations = [Array(elements)]
    
    var i = 0
    while (i < arr.count) {
        if counters[i] < i {
            swap(&elements[(i % 2 == 0) ? 0: counters[i]], &elements[i])
            permutations.append(Array(elements))
            counters[i] += 1
            i = 0
        } else {
            counters[i] = 0
            i += 1
        }
    }
    return permutations
}

import Testing

private func part1(input: String, blinks: Int = 15) -> Int {
    var stones = input
        .split(separator: " ")
        .map { String($0) }
    
    for _ in 0..<blinks {
        stones = stones.flatMap { stone in
            if stone == "0" { return ["1"] }
            if stone.count % 2 == 0 {
                let middle = stone.index(stone.startIndex, offsetBy: stone.count / 2)
                return [
                    String(Int(stone[..<middle])!),
                    String(Int(stone[middle...])!)
                ]
            }
            return [ String(Int(stone)! * 2024) ]
        }
    }
    
    return stones.count
}

private struct Key: Hashable {
    let stone: String
    let step: Int
    
    var next: Key { Key(stone: stone, step: step + 1) }
}

private struct Summary {
    let key: Key
    let stones: Int
}

private class StoneCache {
    var cached: [Key: Int] = [:]
    
    func count(key: Key) -> Int {
        if let count = cached[key] {
            return count
        }
        
        if key.step == 0 { return 1 }
        
        if key.stone == "0" {
            let result = count(key: Key(stone: "1", step: key.step - 1))
            cached[key] = result
            return result
        }
        if key.stone.count % 2 == 0 {
            let middle = key.stone.index(key.stone.startIndex, offsetBy: key.stone.count / 2)
            let left = String(Int(key.stone[..<middle])!)
            let right = String(Int(key.stone[middle...])!)
            let result =
                count(key:Key(stone: left,  step: key.step - 1)) +
                count(key:Key(stone: right, step: key.step - 1))
            cached[key] = result
            return result
        }
        let result = count(key: Key(stone:String(Int(key.stone)! * 2024), step: key.step - 1))
        cached[key] = result
        return result
    }
}

private func part2(input: String, blinks: Int = 75) -> Int {
    let stoneCache = StoneCache()
    return input
        .split(separator: " ")
        .map { stoneCache.count(key: Key(stone: String($0), step: blinks)) }
        .reduce(0, +)
}

@Test func testDay11DebugPart1() async throws {
    #expect(part1(input: debugInput, blinks: 25) == 55312)
}

@Test func testDay11Part1() throws {
    print(part1(input: input))
}

@Test func testDay11Part2() async throws {
    #expect(part2(input: debugInput, blinks: 25) == 55312)
}

@Test func testDay11DebugPart2() async throws {
    print(part2(input: input))
}


private let debugInput = """
125 17
"""


private let input = """
337 42493 1891760 351136 2 6932 73 0
"""

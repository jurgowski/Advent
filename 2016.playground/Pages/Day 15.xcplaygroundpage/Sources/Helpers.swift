import Foundation

public func timeForCapsule(_ input: String) -> Int {
    let diskInstructions = input.components(separatedBy: CharacterSet.newlines)
    var diskStates = [(Int, Int, Int)]()
    
    for diskInstruction in diskInstructions {
        let diskStatement = diskInstruction.components(separatedBy: " ")
        let diskPosition = diskStatement[1]
        let diskPositionNumber = Int(diskPosition.substring(from: diskPosition.index(after: diskPosition.startIndex)))!
        let diskPositionTotal = Int(diskStatement[3])!
        let diskPositionStart = Int(diskStatement[11].trimmingCharacters(in: CharacterSet.punctuationCharacters))!
        diskStates.append(diskPositionNumber, diskPositionTotal, diskPositionStart)
    }
    print(diskStates)
    var time = 0
    while (true) {
        if doesMatch(time, diskStates: diskStates) {
            return time
        }
        time += 1
        if (time % 1000000 == 0) {
            print(time)
        }
    }
    return 0
}

func doesMatch(_ time: Int, diskStates: [(Int, Int, Int)]) -> Bool {
    for diskState in diskStates {
        if (time + diskState.0 + diskState.2) % diskState.1 != 0 {
            return false
        }
    }
    return true
}

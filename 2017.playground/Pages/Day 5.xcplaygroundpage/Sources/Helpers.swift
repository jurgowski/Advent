import Foundation

public func jumpsUntilExit(input: String) -> Int {
  var instructions = input.components(separatedBy: CharacterSet.newlines).map { return Int($0)! }
  var steps = 0
  var location = 0

  while location >= 0 && location < instructions.count {
    let newLocation = location + instructions[location]
    instructions[location] += 1
    location = newLocation
    steps += 1
  }

  return steps
}

public func strangeJumpsUntilExit(input: String) -> Int {
  var instructions = input.components(separatedBy: CharacterSet.newlines).map { return Int($0)! }
  var steps = 0
  var location = 0

  while location >= 0 && location < instructions.count {
    let newLocation = location + instructions[location]
    instructions[location] += (instructions[location] >= 3) ? -1 : 1
    location = newLocation
    steps += 1
  }

  return steps
}

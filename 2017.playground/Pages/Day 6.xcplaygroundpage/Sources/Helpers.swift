import Foundation

func redistribute(instructions: Array<Int>) -> Array<Int> {
  var maxIndex = 0
  var maxValue = 0
  var newInstructions = instructions

  for (index, value) in instructions.enumerated() {
    if maxValue < value {
      maxValue = value
      maxIndex = index
    }
  }
  newInstructions[maxIndex] = 0

  let evenBump = maxValue / instructions.count
  let extraBump = maxValue % instructions.count

  newInstructions = newInstructions.map { return $0 + evenBump }
  if (extraBump != 0) {
    for i in 1...extraBump {
      let location = (i + maxIndex) % newInstructions.count
      newInstructions[location] += 1
    }
  }
  return newInstructions
}

public func loopsRun(input: String) -> Int {
  var loops = 0
  var instructions = input.components(separatedBy: " ").map { return Int($0)! }
  var seenInstructions : Array<Array<Int>> = [instructions]

  while true {
    instructions = redistribute(instructions: instructions)
    loops += 1
    if seenInstructions.contains(where: { return $0 == instructions }) {
      break
    }
    seenInstructions.append(instructions)
  }

  return loops
}

public func loopsRunAfterCycle(input: String) -> Int {

  var instructions = input.components(separatedBy: " ").map { return Int($0)! }
  var seenInstructions : Array<Array<Int>> = [instructions]

  while true {
    instructions = redistribute(instructions: instructions)
    if seenInstructions.contains(where: { return $0 == instructions }) {
      break
    }
    seenInstructions.append(instructions)
  }

  var loops = 0

  let goalInstructions = instructions

  while true {
    instructions = redistribute(instructions: instructions)
    loops += 1
    if instructions == goalInstructions {
      break
    }
  }

  return loops
}

//: [Previous](@previous)

import Foundation

public func firstRec(input: String) -> Int {
  let instructions = input.components(separatedBy: CharacterSet.newlines).map { return Instruction(string: $0) }

  let programZero = Program(id: 0)
  let programOne = Program(id: 1)
  var programOneSends = 0

  repeat {
    let oneQueue  = programZero.run(instructions: instructions)
    let zeroQueue = programOne.run(instructions: instructions)
    programOne.queue += oneQueue
    programZero.queue += zeroQueue
    programOneSends += zeroQueue.count
  } while !programZero.queue.isEmpty || !programOne.queue.isEmpty
  
  return programOneSends
}

let fileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let input = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
firstRec(input: input)

//: [Previous](@previous)

import Foundation

public func day20(input: String) -> (Int, Int) {

  let particles = input.components(separatedBy: CharacterSet.newlines).map { (text) in
    return Particle(input: text)
  }

  let minElement = closest(particles: particles)

  return (minElement.id, processCollitions(ticks: 1000, particles: particles).count)
}

let fileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let input = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
day20(input: input)


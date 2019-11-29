import Foundation

public func countOfStrictPairs(rounds: Int, startA: Int, startB: Int) -> Int {
  var currentA = startA
  var currentB = startB

  let aFactor = 16807
  let bFactor = 48271

  let cap = 2147483647

  var matches = 0

  for _ in 0...rounds {
    repeat { currentA = (currentA * aFactor) % cap } while currentA % 4 != 0
    repeat { currentB = (currentB * bFactor) % cap } while currentB % 8 != 0
    if (currentA % 65536 == currentB % 65536) {
      matches += 1
    }
  }

  return matches
}

public func countOfPairs(rounds: Int, startA: Int, startB: Int) -> Int {
  var currentA = startA
  var currentB = startB

  let aFactor = 16807
  let bFactor = 48271

  let cap = 2147483647

  var matches = 0

  for _ in 0...rounds {
    currentA = (currentA * aFactor) % cap
    currentB = (currentB * bFactor) % cap
    if (currentA % 65536 == currentB % 65536) {
      matches += 1
    }
  }

  return matches
}

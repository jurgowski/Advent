import Foundation

public func parseGroup(stream: String) -> (Int, Int) {
  var currentIndex = stream.startIndex
  var groupDepth = 0
  var groupCount = 0
  var totalScore = 0
  var garbage = false
  var garbageAmount = 0

  while currentIndex < stream.endIndex {
    switch stream[currentIndex] {
    case "{":
      if garbage {
        garbageAmount += 1
      } else {
        groupDepth += 1
      }
    case "}":
      if garbage {
        garbageAmount += 1
      } else {
        totalScore += groupDepth
        groupCount += 1
        groupDepth -= 1
      }
    case "<":
      if garbage {
        garbageAmount += 1
      } else {
        garbage = true
      }
    case ">":
      garbage = false
    case "!":
      currentIndex = stream.index(after: currentIndex)
    default:
      if garbage {
        garbageAmount += 1
      }
    }
    currentIndex = stream.index(after: currentIndex)
  }
  return (totalScore, garbageAmount)
}


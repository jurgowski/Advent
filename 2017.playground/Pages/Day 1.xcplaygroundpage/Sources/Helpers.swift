import Foundation

public func captchaSingle(input: String) -> Int {
  var total = 0
  var currentIndex = input.startIndex

  while currentIndex < input.endIndex {
    let prevChar = currentIndex == input.startIndex ? input.last : input[input.index(before: currentIndex)]
    if prevChar == input[currentIndex] {
      total += Int(String(prevChar!))!
    }
    currentIndex = input.index(after: currentIndex)
  }

  return total
}

public func captchaHalf(input: String) -> Int {
  var total = 0
  var leftIndex = input.startIndex
  var rightIndex = input.endIndex

  while leftIndex < rightIndex {
    leftIndex = input.index(after: leftIndex)
    rightIndex = input.index(before: rightIndex)
  }

  leftIndex = input.startIndex

  while rightIndex < input.endIndex {
    if input[leftIndex] == input[rightIndex] {
      total += ( Int(String(input[leftIndex]))! * 2)
    }
    leftIndex = input.index(after: leftIndex)
    rightIndex = input.index(after: rightIndex)
  }

  return total
}

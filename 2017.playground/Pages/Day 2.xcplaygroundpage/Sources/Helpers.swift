import Foundation

public func easyChecksum(input: String) -> Int {
  let rows = input.components(separatedBy: CharacterSet.newlines)
  var total = 0

  for row in rows {
    let values = row.components(separatedBy: "  ").map{Int($0)!}
    let diff = values.max()! - values.min()!
    total += diff
  }

  return total
}

public func normalChecksum(input: String) -> Int {
  let rows = input.components(separatedBy: CharacterSet.newlines)
  var total = 0

  for row in rows {
    let values = row.components(separatedBy: "  ").map{Int($0)!}
    let diff = (_evenDivisor(numbers: values))
    total += diff
  }

  return total
}

func _evenDivisor(numbers: [Int]) -> Int {
  for (index, left) in numbers.enumerated() {
    for right in numbers[index...] {
      let larger = left > right ? left : right
      let smaller = left < right ? left : right
      if larger != smaller && larger % smaller == 0 {
        return larger / smaller
      }
    }
  }
  return 0
}

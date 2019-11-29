import Foundation

func denseHash(sparseHash: [Int]) -> [Int] {
  precondition(sparseHash.count == 256)
  var denseList: [Int] = []
  for i in 0..<16 {
    denseList.append(sparseHash[(i*16)..<((i+1)*16)].reduce(0, ^))
  }
  return denseList
}

public func knotHash(key: String) -> [Int] {
  let input = key.utf8.map { Int($0) }
  let listSize = 256
  var currentIndex = 0
  var currentSkipSize = 0
  var list = Array(0..<listSize)
  let lengths = input + [17, 31, 73, 47, 23]

  for _ in 0..<64 {
    for length in lengths {
      if currentIndex + length > list.count {
        let suffixRange = currentIndex..<list.count
        let prefixRange = 0..<((currentIndex + length) % list.count)
        let sublist = (list[suffixRange] + list[prefixRange]).reversed()
        list.replaceSubrange(prefixRange, with: sublist.suffix(prefixRange.count))
        list.replaceSubrange(suffixRange, with: sublist.prefix(suffixRange.count))
      } else {
        let range = currentIndex..<currentIndex + length
        let sublist = list[range].reversed()
        list.replaceSubrange(range, with: sublist)
      }
      currentIndex += length + currentSkipSize
      currentIndex = currentIndex % list.count
      currentSkipSize += 1
    }
  }

  return denseHash(sparseHash: list)
}


func flatBinary(_ int: Int) -> String {
  let string = String(int, radix:2)
  return String(repeating:"0", count:8 - string.count) + string
}

func convertRecursively(x: Int, y: Int, charGrid: inout [[Character]]) {
  guard
      x >= 0 && x < charGrid.count &&
      y >= 0 && y < charGrid.count &&
      charGrid[y][x] == "1"
    else { return }
  charGrid[y][x] = "0"
  convertRecursively(x: x - 1, y: y, charGrid: &charGrid)
  convertRecursively(x: x + 1, y: y, charGrid: &charGrid)
  convertRecursively(x: x, y: y + 1, charGrid: &charGrid)
  convertRecursively(x: x, y: y - 1, charGrid: &charGrid)
}

func regionCount(hashes: [[Int]]) -> Int {
  var charGrid = hashes.map { (row) -> [Character] in
    Array(row.map { flatBinary($0) }.joined())
  }

  var regions = 0
  let gridSize = charGrid.count
  for y in 0..<gridSize {
    for x in 0..<gridSize {
      if charGrid[y][x] == "1" {
        convertRecursively(x: x, y: y, charGrid: &charGrid)
        regions += 1
      }
    }
  }
  return regions
}

public func makeGrid(input: String) -> (Int, Int) {
  let range = 0..<128
  let hashes = range
    .map { (current) -> [Int] in
      return knotHash(key: "\(input)-\(current)")
  }

  let bitCount = hashes.reduce(0) { (currentSum, hash) -> Int in
    return currentSum + hash.map { $0.nonzeroBitCount }.reduce(0, +)
  }

  return (bitCount, regionCount(hashes: hashes))
}




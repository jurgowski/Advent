import Foundation

func denseHash(sparseHash: [Int]) -> [Int] {
  precondition(sparseHash.count == 256)
  var denseList: [Int] = []
  for i in 0..<16 {
    denseList.append(sparseHash[(i*16)..<((i+1)*16)].reduce(0, ^))
  }
  return denseList
}

public func knotHash(listSize: Int, input: [Int]) -> String {
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

  return denseHash(sparseHash: list).map { return String(format:"%.2x", $0) }.joined()
}

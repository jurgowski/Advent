import Foundation

func getSPosition(time: Int, size: Int) -> Int {
  let length = size - 1
  let oddPair = (time / length) % 2 == 1
  let position = time % length
  return oddPair ? length - position : position
}

func severity(layers: [(Int, Int)]) -> Int {
  return layers.reduce(0) { (currentSum, layer) -> Int in
    return currentSum + (getSPosition(time:layer.0, size: layer.1) == 0 ? layer.0 * layer.1 : 0)
  }
}

func detection(timeOffset: Int, layers: [(Int, Int)]) -> Bool {
  return layers.first { (layer) -> Bool in
    getSPosition(time: timeOffset + layer.0, size: layer.1) == 0
  } != nil
}

public func tripData(input:String) -> (Int, Int) {
  let layers = input.components(separatedBy: CharacterSet.newlines)
    .map { (line) -> (Int, Int) in
      let layerParts = line.components(separatedBy: ": ")
      return (Int(layerParts[0])!, Int(layerParts[1])!)
  }

  var offset = 0
  while (true) {
    if (detection(timeOffset: offset, layers: layers) == false) {
      break
    }
    offset += 1
  }
  return (severity(layers: layers), offset)
}

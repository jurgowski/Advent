import Foundation

func calcDistance(east: Int, north: Int) -> Int {
  let xDistance = abs(east)
  let yDistance = abs(north)
  let neededYDistance = xDistance > yDistance ? 0 : yDistance - xDistance
  return xDistance + neededYDistance / 2
}

public func distance(input: String) -> (Int, Int) {
  let steps = input.components(separatedBy: ",")

  var north = 0
  var east = 0
  var maxY = 0
  var maxX = 0

  for step in steps {
    switch step {
    case "n":   north += 2;
    case "s":   north -= 2;
    case "ne":  north += 1; east += 1
    case "nw":  north += 1; east -= 1
    case "se":  north -= 1; east += 1
    case "sw":  north -= 1; east -= 1
    default:
      fatalError()
    }
    maxX = maxX < abs(east) ? abs(east) : maxX
    maxY = maxY < abs(north) ? abs(north) : maxY
  }

  return (calcDistance(east: east, north: north), calcDistance(east: maxX, north: maxY))
}

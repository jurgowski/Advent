import Foundation

public func spiralDistance(input: Int) -> Int {
  var multiplier = 1
  var distance = multiplier * multiplier

  while distance < input {
    multiplier += 2
    distance = multiplier * multiplier
  }

  let jump = multiplier - 1
  while distance > input {
    distance -= jump
  }

  let edgeLenght = input - distance
  let distanceFromCenter = (edgeLenght - (jump / 2))

  return jump / 2 + Int(distanceFromCenter)
}

enum Direction {
  case north
  case east
  case west
  case south

  func turn() -> Direction {
    switch self {
    case .north: return .west
    case .south: return .east
    case .west: return .south
    case .east: return .north
    }
  }

  func progress(location:Location) -> Location {
    switch self {
    case .north: return Location(x: location.x, y:location.y + 1)
    case .south: return Location(x: location.x, y:location.y - 1)
    case .west:  return Location(x: location.x - 1, y:location.y)
    case .east:  return Location(x: location.x + 1, y:location.y)
    }
  }
}

struct Location: Hashable {
  let x: Int
  let y: Int

  static func ==(lhs: Location, rhs: Location) -> Bool { return lhs.x == rhs.x && lhs.y == rhs.y }
  var hashValue: Int { return x.hashValue ^ y.hashValue }
}

func neighborSum(location: Location, map:[Location:Int]) -> Int {
  var sum = 0
  for x in -1...1 {
    for y in -1...1 {
      if x == 0 && y == 0 { continue }
      sum += map[Location(x:location.x + x, y:location.y + y)] ?? 0
    }
  }
  return sum
}

public func firstLarger(input: Int) -> Int {
  var currentValue = 1
  var visited = [ Location(x:0,y:0) : 1 ]
  var currentDirection = Direction.east
  var currentLocation = Location(x:0, y:0)

  while currentValue < input {
    currentLocation = currentDirection.progress(location: currentLocation)
    currentValue = neighborSum(location: currentLocation, map: visited)
    visited[currentLocation] = currentValue
    let proposedLocation = currentDirection.turn().progress(location: currentLocation)
    currentDirection = visited[proposedLocation] == nil ? currentDirection.turn() : currentDirection
    //print("\(currentLocation) sum: \(currentValue)")
  }

  return currentValue
}

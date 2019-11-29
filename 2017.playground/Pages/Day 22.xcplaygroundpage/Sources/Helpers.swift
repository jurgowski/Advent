import Foundation

enum Direction {
  case N
  case S
  case E
  case W

  func turn(left: Bool) -> Direction {
    switch self {
    case .N: return left ? .W : .E
    case .S: return left ? .E : .W
    case .E: return left ? .N : .S
    case .W: return left ? .S : .N
    }
  }
}

enum Infection {
  case Infected
  case Weakened
  case Flagged

  static func stain(current: Infection?) -> Infection? {
    guard let infection = current else {
      return Infection.Weakened
    }
    switch infection {
    case .Infected: return .Flagged
    case .Weakened: return .Infected
    case .Flagged:  return nil
    }
  }

  static func turn(current: Infection?, direction: Direction) -> Direction {
    guard let infection = current else {
      return direction.turn(left: true)
    }
    switch infection {
    case .Infected: return direction.turn(left: false)
    case .Weakened: return direction
    case .Flagged:  return direction.turn(left: true).turn(left: true)
    }
  }
}

struct Position: Hashable {
  let x: Int
  let y: Int

  public var hashValue: Int { return x.hashValue ^ (y.hashValue << 12) }
  public static func ==(lhs: Position, rhs: Position) -> Bool { return lhs.x == rhs.x && lhs.y == rhs.y }

  public func progress(direction: Direction) -> Position {
    switch direction {
    case .N:  return Position(x: self.x, y: self.y - 1)
    case .S:  return Position(x: self.x, y: self.y + 1)
    case .W:  return Position(x: self.x - 1, y: self.y)
    case .E:  return Position(x: self.x + 1, y: self.y)
    }
  }
}


public func day22(input: String, steps: Int) -> Int {
  let nodeRows = input.components(separatedBy: CharacterSet.newlines).map { (row) -> [Bool] in
    return row.map {
      switch $0 {
      case ".": return false
      case "#": return true
      default: fatalError()
      }
    }
  }

  var infectedMap: [Position: Infection] = [:]

  for i in 0..<nodeRows.count {
    for j in 0..<nodeRows[i].count {
      if (nodeRows[i][j] == true) {
        infectedMap[Position(x:j, y:i)] = .Infected
      }
    }
  }

  var currentDirection = Direction.N
  var currentPosition = Position(x:nodeRows.count/2, y: nodeRows.count/2)
  var infections = 0

  for _ in 0..<steps {
    currentDirection = Infection.turn(current: infectedMap[currentPosition], direction: currentDirection)
    let currentInfection: Infection? = Infection.stain(current: infectedMap[currentPosition])
    infectedMap[currentPosition] = currentInfection
    if let actualInfection = currentInfection {
      switch actualInfection {
      case .Infected: infections += 1
      default: break
      }
    }
    currentPosition = currentPosition.progress(direction: currentDirection)
  }

  return infections
}

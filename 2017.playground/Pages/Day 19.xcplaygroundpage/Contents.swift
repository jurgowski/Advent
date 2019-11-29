//: [Previous](@previous)

import Foundation



enum Node {
  case Empty
  case Continue
  case Turn
  case Letter(Character)

  public func isEmpty() -> Bool {
    switch self {
    case .Empty:  return true
    default:      return false
    }
  }
}

struct Position {
  let x: Int
  let y: Int

  public func nextPosition(direction: Direction) -> Position {
    switch direction {
    case .N: return Position(x, y - 1)
    case .S: return Position(x, y + 1)
    case .E: return Position(x + 1, y)
    case .W: return Position(x - 1, y)
    }
  }

  public func node(_ grid: [[Node]]) -> Node {
    guard y < grid.count && x < grid[y].count else {
      return Node.Empty
    }

    return grid[y][x]
  }

  init(_ x: Int, _ y: Int) {
    self.x = x
    self.y = y
  }
}

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

public func traversePath(input: String) -> (String, Int) {
  let grid = input.components(separatedBy: CharacterSet.newlines).map { (line) -> [Node] in
    return line.map { (char) in
      switch char {
      case " ": return Node.Empty
      case "|", "-": return Node.Continue
      case "+": return Node.Turn
      default: return Node.Letter(char)
      }
    }
  }

  var currentPosition = Position(0, 0)
  var currentDirection = Direction.S

  while currentPosition.node(grid).isEmpty() {
    currentPosition = Position(currentPosition.x + 1, currentPosition.y)
  }

  var totalSteps = 0
  var currentString = ""

  while !currentPosition.node(grid).isEmpty() {
    switch currentPosition.node(grid) {
    case .Continue:
      break
    case .Turn:
      let hasValidLeftTurn = currentPosition.nextPosition(direction: currentDirection.turn(left: false)).node(grid).isEmpty()
      currentDirection = currentDirection.turn(left: hasValidLeftTurn)
    case .Letter(let char):
      print(char)
      currentString.append(char)
    case .Empty:
      fatalError()
    }
    totalSteps += 1
    currentPosition = currentPosition.nextPosition(direction: currentDirection)
    //print("\(currentPosition.x) \(currentPosition.y) \(currentDirection)")
  }
  return (currentString, totalSteps)
}

let fileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let input = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
traversePath(input: input)

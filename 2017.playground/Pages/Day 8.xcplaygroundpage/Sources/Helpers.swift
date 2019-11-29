import Foundation

struct Instruction {
  enum Shift {
    case inc (Int)
    case dec (Int)

    static func parseShift(type: String, value:Int) -> Shift {
      assert(type == "inc" || type == "dec")
      return type == "inc" ? Shift.inc(value) : Shift.dec(value)
    }

    func apply(value: Int) -> Int {
      switch self {
      case .inc(let amount): return value + amount
      case .dec(let amount): return value - amount
      }
    }
  }

  struct Condition {
    enum Comparison {
      case lessThan
      case greaterThan
      case lessOrEqual
      case greaterOrEqual
      case equal
      case notEqual
    }

    let variable: String
    let constant: Int
    let comparison: Comparison

    init(variable: String, comparisonString: String, constant: Int) {
      self.variable = variable
      self.constant = constant
      switch comparisonString {
      case "<": self.comparison = Comparison.lessThan
      case ">": self.comparison = Comparison.greaterThan
      case "<=": self.comparison = Comparison.lessOrEqual
      case ">=": self.comparison = Comparison.greaterOrEqual
      case "==": self.comparison = Comparison.equal
      case "!=": self.comparison = Comparison.notEqual
      default: fatalError("bad comparison \(comparisonString)")
      }
    }

    func passes(value: Int) -> Bool {
      switch comparison {
      case .lessThan:       return value < constant
      case .greaterThan:    return value > constant
      case .lessOrEqual:    return value <= constant
      case .greaterOrEqual: return value >= constant
      case .equal:          return value == constant
      case .notEqual:       return value != constant
      }
    }
  }

  let variable: String
  let shift: Shift
  let condition: Condition

  init(row: String) {
    let components = row.components(separatedBy: " ")
    precondition(components.count == 7)

    self.variable = components[0]
    self.shift = Shift.parseShift(type: components[1], value: Int(components[2])!)
    precondition(components[3] == "if")
    self.condition = Condition(variable: components[4],
                               comparisonString: components[5],
                               constant: Int(components[6])!)

  }
}

public func largestValue(input: String) -> (Int, Int) {
  let instructionRows = input.components(separatedBy: CharacterSet.newlines)
  let instructions = instructionRows.map { Instruction(row: $0) }
  var registers = [String: Int]()
  var maxVariable = 0

  for instruction in instructions {
    let conditionConstant = registers[instruction.condition.variable] ?? 0
    if (instruction.condition.passes(value: conditionConstant)) {
      let currentValue = registers[instruction.variable] ?? 0
      let newValue = instruction.shift.apply(value: currentValue)
      registers[instruction.variable] = newValue
      maxVariable = maxVariable >= newValue ? maxVariable : newValue
    }
  }

  return (registers.values.max() ?? 0 , maxVariable)
}

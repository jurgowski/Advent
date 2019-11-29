import Foundation



public enum Variable {
  case Register(Character)
  case Constant(Int)

  public init(_ string: String) {
    if let constant = Int(string) {
      self = .Constant(constant)
    } else {
      self = .Register(string.first!)
    }
  }

  public func value(map:[Character: Int]) -> Int {
    switch self {
    case .Constant(let const):
      return const
    case .Register(let reg):
      return map[reg] ?? 0
    }
  }
}

public enum Instruction {
  case Send(Variable)
  case Set(Character, Variable)
  case Add(Character, Variable)
  case Multiply(Character, Variable)
  case Modulo(Character, Variable)
  case Receive(Character)
  case Jump(Variable, Variable)

  public init(string: String) {
    let components = string.components(separatedBy: " ")
    switch components[0] {
    case "snd": self = .Send(Variable(components[1]))
    case "set": self = .Set(components[1].first!, Variable(components[2]))
    case "add": self = .Add(components[1].first!, Variable(components[2]))
    case "mul": self = .Multiply(components[1].first!, Variable(components[2]))
    case "mod": self = .Modulo(components[1].first!, Variable(components[2]))
    case "rcv": self = .Receive(components[1].first!)
    case "jgz": self = .Jump(Variable(components[1]), Variable(components[2]))
    default:
      fatalError()
    }
  }
}

public class Program {
  var instruction = 0
  var registers: [Character: Int] = [:]
  public var queue: [Int] = []
  let program: Int

  public init(id: Int) {
    program = id
    registers["p"] = id
  }

  public func run(instructions: [Instruction]) -> [Int] {
    var sends: [Int] = []
    print ("\(program) starts with queue: \(queue.count) at instruction \(instruction)")
    //print(queue)
    while (instruction >= 0 && instruction < instructions.count) {
      switch instructions[instruction] {
      case .Send(let v):
        //print("send \(v.value(map: registers)) - \(registers)")
        sends.append(v.value(map: registers))
      case .Set(let reg, let v):      registers[reg] = v.value(map: registers)
      case .Add(let reg, let v):      registers[reg] = (registers[reg] ?? 0) + v.value(map: registers)
      case .Multiply(let reg, let v): registers[reg] = (registers[reg] ?? 0) * v.value(map: registers)
      case .Modulo(let reg, let v):   registers[reg] = (registers[reg] ?? 0) % v.value(map: registers)
      case .Receive(let reg):
        if !queue.isEmpty {
          registers[reg] = queue.removeFirst()
          //print ("\(program) recieves with left: \(queue.count)")
        } else {
          //print ("\(program) locks at instruction: \(instruction), sent \(sends.count)")
          return sends
        }
      case .Jump(let v1, let v2):
        if (v1.value(map: registers)) > 0 {
          instruction += v2.value(map: registers)
          continue
        }
      }
      instruction += 1
    }
    print("Terminated")
    return sends
  }
}

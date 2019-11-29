import Foundation

enum Variable {
    case register(String)
    case constant(Int)
    
    func value(_ registers: [String : Int]) -> Int {
        switch self {
        case .register(let reg):
            return registers[reg]!
        case .constant(let const):
            return const
        }
    }
    
    init(code: String) {
        if let const = Int(code) {
            self = .constant(const)
        } else {
            self = .register(code)
        }
    }
}

enum Instruction {
    case inc(Variable)
    case dec(Variable)
    case copy(Variable, Variable)
    case jump(Variable, Variable)
    case toggle(Variable)
    case out(Variable)
    
    func toggled() -> Instruction {
        switch self {
        case .inc(let var1):            return .dec(var1)
        case .dec(let var1):            return .inc(var1)
        case .toggle(let var1):         return .inc(var1)
        case .out(let var1):            return .inc(var1)
        case .copy(let var1, let var2): return .jump(var1, var2)
        case .jump(let var1, let var2): return .copy(var1, var2)
        }
    }
}

func parse(_ instructions:[String]) -> [Instruction] {
    return instructions.map({ (instruction) -> Instruction in
        let line = instruction.components(separatedBy: " ")
        switch line[0] {
        case "inc":  return Instruction.inc(Variable(code:line[1]))
        case "dec":  return Instruction.dec(Variable(code:line[1]))
        case "tgl":  return Instruction.toggle(Variable(code:line[1]))
        case "out":  return Instruction.out(Variable(code:line[1]))
        case "cpy":  return Instruction.copy(Variable(code:line[1]), Variable(code:line[2]))
        case "jnz":  return Instruction.jump(Variable(code:line[1]), Variable(code:line[2]))
        default: abort()
        }
    })
}

public func valueOfA(_ input: String, a: Int) -> Int {
    var registers = ["a" : a,
                     "b" : 0,
                     "c" : 0,
                     "d" : 0]
    
    var instructions = parse(input.components(separatedBy: CharacterSet.newlines))
    var index = 0
    var instructionCount = 0
    
    while (index < instructions.count) {
        instructionCount += 1
        if (instructionCount % 2000000 == 0) {
            print("\(instructionCount) instructions ran")
            print(registers)
        }
        if (index == 8 || index == 20) {
            //print("Starting with \(registers) after \(instructionCount) instructions at \(index)")
        }
        let instruction = instructions[index]
        switch instruction {
        case .copy(let var1, let var2):
            if case .register(let reg) = var2 {
                registers[reg] = var1.value(registers)
            }
        case .inc(let var1):
            if case .register(let reg) = var1 {
                registers[reg] = registers[reg]! + 1
            }
        case .dec(let var1):
            if case .register(let reg) = var1 {
                registers[reg] = registers[reg]! - 1
            }
        case .jump(let var1, let var2):
            if var1.value(registers) != 0 {
                index += var2.value(registers)
                continue
            }
        case .toggle(let var1):
            let indexToToggle = index + var1.value(registers)
            print("Will toggle \(indexToToggle) which is \(var1.value(registers)) away")
            if indexToToggle >= 0 && indexToToggle < instructions.count {
                instructions[indexToToggle] = instructions[indexToToggle].toggled()
            }
        case .out(let var1):
            print("Out \(var1.value(registers))")
        }
        index += 1
    }
    
    return registers["a"]!
}

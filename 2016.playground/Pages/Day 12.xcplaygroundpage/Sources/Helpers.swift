import Foundation


public func valueOfA(_ input: String, c: Int) -> Int {
    var registers = ["a" : 0,
                     "b" : 0,
                     "c" : c,
                     "d" : 0]
    
    let instructions = input.components(separatedBy: CharacterSet.newlines)
    var index = 0
    var instructionCount = 0
    
    while (index < instructions.count) {
        instructionCount += 1
        if (instructionCount % 20000 == 0) {
            print("\(instructionCount) instructions ran")
            print(registers)
        }
        let line = instructions[index].components(separatedBy: " ")
        switch line[0] {
        case "cpy":
            registers[line[2]] = Int(line[1]) ?? registers[line[1]]!
        case "inc":
            registers[line[1]] = registers[line[1]]! + 1
        case "dec":
            registers[line[1]] = registers[line[1]]! - 1
        case "jnz":
            if (Int(line[1]) ?? registers[line[1]]!) != 0 {
                index += Int(line[2])!
                continue
            }
        default: assertionFailure()
        }
        index += 1
    }
    
    return registers["a"]!
}

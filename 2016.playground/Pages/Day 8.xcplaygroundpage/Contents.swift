//: Day 8

import Foundation

let fileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let input =
    try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
        .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

func numberOfLitPixels(_ input: String) -> Int {
    let grid: [[Bool]] = [[Bool]](repeating: [Bool](repeating: false, count: 50), count: 6)
    let instructions = input.components(separatedBy: CharacterSet.newlines)
    let processedGrid = instructions.reduce(grid) {
        (grid, instruction) -> [[Bool]] in
        return process(instruction: instruction, grid: grid)
    }
    print(processedGrid.map({ (boolArray) -> [Character] in
        return boolArray.map({ (bool) -> Character in
            return bool ? "*" : " "
        })
    }))
    return processedGrid.reduce(0) {
        return $0 + $1.reduce(0) {
            return $0 + ($1 ? 1 : 0)
        }
    }
}

func process(instruction: String, grid: [[Bool]]) -> [[Bool]] {
    let commands = instruction.components(separatedBy: " ")
    switch commands[0] {
    case "rect":
        let dims = commands[1].components(separatedBy: "x")
        return addRect(grid,
                       x: Int(dims[0])!,
                       y: Int(dims[1])!)
    case "rotate":
        switch commands[1] {
        case "row":
            return rotateRow(grid,
                             row: Int(commands[2].components(separatedBy: "=")[1])!,
                             distance: Int(commands[4])!)
        case "column":
            return rotateColumn(grid,
                                column: Int(commands[2].components(separatedBy: "=")[1])!,
                                distance: Int(commands[4])!)
        default: assertionFailure()
        }
    default: assertionFailure()
    }
    return grid
}

func addRect(_ originalRect: [[Bool]], x: Int, y: Int) -> [[Bool]] {
    var rect = originalRect
    for j in 0..<y {
        for i in 0..<x {
            rect[j][i] = true
        }
    }
    return rect
}

func rotateRow(_ originalRect: [[Bool]], row: Int, distance: Int) -> [[Bool]] {
    var rect = originalRect
    let rowLength = originalRect[row].count
    for i in 0..<rowLength {
        rect[row][(i + distance) % rowLength] = originalRect[row][i]
    }
    return rect
}

func rotateColumn(_ originalRect: [[Bool]], column: Int, distance: Int) -> [[Bool]] {
    var rect = originalRect
    let columnLength = originalRect.count
    for i in 0..<columnLength {
        rect[(i + distance) % columnLength][column] = originalRect[i][column]
    }
    return rect
}

numberOfLitPixels(input)

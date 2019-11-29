import Foundation

public func safeTiles(_ input: String, rows: Int) -> Int {
    var firstRow = [Bool]()
    for char in input.characters {
        switch char {
        case ".":
            firstRow.append(false)
        case "^":
            firstRow.append(true)
        default: assertionFailure()
        }
    }
    var allRows = [firstRow]
    for i in 0..<rows-1 {
        allRows.append(genRow(allRows[i]))
    }
    var safeTiles = 0
    for row in allRows {
        for trap in row {
            if !trap {
                safeTiles += 1
            }
        }
    }
    return safeTiles
}

func genRow(_ row: [Bool]) -> [Bool] {
    var next = [Bool]()
    for i in 0..<row.count {
        let isLeftTrap = i > 0 ? row[i - 1] : false
        let isRightTrap = i < row.count - 1 ? row[i + 1] : false
        next.append(isLeftTrap != isRightTrap)
    }
    return next
}

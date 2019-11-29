//  Created by Krys Jurgowski on 12/2/18.
//  Copyright © 2018 United States. All rights reserved.

import Foundation

func day11a(_ input: String) -> String {
    let serial = Int(input)!
    var max = 0
    var gridPoint = (0,0)
    for x in 1..<298 {
        for y in 1..<298 {
            let sum = (0..<3).reduce(0) {
                (current, i) -> Int in
                return current + (0..<3).reduce(0) { $0 + powerLevel(x: x + i, y: y + $1, serial: serial) }
            }
            if sum > max {
                max = sum
                gridPoint = (x, y)
            }
        }
    }
    return "\(gridPoint)"
}

func day11b(_ input: String) -> String {
    let serial = Int(input)!
    var max = 0
    var gridPoint = (0, 0, 0)

    var previousGrid = Array(repeating: Array(repeating: 0, count: 301), count: 301)

    for size in 1..<300 {
        var currentGrid = Array(repeating: Array(repeating: 0, count: 301), count: 301)
        for x in 1..<(300-size) {
            for y in 1..<(300-size) {
                currentGrid[x][y] =
                    previousGrid[x+1][y] + previousGrid[x][y+1] - previousGrid[x][y] + powerLevel(x: x + size,
                                                                                                  y: y + size,
                                                                                                  serial: serial)
                if currentGrid[x][y] > max {
                    max = currentGrid[x][y]
                    gridPoint = (x, y, size)
                }
            }
        }
        previousGrid = currentGrid
        print(size)
        print(gridPoint)
    }

//    for size in 1..<300 {
//        for x in 1..<(300-size) {
//            for y in 1..<(300-size) {
//                let sum = (0..<size).reduce(0) {
//                    (current, i) -> Int in
//                    return current + (0..<size).reduce(0) { $0 + powerLevel(x: x + i, y: y + $1, serial: serial) }
//                }
//                if sum > max {
//                    max = sum
//                    gridPoint = (x, y, size)
//                }
//            }
//        }
//        print(size)
//        print(gridPoint)
//    }




//    var singleGrid = Array(repeating: Array(repeating: 0, count: 301), count: 301)
//    for x in 1..<301 {
//        for y in 1..<301 {
//            singleGrid[x][y] = powerLevel(x: x, y: y, serial: serial)
//        }
//    }
//
//    for size in 2..<300 {
//        for x in 1..<(300 - size) {
//            for y in 1..<(300 - size) {
//                var power = 0
//                for i in 0..<size {
//                    for j in 0..<size {
//                        power += singleGrid[i][j]
//                    }
//                }
//                if power > max {
//                    gridPoint = (x, y, size)
//                    max = power
//                }
//            }
//        }
//        print(size)
//    }


//    let singleGrid = previousGrid
//    for size in 2..<300 {
//        var seed = previousGrid[1][1] + singleGrid[size][size]
//        for x in 1..<size {
//            seed += singleGrid[x][size]
//        }
//        for y in 1..<size {
//            seed += singleGrid[size][y]
//        }
//        previousGrid[1][1] = seed
//        for x in 1..<(300-size) {
//            for y in 1..<(300-size) {
//                previousGrid[x][y] = previousGrid[x][y-1]
//            }
//        }
//
//    }



//    for x in 1..<300 {
//        for y in 1..<300 {
//            var grid = Array(repeating: Array(repeating: 0, count: 300), count: 300)
//            for i in x..<300 {
//                for j in y..<300 {
//                    grid[i][j] = powerLevel(x: i, y: j, serial: serial)
//                        + grid[i-1][j]
//                        + grid[i][j-1]
//                        - grid[i-1][j-1]
//                    if i == j {
//                        if grid[i][j] > max {
//                            gridPoint = (x, y, i)
//                            max = grid[i][j]
//                        }
//                    }
//                }
//            }
//        }
//        print(x)
//    }
    return "\(gridPoint)"
}

private func powerLevel(x: Int, y: Int, serial: Int) -> Int {
    let rack = x + 10
    let power = ((y * rack) + serial) * rack
    return ((power / 100) % 10) - 5
}




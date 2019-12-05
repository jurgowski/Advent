//  Created by Krys Jurgowski on 12/5/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func intcode(_ program: [Int], _ input:Int = 0) -> Int {
    var mem = program

    var i = 0
    var pCount = -1

    while mem[i] != 99 {
        let opCode = mem[i] % 100
        let paramaters = mem[i] / 100
        let ps = { (p: Int) in pCount = p }
        let write = { (p: Int, x:Int) in mem[mem[i+p+1]] = x }
        let read = { (param: Int) -> Int in
            let div = (0..<param).reduce(1) { (c, i) -> Int in c * 10 }
            let mode = (paramaters / div) % 10
            switch mode {
            case 0: return mem[mem[i+param+1]]
            case 1: return mem[i+param+1]
            default: fatalError()
            }
        }
        switch opCode {
        case 1: ps(3); write(2, read(0) + read(1))
        case 2: ps(3); write(2, read(0) * read(1))
        case 3: ps(1); write(0, input)
        case 4: ps(1); print("out: \(read(0))")
        case 5: ps(2); if read(0) != 0 { i = read(1); ps(-1) }
        case 6: ps(2); if read(0) == 0 { i = read(1); ps(-1) }
        case 7: ps(3); write(2, read(0) < read(1) ? 1 : 0)
        case 8: ps(3); write(2, read(0) == read(1) ? 1 : 0)
        default: fatalError()
        }
        i += (pCount + 1)
    }

    return mem[0]
}

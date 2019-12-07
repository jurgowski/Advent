//  Created by Krys Jurgowski on 12/5/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

class IntCode {
    private(set) var terminated = false

    private var i = 0
    private var mem: [Int]
    private var inputs = [Int]()

    init(program: [Int]) {
        mem = program
    }

    func queueInput(_ input: Int) -> IntCode {
        inputs.append(input)
        return self
    }

    func run() -> Int {
        var pCount = -1
        var output: Int? = nil
        while mem[i] != 99 && output == nil {
            let opCode = mem[i] % 100
            let ps = mem[i] / 100
            let params = { (p: Int) in pCount = p }
            switch opCode {
            case 1: params(3); _write(2, _read(0, ps) + _read(1, ps))
            case 2: params(3); _write(2, _read(0, ps) * _read(1, ps))
            case 3: params(1); _write(0, inputs.removeFirst())
            case 4: params(1); output = _read(0, ps)
            case 5: params(2); if _read(0, ps) != 0 { i = _read(1, ps); params(-1) }
            case 6: params(2); if _read(0, ps) == 0 { i = _read(1, ps); params(-1) }
            case 7: params(3); _write(2, _read(0, ps)  < _read(1, ps) ? 1 : 0)
            case 8: params(3); _write(2, _read(0, ps) == _read(1, ps) ? 1 : 0)
            default: fatalError()
            }
            i += (pCount + 1)
        }
        terminated = mem[i] == 99
        return output ?? mem[0]
    }

    private func _write(_ parameter: Int, _ value: Int) {
        mem[mem[i+parameter+1]] = value
    }

    private func _read(_ parameter: Int, _ parameters: Int) -> Int {
        let div = (0..<parameter).reduce(1) { (c, i) -> Int in c * 10 }
        let mode = (parameters / div) % 10
        switch mode {
        case 0: return mem[mem[i+parameter+1]]
        case 1: return mem[i+parameter+1]
        default: fatalError()
        }
    }
}

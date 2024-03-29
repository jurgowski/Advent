//  Created by Krys Jurgowski on 12/5/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

class IntCode {
    private(set) var terminated = false

    private var i = 0
    private var mem: [Int]
    private var inputs = [Int]()
    private var inputAsk: () -> Int
    private var relBase = 0

    init(program: [Int]) {
        mem = program + Array(repeating: 0, count: 3000 - program.count)
        inputAsk = { fatalError() }
    }

    func inputer(_ inputs: @escaping () -> Int) {
        inputAsk = inputs
    }

    func queueInput(_ input: Int) -> IntCode {
        inputs.append(input)
        return self
    }

    func run() -> Int {
        assert(!terminated)
        var pCount = -1
        var output: Int? = nil
        while mem[i] != 99 && output == nil {
            let ps = mem[i] / 100
            let params = { (p: Int) in pCount = p }
            switch mem[i] % 100 {
            case 1: params(3); _write(2, ps, _read(0, ps) + _read(1, ps))
            case 2: params(3); _write(2, ps, _read(0, ps) * _read(1, ps))
            case 3: params(1); _write(0, ps, inputs.count == 0 ? inputAsk() : inputs.removeFirst())
            case 4: params(1); output = _read(0, ps); //print("out \(output!)")
            case 5: params(2); if _read(0, ps) != 0 { i = _read(1, ps); params(-1) }
            case 6: params(2); if _read(0, ps) == 0 { i = _read(1, ps); params(-1) }
            case 7: params(3); _write(2, ps, _read(0, ps)  < _read(1, ps) ? 1 : 0)
            case 8: params(3); _write(2, ps, _read(0, ps) == _read(1, ps) ? 1 : 0)
            case 9: params(1); relBase += _read(0, ps)
            default: fatalError()
            }
            i += (pCount + 1)
        }
        terminated = mem[i] == 99
        if terminated {
            print("Terminated!")
        }
        return output ?? mem[0]
    }

    private func _write(_ parameter: Int, _ parameters: Int, _ value: Int) {
        switch _mode(parameter, parameters) {
        case 0: mem[mem[i+1+parameter]] = value
        case 2: mem[mem[i+1+parameter]+relBase] = value
        default: fatalError()
        }
    }

    private func _read(_ parameter: Int, _ parameters: Int) -> Int {
        switch _mode(parameter, parameters) {
        case 0: return mem[mem[i+parameter+1]]
        case 1: return mem[i+parameter+1]
        case 2: return mem[mem[i+1+parameter]+relBase]
        default: fatalError()
        }
    }

    private func _mode(_ parameter: Int, _ parameters: Int) -> Int {
        let div = (0..<parameter).reduce(1) { (c, i) -> Int in c * 10 }
        return (parameters / div) % 10
    }
}

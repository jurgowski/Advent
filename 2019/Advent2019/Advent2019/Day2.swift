//  Created by Krys Jurgowski on 12/1/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func day2(_ input: String) -> (Int, Int) {
    var program = input
        .components(separatedBy: ",")
        .compactMap { Int($0) }

    let first = { () -> Int in
        program[1] = 12
        program[2] = 2
        return IntCode(program: program).run()
    }()

    for i in 0...100 {
        for j in 0...100 {
            program[1] = i
            program[2] = j
            if IntCode(program: program).run() == 19690720 {
                return (first, (i * 100) + j)
            }
        }
    }

    fatalError()
}

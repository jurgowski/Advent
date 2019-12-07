//  Created by Krys Jurgowski on 12/1/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func day2a(_ input: String) -> Int {
    var program = input
        .components(separatedBy: ",")
        .compactMap { Int($0) }

    program[1] = 12
    program[2] = 2

    return IntCode(program: program).run()
}

//(368640 * a) + 152702 + b
func day2b(_ input: String) -> Int {
    var program = input
        .components(separatedBy: ",")
        .compactMap { Int($0) }

    for i in 0...100 {
        for j in 0...100 {
            program[1] = i
            program[2] = j
            if IntCode(program: program).run() == 19690720 {
                return (i * 100) + j
            }
        }
    }

    return 0
}

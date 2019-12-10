//  Created by Krys Jurgowski on 12/1/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func day5(_ input: String) -> (Int, Int) {
    let program = input
        .components(separatedBy: ",")
        .compactMap { Int($0) }

    let machine = IntCode(program: program).queueInput(1)
    let outputs = sequence(first: machine.run()) { _ in machine.terminated ? nil : machine.run() }
    return (Array(outputs).last ?? 0,
            IntCode(program: program).queueInput(5).run())
}

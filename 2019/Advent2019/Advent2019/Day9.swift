//  Created by Krys Jurgowski on 12/1/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func day9(_ input: String) -> (Int, Int) {
    let program = input
        .components(separatedBy: ",")
        .compactMap { Int($0) }

    return (IntCode(program: program).queueInput(1).run(),
            IntCode(program: program).queueInput(2).run())
}

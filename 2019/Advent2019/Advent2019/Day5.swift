//  Created by Krys Jurgowski on 12/1/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func day5a(_ input: String) -> Int {
    let program = input
        .components(separatedBy: ",")
        .compactMap { Int($0) }

    return intcode(program, 1)
}

func day5b(_ input: String) -> Int {
    let program = input
        .components(separatedBy: ",")
        .compactMap { Int($0) }

    return intcode(program, 5)
}

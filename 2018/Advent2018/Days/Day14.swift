//  Created by Krys Jurgowski on 12/2/18.
//  Copyright © 2018 United States. All rights reserved.

import Foundation

func day14a(_ input: String) -> String {
    let times = Int(input)!
    var recipes = [3,7]
    var elves = (0, 1)

    while recipes.count < times + 10 {
        let sum = recipes[elves.0] + recipes[elves.1]
        if sum >= 10 {
            recipes.append(1)
        }
        recipes.append(sum % 10)
        elves.0 = (elves.0 + recipes[elves.0] + 1) % recipes.count
        elves.1 = (elves.1 + recipes[elves.1] + 1) % recipes.count
    }

    return recipes[times..<times+10].map { String($0) }.joined()
}

func day14b(_ input: String) -> String {
    var recipes = [3,7]
    var elves = (0, 1)

    var candidate = recipes.suffix(input.count + 1).map() { String($0) }.joined()
    while !candidate.contains(input) {
        let sum = recipes[elves.0] + recipes[elves.1]
        if sum >= 10 {
            recipes.append(1)
        }
        recipes.append(sum % 10)
        elves.0 = (elves.0 + recipes[elves.0] + 1) % recipes.count
        elves.1 = (elves.1 + recipes[elves.1] + 1) % recipes.count
        candidate = recipes.suffix(input.count + 1).map() { String($0) }.joined()
    }
    return String(recipes.count - input.count + (candidate.prefix(input.count) == input ? -1 : 0))
}

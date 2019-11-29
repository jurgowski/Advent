//  Created by Krys Jurgowski on 12/2/18.
//  Copyright © 2018 United States. All rights reserved.

import Foundation

func day12a(_ input: String) -> String {
    let rows = input.components(separatedBy: CharacterSet.newlines)
    let state = rows.first?.components(separatedBy: ": ")[1]
    let ruleStrings = rows.dropFirst(2)
    var rules = [Rule: Bool]()
    for ruleString in ruleStrings {
        let rulePart = ruleString.components(separatedBy: " => ")
        rules[Rule(input: rulePart[0])] = rulePart[1] == "#"
    }

    var currentPot = Pot(id: -1)
    for char in state! {
        let newPot = Pot(id: currentPot.id + 1)
        currentPot.right = newPot
        newPot.left = currentPot
        switch char {
        case "#": newPot.flower = true
        case ".": newPot.flower = false
        default: fatalError()
        }
        currentPot = newPot
    }

    var currentSum = currentPot.leftMost().sumAllRight()
    for i in 0..<10000 {
        var previousPot = currentPot.leftMost()
        currentPot = previousPot.nextGenPot(rules: rules)
        while let previousRightPot = previousPot.nextRight() {
            let nextGenRight = previousRightPot.nextGenPot(rules: rules)
            currentPot.right = nextGenRight
            nextGenRight.left = currentPot
            currentPot = nextGenRight
            previousPot = previousPot.right!
        }
        print(currentPot.leftMost().sumAllRight() - currentSum)
        currentSum = currentPot.leftMost().sumAllRight()
        print(i)
        print("\(i) -  \(currentSum)")
    }

    return "\(currentPot.leftMost().sumAllRight())"
}

func day12b(_ input: String) -> String {
    return ""
}

class Pot {
    let id: Int
    var left: Pot?
    var right: Pot?
    var flower: Bool = false

    init(id: Int) {
        self.id = id
    }

    func nextRight() -> Pot? {
        guard self.right == nil else {
            return self.right
        }
        if emptyLefts() < 5 {
            let rightPot = Pot(id: self.id + 1)
            rightPot.left = self
            self.right = rightPot
            return rightPot
        }
        return nil
    }

    func leftMost() -> Pot {
        var pot = self
        while pot.left != nil {
            pot = pot.left!
        }
        while pot.emptyRights() < 5 {
            let leftPot = Pot(id: pot.id - 1)
            pot.left = leftPot
            leftPot.right = pot
            pot = leftPot
        }
        return pot
    }

    func emptyLefts() -> Int {
        var lefts = 0
        var pot = self
        while pot.left != nil && !(pot.left!).flower {
            pot = pot.left!
            lefts += 1
        }
        return lefts
    }

    func emptyRights() -> Int {
        var rights = 0
        var pot = self
        while pot.right != nil && !(pot.right!).flower {
            pot = pot.right!
            rights += 1
        }
        return rights
    }

    func nextGenPot(rules: [Rule: Bool]) -> Pot {
        let pot = Pot(id: self.id)
        let rule = Rule(self.left?.left?.flower ?? false,
                        self.left?.flower ?? false,
                        self.flower,
                        self.right?.flower ?? false,
                        self.right?.right?.flower ?? false)
        pot.flower = rules[rule] ?? false
        return pot
    }

    func sumAllRight() -> Int {
        var pot = self
        var sum = 0
        while let current = pot.right {
            if current.flower {
                sum += current.id
            }
            pot = current
        }
        return sum
    }

    func printAllRight() -> String {
        var out = String()
        var pot = self
        while let current = pot.right {
            out.append(current.flower ? "#" : ".")
            pot = current
        }
        return out
    }
}

struct Rule: Hashable {
    let LL: Bool
    let L: Bool
    let C: Bool
    let R: Bool
    let RR: Bool

    init(input: String) {
        var code = input
        LL = code.removeFirst() == "#"
        L  = code.removeFirst() == "#"
        C  = code.removeFirst() == "#"
        R  = code.removeFirst() == "#"
        RR = code.removeFirst() == "#"
    }

    init(_ a: Bool, _ b: Bool, _ c: Bool, _ d: Bool, _ e: Bool) {
        LL = a
        L  = b
        C  = c
        R  = d
        RR = e
    }
}

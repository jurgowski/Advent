//  Created by Krys Jurgowski on 12/14/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

struct Group: Hashable {
    let num: Int
    let name: String
    init(_ text: String) {
        let ins = text.components(separatedBy: " ")
        name = ins[1]
        num = Int(ins[0])!
    }
    init(name: String, num: Int) {
        self.name = name
        self.num = num
    }
}

class Node {
    let name: String
    var parents = Set<String>()

    init(name: String) {
        self.name = name
    }
}

func day14(_ input: String) -> (Int, Int) {

    let formulas = input.components(separatedBy: CharacterSet.newlines)

    var nodes = [String: Node]()
    var converts = [Group: [Group]]()
    for formula in formulas {
        let sides = formula.components(separatedBy: " => ")
        let parent = Group(sides[1])
        let children = sides[0].components(separatedBy: ", ").map { Group($0) }
        converts[parent] = children
        let parentNode = nodes[parent.name] ?? Node(name: parent.name)
        nodes[parent.name] = parentNode
        for childName in children.map({ $0.name }) {
            let childNode = nodes[childName] ?? Node(name: childName)
            nodes[childName] = childNode
            childNode.parents.insert(parent.name)
        }
    }

    var low = 1
    var high = 10000000

    while high - low > 1 {
        let mid = ((high - low) / 2) + low
        let neededOre = _oreTotal(mid, converts: converts, nodes: nodes)
        if neededOre > 1000000000000 {
            high = mid
        } else {
            low = mid
        }
    }

    return (_oreTotal(1, converts: converts, nodes: nodes), low)
}

private func _oreTotal(_ fuel: Int, converts: [Group: [Group]], nodes: [String: Node]) -> Int {
    var bag = ["FUEL": fuel]
    while bag["ORE"] == nil || bag.count > 1 {
        var updatedBag = [String: Int]()
        for (chem, count) in bag {
            if (chem == "ORE") {
                updatedBag[chem] = (updatedBag[chem] ?? 0) + count
                continue
            }
            let output = converts.keys.first { $0.name == chem }!
            let inputs = converts[output] ?? []
            if count >= output.num {
                let mult = count / output.num
                for input in inputs {
                    updatedBag[input.name] = (updatedBag[input.name] ?? 0) + (input.num * mult)
                }
                let remaining = count - (output.num * mult)
                if remaining > 0 {
                    updatedBag[chem] = (updatedBag[chem] ?? 0) + remaining
                }
            } else {
                updatedBag[chem] = (updatedBag[chem] ?? 0) + count
            }
        }
        if bag == updatedBag {
            var keysLeft = Set(bag.keys)
            for chem in bag.keys {
                if _hasAny(nodes: nodes, name: chem, check: Set(bag.keys)) {
                    keysLeft.remove(chem)
                }
            }
            let key = keysLeft.first ?? bag.keys.first(where: { $0 != "ORE" })!
            updatedBag[key] = updatedBag[key]! + 1
        }
        bag = updatedBag
    }
    return bag["ORE"]!
}

private func _hasAny(nodes: [String: Node], name: String, check: Set<String>) -> Bool {
    var names = [name]
    while !names.isEmpty {
        let current = names.removeFirst()
        let parents = nodes[current]?.parents ?? []
        for parent in parents {
            if check.contains(parent) {
                return true
            }
        }
        names.append(contentsOf: parents)
    }
    return false
}

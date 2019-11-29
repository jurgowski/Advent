//  Created by Krys Jurgowski on 12/2/18.
//  Copyright © 2018 United States. All rights reserved.

import Foundation

func day8a(_ input: String) -> String {
    let numbers = input.components(separatedBy: CharacterSet.whitespaces).map() { Int($0)! }
    var iterator = numbers.makeIterator()
    let node = makeNode(&iterator)
    return "\(sum(node))"
}



func day8b(_ input: String) -> String {
    let numbers = input.components(separatedBy: CharacterSet.whitespaces).map() { Int($0)! }
    var iterator = numbers.makeIterator()
    let node = makeNode(&iterator)
    return "\(valueSum(node))"
}

fileprivate func makeNode(_ iterator: inout IndexingIterator<[Int]>) -> Node {
    let node = Node()
    let subnodeCount = iterator.next()!
    let metadataCount = iterator.next()!
    for _ in 0..<subnodeCount {
        let subnode = makeNode(&iterator)
        node.subnodes.append(subnode)
    }
    for _ in 0..<metadataCount {
        node.entries.append(iterator.next()!)
    }
    return node
}

fileprivate func sum(_ node: Node) -> Int {
    return node.entries.reduce(0, +) + node.subnodes.reduce(0) { $0 + sum($1) }
}

fileprivate func valueSum(_ node: Node) -> Int {
    if node.subnodes.isEmpty {
        return node.entries.reduce(0, +)
    }
    return node.entries.reduce(0) { $0 + (($1-1) < node.subnodes.count ? valueSum(node.subnodes[($1-1)]) : 0) }
}

fileprivate class Node {
    var subnodes: [Node] = []
    var entries: [Int] = []
}

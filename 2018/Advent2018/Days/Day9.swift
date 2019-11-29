//  Created by Krys Jurgowski on 12/2/18.
//  Copyright © 2018 United States. All rights reserved.

import Foundation

func day9a(_ input: String) -> String {
    let sentence = input.components(separatedBy: CharacterSet.whitespaces)
    var players = Array(repeating: 0, count: Int(sentence[0])!)
    let marbles = Int(sentence[6])!

    var currentMarbleIndex = 0
    var board = [0]
    var currentPlayer = 0
    for nextMarble in 1...marbles {
        if nextMarble % 23 == 0 {
            players[currentPlayer] += nextMarble
            currentMarbleIndex = (currentMarbleIndex - 7) % board.count
            currentMarbleIndex = currentMarbleIndex < 0 ? currentMarbleIndex + board.count : currentMarbleIndex
            players[currentPlayer] += board[currentMarbleIndex]
            board.remove(at: currentMarbleIndex)
        } else {
            currentMarbleIndex = (currentMarbleIndex + 2) % board.count
            currentMarbleIndex = currentMarbleIndex == 0 ? board.count : currentMarbleIndex
            board.insert(nextMarble, at: currentMarbleIndex)
        }
        currentPlayer = (currentPlayer + 1) % players.count
    }
    return "\(players.max()!)"
}

func day9b(_ input: String) -> String {
    let sentence = input.components(separatedBy: CharacterSet.whitespaces)
    var players = Array(repeating: 0, count: Int(sentence[0])!)
    let marbles = Int(sentence[6])! * 100

    var currentNode = Node(0)
    currentNode.next = currentNode
    currentNode.prev = currentNode
    var currentPlayer = 0
    for nextMarble in 1...marbles {
        if nextMarble % 23 == 0 {
            for _ in 0..<7 {
                currentNode = currentNode.prev
            }
            players[currentPlayer] += nextMarble + currentNode.remove()
            currentNode = currentNode.next
        } else {
            currentNode = currentNode.next
            currentNode.insertAfter(nextMarble)
            currentNode = currentNode.next
        }
        //currentNode.printme()
        currentPlayer = (currentPlayer + 1) % players.count
    }
    return "\(players.max()!)"
}

fileprivate class Node {
    var next: Node!
    var prev: Node!
    let value: Int

    init(_ i: Int) {
        value = i
    }

    func insertAfter(_ index: Int) {
        let node = Node(index)
        let next = self.next!
        self.next = node
        next.prev = node
        node.prev = self
        node.next = next
    }

    func remove() -> Int {
        self.prev.next = self.next
        self.next.prev = self.prev
        return value
    }

    func printme() {
        var next = self.next
        while next!.value != self.value {
            print(next!.value, terminator: " ")
            next = next!.next
        }
        print()
    }
}

import Foundation

public class Node: Hashable {
  public let id: Int
  public var prev: Node!
  public var next: Node!


  public var hashValue: Int { return id.hashValue }
  public static func ==(lhs: Node, rhs: Node) -> Bool { return lhs.id == rhs.id }

  init(id: Int) {
    self.id = id
    self.next = self
    self.prev = self
  }

  private func setNext(node: Node) {
    self.next = node
    node.prev = self
  }

  public func forward(steps: Int) -> Node {
    var currentNode = self
    for _ in 0..<steps {
      currentNode = currentNode.next
    }
    return currentNode
  }

  public func insertAfter(node: Node) -> Node {
    let nextNode = self.next!
    self.setNext(node: node)
    node.setNext(node: nextNode)
    return node
  }

  public func order() -> [Int] {
    var currentNode = self
    var ints = [currentNode.id]
    while (currentNode.next != self) {
      currentNode = currentNode.next
      ints.append(currentNode.id)
    }
    return ints
  }
}

public func spinlock(steps: Int, moves: Int) -> Int {
  var current = 0
  var node = Node(id: current)

  while (current < moves) {
    node = node.forward(steps: steps)
    current += 1
    node = node.insertAfter(node: Node(id:current))
  }
  return node.next.id
}

public func longSpinlock(steps: Int, moves: Int) -> Int {
  var current = 0
  var currentPosition = 0
  var numAtFirstPosition = 0
  while (current < moves) {
    current += 1
    currentPosition = ((currentPosition + steps) % (current) + 1)
    if (currentPosition == 1) {
      numAtFirstPosition = current
    }
  }
  return numAtFirstPosition
}

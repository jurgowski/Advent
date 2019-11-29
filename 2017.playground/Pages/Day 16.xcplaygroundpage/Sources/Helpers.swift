import Foundation


public class Node: Hashable {
  public let id: Character
  public var prev: Node?
  public var next: Node?


  public var hashValue: Int { return id.hashValue }
  public static func ==(lhs: Node, rhs: Node) -> Bool { return lhs.id == rhs.id }

  init(id: Character) {
    self.id = id
  }

  private func setNext(node: Node) {
    self.next = node
    node.prev = self
  }

  public static func makeGroup(length: Character) -> [Character: Node] {
    var currentCharacter: Character = "a"
    let headNode = Node(id: currentCharacter)
    var nodeMap = [headNode.id: headNode]
    var currentNode = headNode
    while (currentCharacter != length) {
      currentCharacter = Character(Unicode.Scalar(currentCharacter.unicodeScalars.first!.value + 1)!)
      let node = Node(id: currentCharacter)
      nodeMap[currentCharacter] = node
      currentNode.setNext(node: node)
      currentNode = node
    }
    currentNode.next = headNode
    headNode.prev = currentNode

    return nodeMap
  }

  public func rotate(steps: Int) -> Node {
    var currentNode = self
    for _ in 0..<steps {
      currentNode = currentNode.prev!
    }
    return currentNode
  }

  public func swap(offsetA: Int, offsetB: Int) -> Node {
    var nodeA: Node? = nil
    var nodeB: Node? = nil
    var currentOffset = 0
    var currentNode = self
    while (nodeA == nil || nodeB == nil) {
      if offsetA == currentOffset {
        nodeA = currentNode
      }
      if offsetB == currentOffset {
        nodeB = currentNode
      }
      currentOffset += 1
      currentNode = currentNode.next!
    }
    return exchange(nodeA: nodeA!, nodeB: nodeB!)
  }

  public func exchange(nodeA: Node, nodeB: Node) -> Node {

    let prevA = nodeA.prev!
    let prevB = nodeB.prev!
    prevA.setNext(node: nodeB)
    prevB.setNext(node: nodeA)
    let nextA = nodeA.next!
    let nextB = nodeB.next!
    nodeA.setNext(node: nextB)
    nodeB.setNext(node: nextA)

    if (self == nodeA) { return nodeB }
    if (self == nodeB) { return nodeA }
    return self
  }

  public func name() -> String {
    var currentNode = self
    var chars = [currentNode.id]
    while (currentNode.next != self) {
      currentNode = currentNode.next!
      chars.append(currentNode.id)
    }
    return String(chars)
  }
}

public enum Step {
  case Spin(Int)
  case Exchange(Int, Int)
  case Swap(Character, Character)
}

public func dance(input: String, times: Int) -> String {
  let nodeMap = Node.makeGroup(length: "p")
  var headNode = nodeMap["a"]!

  let steps = input.components(separatedBy: ",").map { (instruction) -> Step in
    switch instruction.first! {
    case "s": return Step.Spin(Int(instruction.dropFirst())!)
    case "x":
      let offsets = instruction.dropFirst().components(separatedBy: "/")
      return Step.Exchange(Int(offsets[0])!, Int(offsets[1])!)
    case "p":
      let nodes = instruction.dropFirst().components(separatedBy: "/")
      return Step.Swap(nodes[0].first!, nodes[1].first!)
    default:
      fatalError()
    }
  }

  var positions:[String] = []
  var nodeSet:Set<String> = Set()

  repeat {
    nodeSet.insert(headNode.name())
    positions.append(headNode.name())
    headNode = steps.reduce(headNode) { (currentHead, step) -> Node in
      switch step {
      case .Spin(let steps):
        return currentHead.rotate(steps: steps)
      case .Exchange(let first, let second):
        return currentHead.swap(offsetA: first, offsetB: second)
      case .Swap(let first, let second):
        return currentHead.exchange(nodeA: nodeMap[first]!, nodeB: nodeMap[second]!)
      }
    }
  } while !nodeSet.contains(headNode.name())

  return positions[times % positions.count]
}

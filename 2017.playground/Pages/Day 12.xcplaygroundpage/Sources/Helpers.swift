import Foundation

public class Node: Hashable {
  public let id: Int
  public var links: Set<Node> = Set()


  public var hashValue: Int { return id.hashValue }
  public static func ==(lhs: Node, rhs: Node) -> Bool { return lhs.id == rhs.id }

  init(id: Int) {
    self.id = id
  }
}

func parseNodes(input: String) -> [Int: Node] {
  var nodeMap: [Int: Node] = [:]
  let nodeLines = input.components(separatedBy: CharacterSet.newlines)
  for nodeLine in nodeLines {
    let nodeComponents = nodeLine.components(separatedBy: " <-> ")
    let nodeId = Int(nodeComponents[0])!
    let node = nodeMap[nodeId] ?? Node(id: nodeId)
    nodeMap[nodeId] = node
    node.links = Set(nodeComponents[1].components(separatedBy: ", ").map({ (childNodeString) -> Node in
      let childNodeId = Int(childNodeString)!
      let node = nodeMap[childNodeId] ?? Node(id: childNodeId)
      nodeMap[childNodeId] = node
      return node
    }))
  }
  return nodeMap
}

public func minimumTree(input: String) -> (Int, Int) {
  var nodeMap = parseNodes(input: input)
  var groups = 0
  var zeroGroupCount = 0
  var nodeIds = Set(nodeMap.keys)

  while(!nodeIds.isEmpty) {
    let nodeId = nodeIds.removeFirst()
    let topNode = nodeMap[nodeId]!
    var nodeSet: Set<Node> = Set()
    nodeSet.insert(topNode)
    var nodeQueue = Set(topNode.links)
    while (!nodeQueue.isEmpty) {
      let node = nodeQueue.removeFirst()
      nodeIds.remove(node.id)
      nodeSet.insert(node)
      let uncheckedNodes = node.links.subtracting(nodeSet)
      nodeQueue.formUnion(uncheckedNodes)
    }
    groups += 1
    if nodeSet.contains(nodeMap[0]!) {
      zeroGroupCount = nodeSet.count
    }
  }


  return (zeroGroupCount, groups)
}

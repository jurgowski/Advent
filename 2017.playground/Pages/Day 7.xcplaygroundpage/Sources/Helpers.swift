import Foundation

public class Node: Hashable {
  public let name: String
  public var weight: Int = 0
  public var totalWeight: Int = 0
  public var children: [Node] = []
  public var parent: Node?


  public var hashValue: Int { return name.hashValue }
  public static func ==(lhs: Node, rhs: Node) -> Bool { return lhs.name == rhs.name }

  init(name: String) {
    self.name = name
  }
}

func fetchNode(nodeMap: inout [String: Node], name: String) -> Node {
  if let node = nodeMap[name] {
    return node
  } else {
    let node = Node(name: name)
    nodeMap[name] = node
    return node
  }
}

public func totalWeights(node:Node) -> Int {
  var totalWeight = node.weight
  for childNode in node.children {
    childNode.totalWeight = totalWeights(node: childNode)
    totalWeight += childNode.totalWeight
  }

  return totalWeight
}

func parseNodeRows(nodeRows: [String]) -> Node {
  var nodeMap: [String: Node] = [:]
  for nodeRow in nodeRows {
    let nodeDetails = nodeRow.components(separatedBy: "->")
    let nodeHeader = nodeDetails[0].trimmingCharacters(in: CharacterSet.whitespaces).components(separatedBy: " ")
    let nodeName = nodeHeader[0]

    let node = fetchNode(nodeMap: &nodeMap, name: nodeName)
    node.weight = Int(nodeHeader[1].trimmingCharacters(in: CharacterSet.punctuationCharacters))!

    if (nodeDetails.count > 1) {
      let childNames = nodeDetails[1].trimmingCharacters(in: CharacterSet.whitespaces).components(separatedBy: ", ")

      node.children = childNames.map({ (childName) -> Node in
        let childNode = fetchNode(nodeMap: &nodeMap, name: childName)
        childNode.parent = node
        return childNode
      })
    }
  }

  var rootNode = nodeMap.first!.value
  while let parent = rootNode.parent {
    rootNode = parent
  }

  rootNode.totalWeight = totalWeights(node: rootNode)

  return rootNode
}

public func findRoot(input: String) -> Node {
  let nodeRows = input.components(separatedBy: CharacterSet.newlines)
  let rootNode = parseNodeRows(nodeRows: nodeRows)
  return rootNode
}

func traverseImbalancedPath(node:Node, difference: Int) -> Node {
  //print("\(node.name) - \(node.totalWeight)")
  //print(node.children.map { "\($0.name) - \($0.totalWeight)" })

  if (Set(node.children.map {$0.totalWeight}).count == 1) {
    return node
  }

  let weights = node.children.map { return $0.totalWeight }
  let inbalancedWeight = difference > 0 ? weights.max()! : weights.min()!
  let imbalancedPath = node.children[weights.index(of: inbalancedWeight)!]

  return traverseImbalancedPath(node: imbalancedPath, difference: difference)
}

public func findImbalancedNode(node:Node) -> Int {

  let weights = node.children.map { return $0.totalWeight }
  let sortedWeights = weights.sorted()
  let inbalancedWeight = sortedWeights[0] == sortedWeights[1] ? sortedWeights.last! : sortedWeights.first!
  let expectedWeight   = sortedWeights[0] != sortedWeights[1] ? sortedWeights.last! : sortedWeights.first!
  let weightDifference = inbalancedWeight - expectedWeight

  let imbalancedPath = node.children[weights.index(of: inbalancedWeight)!]
  let imbalancedNode = traverseImbalancedPath(node: imbalancedPath, difference: weightDifference)

  return imbalancedNode.weight - weightDifference
}


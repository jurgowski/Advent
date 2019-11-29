import Foundation

struct Node {
    let x: Int
    let y: Int
    let size: Int
    let used: Int
    let avail: Int
}

func viablePairs(_ input: String) -> Int {
    let nodes = getNodes(input)
    let availNodes = nodes.sorted { (lhs, rhs) -> Bool in
        return lhs.avail < rhs.avail
    }
    let usedNodes = nodes.sorted { (lhs, rhs) -> Bool in
        return lhs.used < rhs.used
        }.filter { return $0.used > 0 }
    var pairs = 0
    var usedIndex = 0
    for availNode in availNodes {
        while (usedNodes[usedIndex].used < availNode.avail) {
            usedIndex += 1
        }
        pairs += usedIndex
    }
    for node in nodes {
        if node.size > 250 {
            print(node)
        }
    }
    return pairs
}

func getNodes(_ input: String) -> [Node] {
    let nodeDatas = input.components(separatedBy: CharacterSet.newlines).suffix(from: 2)
    return nodeDatas.map { (data) -> Node in
        let nodeData = data.components(separatedBy: CharacterSet.whitespaces).filter({ return !$0.isEmpty })
        let fileParts = nodeData[0].components(separatedBy: "-")
        return Node(x: Int(fileParts[1].trimmingCharacters(in: CharacterSet.letters))!,
                    y: Int(fileParts[2].trimmingCharacters(in: CharacterSet.letters))!,
                    size: Int(nodeData[1].trimmingCharacters(in: CharacterSet.letters))!,
                    used: Int(nodeData[2].trimmingCharacters(in: CharacterSet.letters))!,
                    avail: Int(nodeData[3].trimmingCharacters(in: CharacterSet.letters))!)
    }
}

struct State: Hashable {
    let openSpot: (Int, Int)
    let payload: (Int, Int)
    
    static func ==(lhs: State, rhs: State) -> Bool {
        return lhs.openSpot == rhs.openSpot && lhs.payload == rhs.payload
    }
    
    var hashValue: Int {
        get {
            return
                openSpot.0 << 0 ^
                    openSpot.1 << 4 ^
                    payload.0 << 8 ^
                    payload.1 << 12
        }
    }
}

struct Grid {
    let x: Int
    let y: Int
    let blockedMap: [Int: Set<Int>]
    
    init(x: Int, y: Int, blockedSpots:[(Int, Int)]) {
        self.x = x
        self.y = y
        var map = [Int: Set<Int>]()
        for blockedSpot in blockedSpots {
            var set = map[blockedSpot.0] ?? Set<Int>()
            set.insert(blockedSpot.1)
            map[blockedSpot.0] = set
        }
        blockedMap = map
    }
    
    func nextStates(_ state: State) -> [State] {
        let nextCoordinates: [(Int, Int)] =
            [(state.openSpot.0 - 1, state.openSpot.1    ),
             (state.openSpot.0 + 1, state.openSpot.1    ),
             (state.openSpot.0    , state.openSpot.1 + 1),
             (state.openSpot.0    , state.openSpot.1 - 1)]
                .filter({ coordinate in
                    return !isBlocked(x: coordinate.0, y: coordinate.1) &&
                        coordinate.0 >= 0 &&
                        coordinate.0 <= x &&
                        coordinate.1 >= 0 &&
                        coordinate.1 <= y
                })
        return nextCoordinates.map({(x, y) in
            let payload: (Int, Int) = (x == state.payload.0 && y == state.payload.1) ? state.openSpot : state.payload
            return State(openSpot: (x,y),
                         payload: payload) })
    }
    
    func isBlocked(x: Int, y: Int) -> Bool {
        //print("x: \(x) y: \(y) isBlocked: \((blockedMap[x] ?? Set()).contains(y))")
        return (blockedMap[x] ?? Set()).contains(y)
    }
}


public func shortestPath(_ input: String, target:(Int, Int)) -> Int {
    let nodes = getNodes(input)
    let maxX = nodes.reduce(0, { return max($0, $1.x)})
    let maxY = nodes.reduce(0, { return max($0, $1.y)})
    let payload = (maxX, 0)
    let grid = Grid(x: maxX,
                    y: maxY,
                    blockedSpots: nodes.filter({ $0.used > 250 }).map({ return ($0.x, $0.y)}))
    let initialState = State(openSpot: nodes.reduce((-1, -1), { return $1.used == 0 ? ($1.x, $1.y) : $0}),
                             payload: payload)
    var paths = [initialState: 0]
    var currentPath = 0
    var finalPath = 0
    var stateQueue = [initialState]
    while !stateQueue.isEmpty && finalPath == 0 {
        let state = stateQueue.removeFirst()
        stateQueue.append(contentsOf:grid.nextStates(state).filter({
            (nextState) in
            guard paths[nextState] == nil else {
                return false
            }
            let path = paths[state]! + 1
            if nextState.payload == target {
                finalPath = path
            }
            paths[nextState] = path
            if currentPath < path {
                currentPath = path
                print("Path: \(path)")
            }
            return true
        }))
    }
    return finalPath
}

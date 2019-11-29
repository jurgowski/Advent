import Foundation

struct State: Hashable {
    let x: Int
    let y: Int
    let points: Set<Int>
    
    static func ==(lhs: State, rhs: State) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.points == rhs.points
    }
    
    var hashValue: Int { get { return points.hashValue ^ (x << 12) ^ (y << 24) }}
}

enum Spot {
    case wall
    case empty
    case point(Int)
}

public func shortestPath(_ input: String) -> Int {
    
    let rows = input.components(separatedBy: CharacterSet.newlines)
    var totalPoints = 0
    let grid: [[Spot]] = rows.map { (row) -> [Spot] in
        row.characters.map({ (char) -> Spot in
            switch char {
            case "#": return Spot.wall
            case ".": return Spot.empty
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                totalPoints += 1
                return Spot.point(Int(String(char))!)
            default: abort()
            }
        })
    }
    
    let initialState = getInitialState(grid)
    var paths = [initialState : 0]
    var stateQueue = [initialState]
    while !stateQueue.isEmpty {
        let nextState = stateQueue.removeFirst()
        let states = nextStates(grid, state: nextState).filter({
            paths[$0] == nil
        })
        for state in states {
            paths[state] = paths[nextState]! + 1
            if state.points.count == totalPoints && state.x == initialState.x && state.y == initialState.y {
                return paths[state]!
            }
        }
        stateQueue.append(contentsOf: states)
    }
    return 0
}

func getInitialState(_ grid: [[Spot]]) -> State {
    for y in 0..<grid.count {
        for x in 0..<grid[y].count {
            if case .point(let p) = grid[y][x] {
                if p == 0 {
                    return State(x: x, y: y, points: [0])
                }
            }
        }
    }
    abort()
}

func nextStates(_ grid: [[Spot]], state: State) -> [State] {
    return
        [(state.x - 1, state.y),
         (state.x + 1, state.y),
         (state.x, state.y - 1),
         (state.x, state.y + 1)].filter({
            (x, y) -> Bool in
            switch grid[y][x] {
            case .wall: return false
            default:    return true
            }
         }).map({
            (x, y) -> State in
            var points = state.points
            switch grid[y][x] {
            case .point(let p):
                points.insert(p)
            default: break
            }
            return State(x: x, y: y, points: points)
         })
}

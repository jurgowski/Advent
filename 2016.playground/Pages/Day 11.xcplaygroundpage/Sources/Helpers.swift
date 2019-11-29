import Foundation

let floors = 1...4
public typealias Floor = Int
public typealias StateInt = Int

public struct State {
    let generators: [Floor]
    let microchips: [Floor]
    let elevator: Floor
    
    public init(generators:[Floor], microchips:[Floor], elevator:Floor) {
        self.generators = generators
        self.microchips = microchips
        self.elevator = elevator
    }
    
    var stateInt: StateInt {
        get {
            return getStateInt(generators: generators, microchips: microchips, elevator: elevator)
        }
    }
}

func getStateInt(generators:[Floor], microchips:[Floor], elevator:Floor) -> StateInt {
    var mult = 1
    var stateInt: StateInt = elevator
    for floor in generators {
        mult *= 10
        stateInt += mult * floor
    }
    for floor in microchips {
        mult *= 10
        stateInt += mult * floor
    }
    return stateInt
}

enum Component {
    case generator(Int)
    case microchip(Int)
}

public func shortestPath(_ fromState:State, toState:State) -> Int {
    var distances: [StateInt: Int] = [fromState.stateInt: 0]
    var stateQueue = [fromState]
    var currentDistance = 0
    while !stateQueue.isEmpty {
        let currentState = stateQueue.removeFirst()
        if distances[currentState.stateInt]! > currentDistance {
            currentDistance = distances[currentState.stateInt]!
            print(currentDistance)
        }
        let nextStates = allNextValidStates(currentState).filter({
            return distances[$0.stateInt] == nil
        })
        for nextState in nextStates {
            distances[nextState.stateInt] = distances[currentState.stateInt]! + 1
            if (nextState.stateInt == toState.stateInt) {
                return distances[nextState.stateInt]!
            }
            stateQueue.append(nextState)
        }
    }
    return -1
}

func isStateValid(microchips: [Floor], generators: [Floor]) -> Bool {
    for (type, floor) in microchips.enumerated() {
        if generators[type] == floor { continue }
        if generators.contains(floor) { return false }
    }
    return true
}

func allNextValidStates(_ state: State) -> [State] {
    var nextStates = [State]()
    let components = movableComponents(state)
    
    for floor in validNextFloors(state.elevator) {
        nextStates.append(contentsOf:validStates(withComponents: components, floor: floor, state: state))
    }
    return nextStates
}

func movableComponents(_ state: State) -> [Component] {
    var components: [Component] = []
    for (type, floor) in state.generators.enumerated() {
        if state.elevator == floor { components.append(.generator(type))}
    }
    for (type, floor) in state.microchips.enumerated() {
        if state.elevator == floor { components.append(.microchip(type))}
    }
    return components
}

func validNextFloors(_ floor: Floor) -> [Floor] {
    return floors.filter({
        $0 == floor - 1 || $0 == floor + 1
    })
}

func validStates(withComponents components: [Component], floor:Int, state:State) -> [State] {
    var nextStates = [State]()
    for i in 0..<components.count {
        for j in i..<components.count {
            var generators = state.generators
            var microchips = state.microchips
            switch components[i] {
            case .generator(let type): generators[type] = floor
            case .microchip(let type): microchips[type] = floor
            }
            if (i != j) {
                switch components[j] {
                case .generator(let type): generators[type] = floor
                case .microchip(let type): microchips[type] = floor
                }
            }
            if isStateValid(microchips: microchips, generators: generators) {
                nextStates.append(State(generators: generators, microchips: microchips, elevator: floor))
            }
        }
    }
    return nextStates
}

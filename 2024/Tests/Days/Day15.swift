import Testing
import Advent2024

private func emptySpace(map: [[Character]], robotPos: Pos, dir: Dir) -> Pos? {
    var candidate = robotPos
    assert(map[robotPos] == "@")
    while map[candidate] != "." {
        candidate = candidate[dir]
        guard candidate.inside(map: map) else { fatalError() }
        guard map[candidate] != "#" else { return nil }
    }
    return candidate
}

private func part1(input: String) -> Int {
    let manifest = input
        .split(separator: "\n\n")
    
    var map: [[Character]] = manifest[0]
        .split(separator: "\n")
        .map { Array($0) }
    
    let actions = manifest[1]
    
    var robotPos = Pos(-1, -1)
    for y in map.indices {
        for x in map[y].indices {
            if map[y][x] == "@" {
                robotPos = Pos(x, y)
            }
        }
    }
    print(robotPos)
    
    for action in actions {
        let dir: Dir
        switch action {
        case "v": dir = .sout
        case "^": dir = .nort
        case "<": dir = .west
        case ">": dir = .east
        case "\n": continue
        default: fatalError()
        }
        guard let candidate = emptySpace(map: map, robotPos: robotPos, dir: dir) else {
            continue
        }
        let nextRobotPos = robotPos[dir]
        map[candidate.y][candidate.x] = Character("O")
        map[robotPos.y][robotPos.x] = "."
        map[nextRobotPos.y][nextRobotPos.x] = "@"
        robotPos = nextRobotPos
    }
    
    print(String(map.joined(separator: "\n")))
    
    var total = 0
    for y in map.indices {
        for x in map[y].indices {
            if map[y][x] == "O" {
                total += x + y * 100
            }
        }
    }
    return total
}

private func part2(input: String) -> Int {
    let manifest = input
        .split(separator: "\n\n")
    
    var map: [[Character]] = manifest[0]
        .split(separator: "\n")
        .map {
            Array($0).flatMap {
                switch $0 {
                case "#": return "##"
                case "@": return "@."
                case ".": return ".."
                case "O": return "[]"
                default: fatalError()
                }
            }
        }
    
    print(String(map.joined(separator: "\n")))
    let actions = manifest[1]
    
    var robotPos = Pos(-1, -1)
    for y in map.indices {
        for x in map[y].indices {
            if map[y][x] == "@" {
                robotPos = Pos(x, y)
            }
        }
    }
    print(robotPos)
    
    for action in actions {
        let dir: Dir
        switch action {
        case "v": dir = .sout
        case "^": dir = .nort
        case "<": dir = .west
        case ">": dir = .east
        case "\n": continue
        default: fatalError()
        }
        if map[robotPos[dir]] == "#" {
            continue
        }
        if map[robotPos[dir]] == "." {
            map[robotPos.y][robotPos.x] = "."
            robotPos = robotPos[dir]
            map[robotPos.y][robotPos.x] = "@"
            continue
        }
        var hitWall = false
        var mapCopy = map
        var targetsLeft = [robotPos[dir]]
        var boxTargets: [Pos] = []
        while !targetsLeft.isEmpty {
            let nextTarget = targetsLeft.removeFirst()
            switch mapCopy[nextTarget] {
            case "[":
                mapCopy[nextTarget.y][nextTarget.x] = "."
                mapCopy[nextTarget.right.y][nextTarget.right.x] = "."
                boxTargets.append(nextTarget[dir])
                targetsLeft.append(nextTarget[dir])
                targetsLeft.append(nextTarget[dir].right)
            case "]":
                mapCopy[nextTarget.left.y][nextTarget.left.x] = "."
                mapCopy[nextTarget.y][nextTarget.x] = "."
                boxTargets.append(nextTarget.left[dir])
                targetsLeft.append(nextTarget[dir].left)
                targetsLeft.append(nextTarget[dir])
            case ".":
                continue
            case "#":
                hitWall = true
                break
            default: fatalError()
            }
        }
        if hitWall {
            continue
        }
        boxTargets.forEach {
            mapCopy[$0.y][$0.x] = "["
            mapCopy[$0.right.y][$0.right.x] = "]"
        }
        mapCopy[robotPos.y][robotPos.x] = "."
        robotPos = robotPos[dir]
        mapCopy[robotPos.y][robotPos.x] = "@"
        map = mapCopy
    }
    
    print(String(map.joined(separator: "\n")))
    
    var total = 0
    for y in map.indices {
        for x in map[y].indices {
            if map[y][x] == "[" {
                total += x + y * 100
            }
        }
    }
    return total
}

@Test func testDay15DebugPart1() async throws {
    #expect(part1(input: debugInput) == 10092)
}

@Test func testDay15Part1() throws {
    print(part1(input: input))
}

@Test func testDay15Part2() async throws {
    #expect(part2(input: debugInput) == 9021)
}

@Test func testDay15DebugPart2() async throws {
    print(part2(input: input))
}


private let debugInput = """
##########
#..O..O.O#
#......O.#
#.OO..O.O#
#..O@..O.#
#O#..O...#
#O..O..O.#
#.OO.O.OO#
#....O...#
##########

<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
>^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
"""


private let input = """
##################################################
#.........O#...O.OO.OO.O##OO..#..O#O.O.........O.#
##....#.#.O#.O..O...O.O...O....#.OO.O.O..#.O.....#
#.O.O..#...OO.....#OOO.......OO................O.#
#..O..#.O##...#.#.....O...O.O.....O..O.O......#.##
#.#..#.O...O...O...O.O........O..#O.O..#..#O....O#
#...O#..#..#.O.O.O..OO.O...#.....#O...#......#...#
##.O..O......OO....O..OO.#.O....##.O.....#..O..#.#
#O..#...O..O.........OOO.....OO....O......O...O..#
#.....O...O........O#.OO#.O.O....O..#.#.#O.#.O..##
#OO..#O.......O.O......O..O..O.O.O..........#O.O.#
#O..O.#........#...O...#O....OO.O..........#....O#
#O.#.O...O.O#......#......#....O..#.O..O#......O.#
#.O.OO..OO.......O....#..OO.O.........#O....OO...#
#O.....O.O..O....O.O..#..OOO..OO.O........OO..#..#
#...O.O......O...OO...##.....#.OO.....OOO#....O#O#
#O......O...OO.....O#O..O#..OO.#........#O#....O.#
#.#O......O....#.O.....O.O.#OO.#.O.O.#...#.....###
##..OO#..OO.O.OOOO.O...O.............O##.O...O..O#
#...#.....O........#.O.........OO.....O.O.OO.O.O.#
###O....O.....O......O.O.O#O......O...O....O.#...#
#..O...O#........O.O......#.#.O....O.O..O.O.O...##
#O#.O..O....O..O..O.#O.#OOOO.O....O...O..OO.O..#.#
#..O....OO.O...#O..O.O....OO.......#.........#...#
#O..OO....#O..#...#.....@..#...O...#.#.OO.OO.....#
#.O....O#OO.....OOO...#.O.#..O..OOOOO....O...OO..#
#....O.#.#....O.OOO.....OO..O.OO#O.#....OO....O#.#
#O....O......O..OO....OO.#..O.O......OOOO.OOOO.O.#
#O.O......OO......O.........O.O.O......O.OO..O.OO#
#.OO...OO..O....#O.....OO......OOO..#....O.#O...O#
#...O.....O..#....O#.O..OO...#....OOOO...OO..O.OO#
#....O.OO........O.#O.....#.O#.......#.O#..O.O.OO#
#......#..#...O..O..#.OOO...#..O...#.O.O..OOO.O.O#
#O#....#..#...O........O...#OO#O.#...O...O....O#O#
#.......O..O..OOOOO.##.....O..O.......#.O....OO..#
#....O...O#.OO..OO...OO.#........O##O.O.O.O.....##
#O..OO.OO..O.O#.O..O......O.......OO.O.......#.O.#
#..O..#O.O...................O...#...O..#.OO....##
#.....#.#..OO...OOOO.....OO...#..#........#..O..O#
#.O..O...O.O.#.O.#.OO..O..........O.O...#....#...#
#.OO#.O...OO..OOOO..OO...O.O.#.O...#O...#....#..O#
#.O....O#O...#O..........#O..O......O.OOO##O#.O.O#
#....##.O#.OO.O#...#...O..O...O.....#.#.O#OO.#..O#
#..#O......#O....OO.....#........O.OO#...O....O..#
#.O#..O#O..OO....O#..#....#OO.O#O....#.....OOOOO.#
#.#..OO.O.....#O.....O##............O.O...O......#
#.O...OOO.O.O...O#O.O............OO....#OO.O..#..#
#....#.##OO..#....O..O.....OO..O..........#O..OO.#
#.#...O...OOOO....O....O...O.O.....O....O.....#..#
##################################################

^^^>v>>>^><v><^v^><v<^^>>^v^v^<vv>>>vv>^<>v><^>v<^<^^<^v><^<<^v<<<><^<^vvv<<>^>^<>^><^>^<<>vvv^vvv<>v^<>v<^>>>>v^^>^<<v<v>^^>v>>>^<^>^v<><><<<>^^v><vvv^v<^<<>>^<>v^<v>v><v>^^v^><^^>^<v><v^<^>^<>vv>><>><v<^v>><^vv^^<v>^v>>^<v^>v<<^vvvvvv>^>v>^^<v>^<<<>>^^v^<><<^^^<>v^>^^<<><><v^^>>v>^<vv<^vv^><><<<^<<^<v>^>vvvv<v>>>v<>^<>vv<vv><<>><<<>v<^v<v>v<<vv<>^>v<v<><>v>^>^^<>^^<>v<^<><vvvv^>vv>v<v^<<^<^<^<^vv<^><v>>><<^^^<^>^<<^^>^v>v<v^>v<^^>>vv<^^^><^^><>>^<<<>v>^>v^vv>>v^^v^v^^>v>^vv<<><^<<>v<^<^^^vv>^^<^><<^vv><<<>v<>>><<<v<>vv>^>><>^^<<<^>^v^^<><vv^vv>^v<<<v<<^^^^>>^v^><^<v<<<>v^<^>^^><v>>^vv>v>v<^vv>>^v^>^><>v^^<<>vv<>v^^<<>>>^><^>>^v<^>^^>^<>>vv>>>v^^^vv<v<v>^<<<<^^>>><><^^>>vv<v><>^v>>><v<>>^>><>>v^><><^v^v<>><>vv^>v<>v<vv>vv^vv>>v>>^^>>v^v>>>v<v^v><^<vv<>>><<^v>^^<v>v>^><vv>><><vv><v<v>v^<>><v<v^^v^<<><>^^^><<^v^>>v^<<vvv><<^v<^<<v>><^<><^<<^>^^^^^vvvv<<^^<<^<>vvv>^^v^v<^<^<^v<>>^><>^<<>v<^>v>v^<<^<<^v^^^^>v<v>^<^>v>>>^^<^^v<>^>v>vv>v^<<<^<v<^v<>^^><>>v^>^v^<^><^^^^^^>>>v><<^>^vvvv<^vv^<
<>v><^^^v>v^>v^v>^^>vv^v^<vv<^><v>>v>v>vvv>>v><<^^vvv<v<<^><v<vv<v<><v^^^<vvv><<v><<<v^<^^>v^<v<><<><<^^<><^<v><v<^^>^vv^^^vv>^v<<<v<<^^v><v>v^<>>^>>>vv<^><<>><vvv>><<<>v<<>^>>>v>v<>^^^><><<><v>><<><v><<<>>^v<<^v>^><v^^v<<^v<>v><<v<^v><<^>^vvvvvv><<^^^<<v<>><^^vvv<>^>^vv<<v>v>vvv^v^><^vvvv>v>vv^><^<<<v>v^vv^<^>>><<<^>vv<^v^v<<<<>>>><v<^<^^^<<^v^<vv^v^<<v^>>v<>vv<^><<>^^v<<^^>vv^^^v<><<^^^>>vv<^vvvv^^v>v<v^<>vvvvvv^<v>^v^^^v<v^><^vv><^<vvv^<>v^<v<v><>vv>>^v^^vvv>^^vv>>>>^>^<<>^>^>^v<>>>^^^<v<><><>>>v^<<<<>>^<^>^^<vvvv<<^<^<v>><^<v>>>^>^>v>^^>>><<^<^^^^<<v>vv<v<><<^v<<v^<v>>^>^>^^<<><^<<v<>><<v<v>><<v<v<>>v><<<>^><vvvv>^<<v^^^^<^>v><>v>><<v<^v>^^<^>>v>vv>>^>v<^<v<^v^<<<vv<^v<v>^<<>^v^<<>v^v<^^<vv<><>^>>^<^<^>>>^v^^><vv<v<><^v<^>^v<v<v><>^v>v>>>v<<>^<<><>>>v^<v>v^vv>>><<<<>^<<>^>^v>v^^^^<^<v<^^><^<>v>>v<^v>^vv<v>>><vv>^<>^>^<<<^v^vv^^vv<^>^^v^<^><^^<^<^>^v<<>vv<v^<^^v^<v>>^>>>^v<^>v^v><<^>>^>>>>>>>>^v<<>vv^^>vvv^<>><^>vvv^^>v^<<<^<<^>vv^v<^><vv>^>^^<^^vv><^>^^v<><>v>><><<^><><^v^>v^^v>v^<
^^v<<v>^>>^<^v^v>vv>^>^>v>>vvv><<<>>><>>^v<<v>><vv><^<v><^<vv>>v>v<v>^>><^v><<v^<v>^v<^<^^^v<^v^>vv><v<>^>>>><<>>^>>>v>^v<>^<vv<v<^v^><v<>^^>^^^^vv<><^<<^>>^v^v<>v>v>^<>v<^vvv>^vvvv>v^<^v^vv^>^^v^>^^^^<v^>v<v^>>v<>>v>^^>>v<<v>vv<>^^<v>>vv><v^v><^^>v<<^>v^v<>v^^>>><>^v^><><<>>^^^v^v<>^^^>v<>v^<^^>>v<^v<>v>>vv<vv^>^^v>^><v><>^^^v<<<v<v<v<>^>^<^v<<v<^>>vv^^>^<>>^^<><^vv>^<>>^><v^^<>v^<^vv><v><v<>^^^<^vv<v^v>><<><>v>><^^^<<v>vv^>vvv^>v<^^vv<>vv^<<>>^^^v<<vv<>vv^>vv>><vvvvv<><^v>^><><<^<^v<<v^>^v>>^^<>v^v>v^v^>^>>>>v<^<>^>>>v^^>>>>v>v>vvv<^^v>^<v^<<^><^^<>^^>v>^^^vvv^v>vv^>v^v<>>^>^^>>>v<^v>v><>>v<<^<^<<><<><v<>^<^<v^>v<v><v>^^^<>>^<^^v^^>^^<v<<v^vv>^^^^vvv>>><<<v>v><^<vv>vv^vv<^<^>^<<v<>v>v>>>>vv^^<<>^^<vv>>v>^<v^v^>v^<^<vv>>>v^>^^v>>vv<>^^vvv^^<<^v<v>><><<v<^vvvv^<^^<>v><<v<^><^v<^>>^<^^><>v^v><>v^><v<v^>>^<<>v<<>^>^>^v^v^<>^vvv><v>>^vv><^^>vv<v^^<>>v<^^<<^><>^^^vv><^>^v<^vvvv><<>v^v>vv><vv^>vvv<vv^^>^<><^>><><<>v<<v><<>v>v^v<<^<vv>vv><<<^^^>^^v<^^^v^^v<><^>^><>>>v><<<>>^^<v>v^<v><<<^v<<v
v>^v^v^>v^>v<><^<v>^^<<>v>><>^<>v<><vvv^^<><<<<<^>^<v>><<v>v><<>^v<^>v^<>^<<<>><>><^v^v<>><v>^v><^<>^^><>>><>^^^>v^>>>><^<>>^^vv^^^>^<^^<>>^^>^^v^<v<<<<^^><v^>^><^>>^>>>^<<>v^v><<^<<vv^^v<vv>^>v>v^v^v>>vv<^<^>^><<>^<>><^v^v<^v<<<<<v><^<>^><v>>^>v^vv>><^<<v<vvv>^<>><>>v^<^^>^^>v^>^v^v^<^^^<vv>><v>vv<<>>v^v<^v^<vv<<v>v<><>vv>v^v^^><^v<<^><v^^v<^^^<>>>>^^><vv><<>>>><>><>vv><>^^v>^v<vv^<v^^<^>v<^<^^^^vvv>>v>>^>v^>vv>v^<>^v>vv>vv><^v<v>^^>v>v<>v^<v>vvv<<>v<v<^<<^<v<>v^v>>^<<^<>>>vv^v>^v<<^^vv>><vv><v><<<<v<v>vv<>>^^v<^v<^<>>>^^^>^>vv>>^<v>vv>>^<v^<><<v^<v>^>>vv^^^>vv^>^v<<><>^>>><vv>vv>v<v^><>v<vv^><<<^>vv>^<v<vv>v><vvvv^>vv>>v<<<<><<^<>^vv<<^v>v>v><<^>^v^^<vv<<<v<^>^<vvv>^vv<>^>><^^<v<>>^>v>>v<^v>>v^<^v^>^v>v>>^vv><<^vvvv^<<<>><><v<>^v><>^^^><v^<<<vv><<<v>^>^v<v^^^<<>v^<v>>^>v<<<<vv>^v<^v<v<<vvv^<><>><^vv<>^<v>v<v^>>^^><>^<<>><vv^v>>vv<<^v^>^^v<^<^<<<<<><vvv><v^v^^<^v<v>>^<>^^^>v<v^v>><^<v<v<>>v<^<vv^<v<^^<v<vv>><vv<^>v<^^<>>>^v><^vv>>v<^>><^v>^^>^v>>>v>^<v><>>^<^<^^>>>^<v^<<vv<<^<^<><v^><
^vvv^^v>>>v<^^<v><>^<<>v<v^>^<^v>v><<^^>^v^<v^<^^v<><v^><^v<vv<>><^<^<>^<v><<<v^^<^<>^<^<^>^v<v^<>^<<>>v<v><<>>>>>v>>>^<>>v><v^><v<<^^v<^^>^<<^v^>><><^v><^<>>>^^<v>>>^^^<^v^<<>v>><>vv^v^>>^^<vvvv<^<>^v>^<vvv<<v<><<<>>^><<>>v>v<<^<^^>v^><<>>><^^>v<v<>^><v^<<^v>><^v^<v<vvvv>>>^v^v^<<^<><<^<><v<v<><v^><v<^v>><<v>vv<<^>^>^<>^><<v>v^^^<<^^>^>>^^^>^^v>v>^<><>vv>v>v<><<vv<v>v>vv^vv>><v<^^<<<<<>v>v<^<^^>^^vv<v^<^^>><^^>^^>^>>v>^^<^<<^<>>><v<vv<v>^^<^<v<^<>^^^v><^<v>>^>^^>v<><<vv>v^v^><v^<<v<<<>^<^>><^^>><<<v<^>v^^>v^v>^^>>><<<^<^^^<<^v<<v^vvv>v^vv<>>v^vvv^>>^^>^<vv^<v<>>>^>v>>v^vv^v<vv<v>^<v>v>>vv<^v^<vvv<>^v<^^v<><^^<<vv><vvv><v<>^><vvv<vv<>>^v><vv<<><vv<^^><<>^<>v^v<v<><vv<vvv>^<<v<^v^>v<v^^><><^v><^^<<>v<<<>^>v>^v<<vv^>v^>>^<^>>^v>^^>v>>>v>^>^^v<>vv<v<>>>><<<<>^>v<<<>^<>^v<^^v><<^v^v>^v>^vvvv<vv>>v^>^v<<^^><v>vvv>><v>v<v<v^><v>^^^><>^<>v>v<vv^<^^>v^>>><><>vv^<^vv>v>>>^>v>v^<v^^<<^<<v<vv^>^><<^^<>><^v^<>vvv>^^v^>>^^>v>vv^<^><v^<><v<v>v<v<>^>^><<v^^<^^v>^v<>>vv^<><^<vvvvv^^v>^><^v^<<^>><<v^<v
<><^<v<vv<^^<v<<^^^^^<v<v^<v><<^<v>vvv>v>>>vvvvv^^<><^<<>>>>^<^><v>v<>>>v>><^^>^^^^>vv<>>^v<>^vvv><>^<^v^vv><v^<v<><<<^^^<><vv^<>v<v<v<<<>><>><<>v^<v<<^^>>><>>v>v>^>><v^vv<v>v^v>>>v<><^<v^^>^v>v^>^^v^<vv^v<<v>><^v>^vv><^>^v><v^vvv>v^<^v<>>^>v^v^^v>v><v^<^v><v>v^<vv>vv^<>>^v<>>^<vv^><>^v>v^v><<^^^<^>>v>><v<^>>v^<>v>><>>>^<>>^v>^>>v>>^>^><>^<^^><>^^^>^v<vv<v<^^v<v<>v>^^>v><>^>vv>><<vv>><>v<>^^<v><<^^v>vvvvv^><>^>>vv<vv>v^>>>>>>^<^v^>v<v>^<^<^<v>><<<vv^v>^v<v^vvvv>^^vv^^v^>>^vv^><v>>><v<v>>><vv^>>vvv>v^>><^<^>>^><^><<v<^v<v<<<vv>>><<v^v>>^^v^v^<v>>>>^<v<v<^>v^<v^v^^vv<^v^v>v>>><<v<^>vv><v>^<v^^v<^v>^<<<<vv^^<>v>v^<><^><vvvv>v>^<>^^v>vv>v>><>>><v^>^<^<<v<^>^^<^<v<<<>v<>^v>^v^>>^>vv<v^^^^><<<<v^<<>^>v<<^><^<^>v>v^v<v<<<><><v^^>^>^><<<vv>^<>^^>vv^v^v><<v<<<<>^v<v<v<>><vv<^^<^^>vv^v><v^<^^><<^>^>^><>><vv<><v<>v>v><><^<v<^v>^><v>^<v><v>^<v>>>^vv^^><^v<^<<v^v^<<^<^<<v><^^<^<vvvv<v^>^^v<<>>vv^<vv>>v^v^>>v^^<>v>v^v^>><<<<<^v^v^>>>v^<^vv<>^^vv<>^><<^^^^<vv<<^<v<>v<v<vvv>>v<v>v><^<>^v>^^^^>>>><v^<>
v>v>^^<vv>^<^v><>^<><>^<<>><>^v<vvvv>^>>>>^^v>^<>>><><vv<<<v<v>><<^>v>^<^v>v<vv^>^<<><<^^vv<>>>><^v><^<><v<^>^<v>v>v>vv<vv>>^<<^v<vv^^>>^^v^v><>>><<<^v^v^<><^>v<^<<<<^^<>^>v^vv<v><v<><vv>vvv^>>>>>^<^^^<>v^><><>><v^<<^vv^^>>><v<^<>v^v<^^v<<>^v^v><^v^>v<v<vv<^vv>^vv>^<vv>v<>>>^v<^><><vv>><<^^^v^>>>v<><>vv^<^>>v><<^<<^>v^^<^^^<<<<>v<<^>^><^v<>v<v>><^^><^v><><<v><v^<v<^<>><^><>v<<vv^>v^<v<^^>^^^<^^>v^><^^v<v><v>><>v>v<>><v^<<v<v^v<<<v<>^v<v^<>^^^>^>><>v^v>v<>v<>>>^v>v^v<<^>vv>>v<>v><<<^<v>^v<><><vv<<v<^>v<^v^>^<>^<><v^^v<><v>v^v>^^v<^v>>^>><v^>vv<^^<<^<<<v<<<>vv^^>v><vv>>^^^v<><vvv<vv<<^<>>v><^^<^<>vv<^v^><^^><<>^<^^><^<v^^<>^>^><><vvv^<vv^v^v<<v>>v<^<<>v^^>v^vvvv>^<^^<<>>^>>^<v>>v^<>>>^v<>^>>v><^<v^^>>^>>>>>>v^v^^<<>^v<v^v><>>^^^>^^v<<><>>>^^v^v>v>><>v>^<^v>>^>^>><<v^vv^>^v<^>^vv>v<v^^vv<<>^v<<^^><><v<><v<^^<<<<<^^><^^vv>vv>^^^^>v<^>^v^v>>v<v<v^>><>>vv>^<>><<^^>^<>>^>>^^vvvv>>>>>v^<v<>v^<v^v><<<>^v<^>v><v<>^vv<<v<><<^^<v<>><>^v><v<v^v^^<<^<>^^^<^<>^v<^v^^<v>>v>^><vv^>>>^<vvv^>>>v<^v<>v^<>
v<v<^^<<v<v>v^^^<<v^^^^v^<<vvv>><<<<^^><^<<<vv^><>^^^^<v>><v>vv^<v^<<>^<>^v^>^v<<vv>>^<>v^v>><<v<vvv>>^^><<<^v><^vv^<vvvv^^^<<<<>v><v>>^>^v>><^><v<<v><>>^<<>vv<>>^>^<<<^>>v^<>v<^>v^v>>^v<>>^^>vv>>>vvvv<^^><><^v^<>v>^>>v<<^^<<<^^^^<^<<v^^<<^<<<>vv>>>v<<>^^><<>vv<><>>vv>vvvv<^>v>^^><vv^><>>><>>>vvv<>v<<<^v^vv^v>^^^v><<<vv<^^><>>vv<v<<>^v>>^>v^v^^>^^v>>>v<^>v^<vvv^^^^v^^>v>v^^>v<^<v<v>v<>v>vvv<<v^>>^>vv^^<v>^v<v^v^v^>>>^^<v^v<^v>>^v^<<>><>v<^v>vv>v<^><>v^<>^^<<<><<vv>v>v>>vv><>v^^>><^vv^>><vv>^vv>>>vvv><>^^v^^>>><v<vv>^<v^^^><^v>^>v^^v^>>v<vv^^v<>^<^>v<<^<^<>><><<<v<v^>^v><^v>^<>>^<<<^><^<>v>^<<><v>>>>^><^^vv><>v>v^<<v>^^>^>>v>>^v>v<^v<<><><v^^>v>>>^^<^v<<v^<>vv^^>v<^v^^>^>v><v<<vv>><><<<^^<>^^<<^vv<v>>>^><v^^^^v>^v>^<^v^vv^^^v<<v>^<<^v<<<>^<v<^<><v<v><<<^v^^<^>v>><>v>><>><<v<^>^<v^^><^^vvv>>v<v>>v<v><vv<>><^^v<<^v>><v<>^<<v>^<<^vvv<^<<<<v^>^<vv>>^><^<vv^v>>v<>^^<<<>v>^v^v>^<>^^^>v^^>v<v><^^<^v>><vv<><vv^^>^>v>^><><>^>^<<^<><v>>^>^<^v^<v>vv>><>^^vv<^<<<^^>><<vv<v^^v^<>>^><<<v>>v^>vv><v<v>
^^vvv<vv^>>v^v<<v>vv<v>^<><^^>>v<>^v^<>^^<^^>v^^^><^^<v<v^<<v<<>>^<><vv>><>^<>^<><>><v>><^<v<>^><<^>^><>^vv<<>>^v><^^vv>>^^^v>><<>>v<>v<><>v<v><^<>^v^^^>>^v^^^v>>v<<>v><>^v^<^^><<v>>><v^v><v<^>><^<<<vv<>v<v>>^vv^><>^<v>v^<^<v^<^<>v<<>v<v^v^>^>v>><><>^^<>^vv^<<<>>>vvv^>^>^v^<>vv>^>v^>^<vv^vv>^^v<^>>^<v^^^<><<^<^^^>v^v>>^<^v^^vv<vv^>v^^^^^^vv>>>><v<v^^v^^>v^>^>>v<^v^^>^^<^v>^>vv<vv>>>^v>^vv^<v^>^<<^<^>v><^>v<^<v<<^vv>^v<^vv<<v^<<>>vv^vv<>^^^v>^^v<>>v^^>><v>><>>>><>v><vvv^><<v<>>v^<<v<v<><>>vv>^<>>v<<><^v^^<><v<>v^v<v>^>v>>>v>^^^v^^^^><^^v>v<v><v^<^v^v^>vv^<<<v>><^v^<>>><vvvvv^<>>^><<^v^^<^vvv^>^<<v>>^<v>>>><v<^<<vvv^v><^^>v^>^>vv>^>>>>>v>>^>v<>><<<>^^^^<>>v><^>>vv<>^<v^<<v^<>^<<>>v<^>^^<<^>>vvv^^>>><^v^^><<v<v^<<^<<^v<^^><>vv^v><<<v^>v<^>>v^v^>^vv<>^>v>vv>^v^vv>>v>v<<^v^>^^v<v<^>><>^^^><v<^^<>vvvvv<<^^<^<^vv^><>v>><<<<v^<>vv><v<>^><^><^<v>><v<><>><^^v<<><<<>^^v^^^>^^vv<^<^>>>>>^v<^<^><<>><>vv<^^v>><<><<^>v<>v>^>v<^^^^<v><v>>>><^^^vv<<^<v><^>^<<^>>^<<>^^^<v<>^>^^^^v<<vv<^<<^>>v>>>vv<v>v>v
>v^v>><<v>>^<>>v<<^v^<<^><^<v^^v^>vvv<^>^<v<<^>v<^^^v<vvv<<<^^<>^>vv^^<>^<v^vv<^><v<v<^v^v>v>v><^^><><^^<^<^>v<>^<^v^^<v<<vvvv^vvv^vv^<^^>v>v^vv^>>^v^^<v<><^>>>^vv^v><^>vv><<>^^<>><<>v>>>^<v<v<>v>>>>v^<vvvv^^>v>v>^<>v>><>>v<v>v<^v^<>>v<>^^<<<^><^><v><<>v>>vv<^<<<vv<^<<>v^v^<^>v^<<>><<<<>^<>^<<v<v<>^>>>v^<>><^>><>v^^^vv>^^^v><v<<v>>^>>>v^><<><><^<^v><vv>^<>>^^v^><vv>>>>^^><>v<^^<v>>v<><v<^^v>v>vv<<>^<>v<<^>^>vv>vv^>^^vv>v>v<^><>^>>>>v<^^^<><>^<^v><>^v>^<>>^^>vvv<>^>^>>vv<>^<v^v<^<v>vvv>>v><<>^v<<<v<>><^<^<<^v>vv>v>>v^<vv>^<v>^<v<v^v<^<<^^^>^^<^vv<<v<^^<>v<^>>>^<v<v<>^v>^>^>^><<^^>vv<>^^>^^^v^><v^<<>>>^<<<^><><^><v^<^<^<^^>v>^^^^vv<^<vv><^^v>>v>v<<vv<v>^v><^^v>^<v<vv<^^><>v^<^><^^^^>^vv<<^v^v>^^<>v<<vv<v^<^>^^v<<v<>>>vv^<^v^>^^<<>^^^>^vv^^>><<^^<v^><<><^>^^v>^vv<>>v><<>v^><><^<v>v<><^>^^>^vv>>v^vv<v<v>v><<>>v>><v><^^v^<<v>^v<v^vvv><^v<<<>^^<vv<>>>v>><vv>^<^v<<vv>><^<^^<v<v<v^^<^><<v><<<v<^v^^vv^v^<<v<>>vvv><>vv>^>v>>v>^v<>^^<><v<>v<><^^<^>^^^<v^>v<^^<<<<vv>>^<^^^<<v<><<>^^>>^v<vv<vv><<^v
v>^>>><v^vv>^v>v>^vv>^<>>vv>^^v><v>><v<>v<<^<>^v><v<^>^<>^v<<vv^<^><^>v><><^v<><><>><<<^v^^^v<><^^v<>vv<>>^v^v<v<^<vvv>^<vv><v<^v>>^><>>vvv>^v>^v^><<vvv^>^>v^vv<^<>v><<<^<<>>^<^^^>^<^^v<^vvv^>^^v<<<>v<^<^^^^>>>>vvvvv><^<>>vv^><^<><>^<<^vv^>^>>^>v<vv<v^v<>^<<>^>><<>^<^^^^v>^^^><v>v^v^v<>^^^<v>^^<vv><^>v>><^v^<^v<>^<v><v^vvvv>^^<^v<^>^<v^^v^^^v<v>vv^<>vv<^v<^^^^<^>v>^vvv><>^<^^>v^^><>^v>^<v>><vv>v>^>><v>^<<><v^^<<>>vvv^<<>^<>^v<>vv>vvv<<<v>^v^v^<>>v<v^<v^^<>^v<vv><><vvv<^^^^>v><<<^>><>vvv<<<>vv>vvv>>>v^<^^><<v>^<v<>^^<v>><vvv><>v<<^^<>^^v^v^><^>v^^v^<^^v<^>>^v^vv<<<>>^v^>^>vv^v<<vv^<><<v^^<^<v>>v<^vvv<v<>>^<>v<vv>v^v<<v^>^v<v<v^v^<><^v^<<v^v<<^<<><^^^^<^<v<^v<^><^>^<>vv>><<><^^>><v^>vv^^^v<>>>vv^>v^v>^^v><><<v>><<^>vvvv<^<^^vv^>v<^^<^v<^>vv>vv^>^<<<^v<^v><<^<>v<<>>>^>>^<<^>vv>^<^<>>^^^v^^v^><^><<vv>v<^<vv^>vvv<^v<>^vv^^v<^<^<>><v><v<v>v>>^>>>><>vvvvv<^><<^<<><<v<>v>><>^<<v^<<<^^v^^>v<>^><>^>v<><<>>><^^v^^^>v^<vv>^<<<>>^v>>^^<>>^>><<v<v>>v>>v<>vv<<<^<<<^>^v>>^v><vv^>>v>>><>v>^>v^>^>><v<^<
^v>^>vv<^<v<>>>^^><vv<<>vv>><vv^^>>^>v<^<^<vvvv^<v<^v<v<<>^^<v^^vv>vv>>^>^^^>v><v<<^^><^vvvvv<^>v<v<>v<v>vv<>^^v>^>v^^>v^><>vv<v>vv<>><<>^v^>vv^>>>^<^>>v^>v^><v>^v^^<<v^>vv><>><vvvv<v^^^^<<^<<v^v<<v<>><<^<<^^<v><><<<^v<^^v<<<<>^>^<<^>^v^v>><>^<<^^<<v>^<^^^^>v^>^<><<^>v<<<>^>v<^vv<vv^><v^>><<>>v>^<<v>^v<<v^>>^v^v^<^<><<<^<<<><^v>^v^vv<v^v<vv^>^<^v^v^>v<^>v<>><<v<vvv^<><v^>^<<^>^<^^^>^^^><>v<v^>v^>>v>^<v^<v>>v<>^<^v^>>^>v>vv>><^v>^v^^>^<>>>^>>v<>v><<<>^vv<<>><>vv^^^>^v<<<<^><><^>^v>>v>><vvv<vv<v^>v><v<<^<>>^>^v^<>>^^><><><<<^vv>v<>v>v><><v^>^>^<<>>>^<<v>v<>>v^v<v^^^^v<^><>><v>><v>vv>>^^^><>>v<^>^^^^>^<>^>^vv^>^<^<v>vvv>v<^><<v<^vv>^>^<v^<<<^v<v<^^>^v>v<><<^<>v^^^v>v><<<<<^<v^vvv>>v^^<vvv>v<<>>><<<^>><><<^v<^^^>^v>^<v>v><>^^^>v<<<<v^^^vv^^^vv<><v^v^^<<<v<<<>vv>v<vv<v^>><<<v><<>^v>v<^>^<<^><v^v>^>><>vvv<<<>><<>^<>vv>>^vv^>>>vvvv>^<>v^^<><^>^vv>vvv><<vv<>^<^^v<^v^>^^^^>>>v>vv<^<>>v^v^><v^^>>>vv<^v>^v>^><^>>>^<^v<>v>>^<<>vv<>>^v^<<>v<vv^^<<^<<>^^v>^><^><<^<vv^<<^<<<v><v<><v^<>^^<>^><<v>vv>^v
^<v<<><v^><>>v><<^<<<v^<^v>^v<v<<v^<vvv^>v<>v^<><^^v<>>>^><<<v^><v<v^v><v><v>^^vv>v<^>^><<v>vvvv>^vv><<<<><v^vv<^vvv>^<><<>v><^<<<<>>>>^>>^<vvv>^^vv^<vv>>^v<<>^<^<<>>^v<<><>>>v<^>^^v<<<><v<v<vv^v><>>>><v^>v><>>^^>><v<>>v^^>v^<<<<vv<<^v<<v>vvv^<v<^>^>^vv<><><<^v^<<^v<><^>^^^v>>><v><>^^^v^^>>>^v^^v<v<>^^<v><>^^<^<v<><>vv>^<<v<^<>^v><<<<><<<^v>v^<<v^<v^<>vv<>v><<^<<<<<<^>v<<>^^^>>vv<^v>^v<><^<vvv^>v<^>vv^v<><<><^^>^^^^vv^<<>^^>>^<v>v>>v<>vvvv<^^v><^^^^<<<vv^>^^^^vv><^<><v<^<v><vv^^^>>v>v<^v>vvvv<v^<>vv>v<v<vv^^>>>>v^>^v^^<^<>^>^^^>>>>vv<<>^vvv>>^>><^><<vvv>v>^<^^<^><v<><<<^^^>>v<>vvv^>>^>^>^v><vvv>^>>vv><^^v<v>><v<<><><>><<^v^<v<>><^^^><<<<^<<v>v>vv^><>^^<<^>v^<v^>v^<<^vv><^>>^>><>^^<>v^v^><^v>vv>vv>v<>^^^<^^<v<vvvv>v<<^>>^^v><^v<v<>v^^>>v>v>^v<v^><<v><><v^>v<>^v^<v>><^v^<<^^^<vvvv^<><><<v<v>v^<^><<<>^^<v^^v^^<>><>^v><^v><vvv><^<v>^vv^>v>^^v^^>>^vv<>^><>^><vv^v<<vvv>v>vv^v^^>vvv<v^v^v>^v^<>><^^v<>>v<<>v<<v>vv><<<><v<^^<>^>^^v<>^<v^^<^^<<><>vv<^^>v>vv^><><v>v^>>vv<<<<><>v^<^<>^v^v>^<>vv^^>
><>^<^><<>v<>>^^<>><<v>^v<<<<v^<<<<v^v><>><vv^v>v<v<>>><^^^v>><vvv^^<<<<^vvv<v<v^>>^>v<^v^<<<<<<^^v>><v<><v^^>^<>>v^>>v^v<<<>^v<v><>><<^><v>>^v^>vv^^^v^^vvv>^<>^><vv^>v><^><<^^v>v<vv>^<><<v<<v^^>>^>^<<^>>>^^^v<<>^^^v>v<<^^^^v><v<<<v<>^><<<>v<v>v>>>v<>^^v^^^<><<<<^v><^^^<<v<v<>><v>^>v<>>^><<>v<>v^^vv>^>v>^vv>>>v^v^>vv^>>^>>v>v<>>^<^<^>><<^^^v^v^<v>v>><<^>v^v<>v<^>vvv>>v>^>^<vv^^>>v><^<^^<<<^v>v<>><vv>>>^v^<<^<v^v^<^<^^v<v<v^<v><<>^^<<><vv<^vv<v>vvv^<v<^^<v>>>><<v^v<^>^^<^^^<^^^^v<>^>>><vv^<><v^>^vv<><><>v>^^>^<v^v<>^v><<<^v<v^><>><><^^<v<><v^^v>v^<v>^^v<^<<<^>>^<><v<><^>v^<v<><v^^>v>v^>><><>vvv<<>>^^>v><v<v^<v>^<<><>^<^v>>^^<>v<>^<>v<><v>><>^><vv<>><>>v>^v^v<<v<<>v><^>>v>><v^v><>><<>>^v^>>vvv><^^<^>v><><^^v<v^>>>v><v>>><><<v^^<>><<>v>^^vvv>^v^^^<<<<<^v^<<>v<>v^<v^>^<v>>>>^<<v<<^^<<<<>>vv>vv^>>v^vv^v>>vv>>><<^><>^>>>>^v<^v^<v^>v^^<<<<<><<>>v><><v<^v<><^><^^vv>^<^v>>>>^v<<vvv><<<^^<>^<<^^^v^^vv>v>><<<v^v>^<<>v^><<v^v<^<v^^<>^>v<<>v><>>v>^^v^^v<^><>>^>>>v>v>^vv>v>>^v>>v>>v<v^^^>><<^^<v<<>^
<><v>>^<^v^><^<<^<><v<<^>^>v<^^<>>><^<v^v^>v<^<^v<v<<^>vv>^^vv<<><<v<<>^><v<>><v^>v^<<>>>^><>v^>>^><v<<<><v>v<^>^^<^>>>>v>>>>v^v<>>><><^><v><^>>>^>^>^<vv^><><>v><^v^<vv^>><<<>v^v>><v<v^<>^>vv^^v<vv^vv>>v<v^<vv^><v>vv^^v>^<vv>v>>>^>>>>>^<vv<^<<^v<>v<<^^>>>v<v^<v^<vv><>>vv>^^v<v^^^<v>v^^>^<vv^^<^v>>>>><><<^>^><>^^^><v>><v^^>^v><<vvv^vv^<^<^vv><>v<vvv^^><><<vv^v><>^><v^<<<<v^v<<^^<<<vv>v^vv><>>v<^<>^>vvvv^<>><v<v<<<v<>>>v<><^v^v>><<^vvv>v^^<<v<<vv>v^vvv^<v^><v<v<vv<v><v>>^vv^^<>^v>^vv>^<>v^^>v^><<v<>^<<v^>v<><<^v^>><>^<^v^^>^^^^<^<><<^<v^<<<^^<v<^<v<^<<>vv^>>^><v^>^^<^^><<><v<^>v^^^><v<v<>^v^vv^v^<>^v<^<v>>v^<^v^^<^<v^><>>vvvvvv<<v>v^>vv>><^>^<v^><>>vv^^v<^v<^>vvv>^><^^^<>v<>v><<^>>^^>><v<^<vv><^^^<>^>><vv^>v^<<vvv<^vvvvvv>^>><>v>v^<<^^v<<<v><<><^<><>vv^^^v<>^v^^><<>^v^v^v>v>>v<>vvv><><v><>><v<>><vv^^v^v<^^^^<^><<<^^^v^vvv<^^>^v^^>^^v^<^<v^<vv<^>>vvv>^>>><v^v>>><^v^<v<v<v^v<<>vv>^vv<<<><^v><<vv><<>>><v>^>>v^><<>>>><<v<vv<<<>>v>^><^>v<vv^^<><<^<<vv>v><>^<<>^>^^^<^^^^vv^<v<v>v^>^<v^<^^^<^v<
v><<>^<>>^>^>v^^<<^<v<<^v^^<>>^<^vvv>^^v<>>^v<>^<^>vvv^^>v<^v>^v>v<<<v<^^v^^<<^v><v<^v><vvv><v><>>^^<<>v^>><^>^^><^><vv^v^<>>><<^<><<v^<>>>>><>>>><v<>>><^v<v>v<<v>>vv<v<>^^>v^>v>>^^^v>^^^vv<<>>^>v<^<>v<><<<^>^v<v>><v>v<^^v>^>^v><vv^^vv<<<<>vv>v^<>>>^<^<><>v>>vv^>v<><>v<v^^v<>><<^>vvvv^><>>^<<^v>^>^>><v<^>>v<vv<^vv^<^v^>v>v^v>>vvv>>>^<v>^^^<><>^^^>>>^<>>^v^^^<<<><><vv>>^^^<<>v^<>^>>>>>v><>>v<>vvvv>v>>v^>v<<<<>>>vvv^vv><><<vv>v^<vv>>v>><<>vvv>^v<<>>vv><<>>>vvv<vv^v>^<^>^^<^v^><<<^<>v>v>^vv^<^<^^>v<>^<>^^<^><^<<<v<v>v<><>v>vv>v>^v><vvv^^^v>><v>>v<><v<<>^<<>^<>^^>^<v<<^>v<v>vvvvvv>v^>^^vv<>><<^^>>vvvv<<v<v<<>>^<<>^>v>^v<^^^<<<<^>>><<>v^v<<v^vv^>^^v<^v>v^^>^^>^<vv>vvv<>>>v<<v^^vvv>v>><vv^<vv>>vv^>^v<^^v^v<v<^>v<<><^>^>vv<v<<v><><<^>><><<v^<v<v>v><>vv^<v>^v<^>v^^>><^v<v^^<<^>v<>^<<v>vv>v^^v<<^<>><>^^^>vvvv^<>vv<v>vv<v<vv^<>vv<>vv>>^v<<<^<>><^v^^^^<>v<><><v^^>^>><vv<^<vv^>>^^^^v^<>v>^^<v<^^><v><^v^<^>vvvv<v>v<v<<^><><^<^<v<^<v>>v^>>>><<^v>^v^<^>vvv^>^vv><>v><^><<>vv^>^^><>^v><<<<vvv^^<<v>>><^
^^^^v^vv<v><<^v^v<<<^v>vvvv<<><v^v><^<>^<>^v<^<^^^^<^<v^v^<v>>^v>^>><<v<>v^>><<<^^>^^vv^^v^>v<><^>>v<<><^<^^<^^<>vv>>^<<<v<<<<v<^^vv^^vv>v<>^>^>^>^^>^v><^v>^^>^^>^<><<vv<<v>>v>>^<^^^^>>^<>>vv<<v>^>v^vvv<<^vv<^>>><vv<><^>v<v>^vv<<v>vvv<v^^^><>^>><vv><<>>vv><>v^^v<<>^>^<<><v^^v<v^<><v^^>>v>^^>v>><>><<<^v><v^v^<>v>v<v>v^^v<^v^<><^>>>><<vvvv^<><<<vv^<<<<vvv<^^^^<<<>>><v>^v^><^>vv^^v><>^v^vv^^^^v<>^^<<>>^>>v>v<^^<v<<^<^^<^v^^>v>>><^^>^^<v^>^<>v>>^<^vv<^v<><>v>^vvv^^<<vv<><^^^<<v>>^^<^^>^vv><v^>^<><vvvv>><^^>>v>^^^>^v>v^<<<^v>^>><vv^^vv>>^>^>^<^^v^<^^^^v^vv<^>^^v>^^>v<>>><>vv^>>>>^<^<v^<^^>>>^<^><^<v>>^v^>>v^^>v>^v<v^^v>>^v^<vvv>^v>>><^vv^<>v>>^v<><^vv^<>^^<<^v<>^v<vv>^^<^<<v>>^>v<^^^<>vv<^<v<<v<>>^^<<>v>^^^<^vv^<<^>>>v^^><^<><<<v^<<^<<^<^^<^v^><>>^<^vv<<<v^v><>v><v^>v<^>vvvv<^>^>^v<>^><<v<^><^^v>>^v>>><><^>v^<><^^^v<^<<^>v>>^v<><>^<<v>>^<><>vv<>^^^<>>^>vvv^^v><<vv<vv^<vvv><^^<>v<v<<<>^<<v><>><v<^v>vv>^v><>v>v^<^>v^^v^><^^v>v^>v^^>>v^^v^v^v>^<vv>^v>><^^v<^vv>>v^vv<>>v<><^^<vvvv>^>vv<v<>^v>v^
<vv^v^<>>^>^v^<^v<><v^^v^>>>><<vvv>vv>>>v<v^<<v^v>>^>><vv^^>v^><>><<><<>><^v<^>><><v<>^vv^^<^<<>><>^^v><v^^^^v>v><^<<vv>v<<>^<<><v<vvv^v^<<<<v>>^v<^<<^>v><<^^vvv<vvvvv^<^>v^<v^vv^^^^>^><^v^^^vv^v<>v>^<v^^vv<v>^<^>v<>^vv^^>v^>^>>v>^v>><v<<><^v>^vv^^^<<^v<v^>v<^v>v^^v<^^v<^<><>v<>><<<<<^<^<v><^<v^<<v^^v<^>vvv^<v>>^^<<v<vv^v^v^^vvvv^>>><<v><v<vvvvvv^<>v^>^^>>vv^>^v^<<v><<>>>v<^^v^^v<<>^^<v<^<>>^vv^>v^<vv><<>>>^<^><v^^<v>vv^>v<^^^>^>^^^>v^>v>vv^v<^>^<^^<^^>^v^^vv^<^><<vvvv^vv^^>>><<><>><<v^v^<^v^<^vv<<^<^v>v<<<>^<>v>v^<<>^<^vv>v<^^^^<^v^>^v<v^<^vv>>v<v<v<<<v^<^>v<<<^vv^<>vvv><vvv<><<>v<^<<^>^^<>^<<<^^^>v<v^<><^>v<>^>vv>^>><v^v<^>v<^v^^>>>v>^v>v^v<^v^v^^>^^^v<vv^><^>v^<^vv^<^<^<<v<^^>^^v^<vv<^>^v><^v^<v<v^<>v<^^<><>>vv<>^v>>>^v>>>^vvv^^>v<<^>v^<vvv>>^<^<>><v<^v>><>>v^vv<^^v><><v^>vv<<^v^^>^vvv<>vv^^>^>^<v^>>^>v^<>v^>vv^<<^<v>vvv>>vv><v<><<v<<v^^^^<vv<<>>>^v>^>v><<^v<<^>^><>^vvv<<>><<>v><>v<vv>^><><>^<>^^>v>v>><v^^^>v<^>^<v^>^v<>v>v<>^<>>^v^<<^vv<^><>><v^v<^^vv>>^^v>^<<><<^vv^^><vv<vv<v>v<>>
<>v>>^^^v^^>^^<>>><v^>^>v>v>>^<^^<^<>><>>^>^>v>v<^^^^^<>^<<v<^>v>><<>v<<^v^vvv>>^vv<<v><<vv^<<><v^<^<>><<><^^><<<>v<^v<^vv<><<v>v><v^>^<<>^^^<<v^>>>><v^>^vv<>>vv<^^<^<^<<vvvv><>^v>vv^^v^^<v<<<>^<<<^^<>^<^v<^<v<><>v>v^<>v<<<^v<<^<^><<v^>>vv^v^v<^><v>^v^>^^v^>v<><vvv^>v<<^>^<>>v>>>^^v>^v^^^^<<<^^v^^<>^^>v>>^^^<^vv^<^^>^><><^^<<<v<>>v>^^>^^<>vv^v^^<>v>vvv<vv^<<^^>v>^^>^><^^>v^><^<><>v^>v>vv<<v^^>>>^<<>vv>^^v<^<^^><vv<^>^^>^<<<<^<<><<<v>v>><<vv^^>v>><v<v^vv<<vvv^<><^v><vvv<^>^<><v<<<^<>v<<<^v<<vvv<>^v^^<vv<>^^<<v^vvv<vv>^>^^<v>^>>v^>vvvv^^>><<>^>v^^v^^v>vv>^^<^<v>^<vv^>^^>vvvv<><<v<^^><<<<v^<v<>^v<^<>^v^v<>^^>><v<^>v^vv^<v^>^^>^v<vv^><v^^<^<^^<^>>v^vv^vv>v^^<>v^>>v><<^<<<<>>v>^vv>^<>^vv<>>^^><>><vv>><>^^>^>>^v<^^^>>^><<v>^>>^^v<>^^<v<^<<><<v><v^v^<<>><v^v><>^^>^vv<<>v^>>>^<>v^<^^^^^^<^^vv>^>>^^><v^<^<v>^vv^<v<^v^v^>v><><^v^>v<^>vv^>v>v><>^^v>^>>^>^v>v^<^^<><<>^>v>>>^>v^^^v>v<v<<^^>^>>>><v<vv>><<>^>vv>^>vv<<^^^>v<v^^v<^v><<<<<<vv>><<<vv^>><^^<vv<v>^^><v><vv>>>>v>v>^>^<<<>v<v<>^>>>^>>v<>v>v^
^vv<<v^v<^v^v^^>v>vv<><<^^<>^v^><<v>v>>><v^>>vvv>^^vvv^<^^v<^<^>>^<^<^>>>^><v^>v<><<v<<><^><<<v^><^>><<<<v<v^v^<<<^^^vv>><<v<vv<>^vv>>v>vvv>v^<^^^v<>>^^v^<^^^^^<^>>v^>^<vv<>>>>>v<>^><vvv<>^v^^<^v>vv>>^^^^<>^^<^>^<v^^^^^vv>v^>^>v^<^v^<v<^<><^<<vv^v^^>>^>^>^<v^^><^^vv^v^>vv>^^<<<><^^<v<<>^<<>^<v><>^v>>v^v<^>^<<><^^<v>>^vv<><vvvv><vvv^>^>vv^v>vv^^>vv<><^v>v^>^^v>vv>>v><v>^^<^<^<v^<>v<<^<^^>^>v<<vv^<^v<^^<^>^>v>vvv>vv>^^v><>><>v^v><><^<v>v>v<v<vvv^^><<>^v<^<^^<vvvvvvvv<<^>>>>><>vv><>^<^>v>>>>>>^<^v>v>^>^<<^^v>><<><^^>v>>v<^>><v^v>><v^>vv<v<vv>v^>v^><^<^v><^v>vvvv^^>v<v<v<><>^^<>>v^>>v^>>>><^>><^<<<v<^><<^^^^<<vvv^^^^<>>>v<<>>>v^vvv>^><><<>><vv>^^^^^><><vv>v^<<v>^>vvv>^v>>>^<<<v^^^>^^^<v^>>v>>>^^^<>>><v>>v<v>^<v>^<><^<>^v^vv>^>>v<<>vvvvv>>^>>v>v>><v>^>v<^<^^v^>vv<vvv>v^>>^v<v>v><^<>>><<^>v<<>^^>v<^^v<v>v<>>>^^>^>^<^^^<<v>v^>vv>^>^v<v>^<<vv^<<<>>>>><^vv<<<<^v^v<v>^<v>>v<>^<>^v^<vvv>^<<^<<>v^<<>^>v>^<v<v><>vv<v>v>^^>^v<^>v<^^>vvv^v^<v>^^^<>^>>v>^v^v>^^v<^vvvv^v>>>><>^>>vvv>^v>>v>^<>>^>^<>^>v<
"""

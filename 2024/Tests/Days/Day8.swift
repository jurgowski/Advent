import Testing

private struct Pos: Hashable {
    let x: Int
    let y: Int
}

private struct Ant: Hashable {
    let pos: Pos
    let freq: String.Element
}

private func inside(pos: Pos, map: [[String.Element]]) -> Bool {
    map.indices.contains(pos.y) && map[pos.y].indices.contains(pos.x)
}

private func part1(input: String) -> Int {
    let map = input
        .split(separator: "\n")
        .map { Array($0) }
    
    var antinodes = Set<Pos>()
    var ants = Set<Ant>()
    
    for y in map.indices {
        for x in map[y].indices {
            let freq = map[y][x]
            if freq == "." {
                continue
            }
            for ant in ants {
                guard ant.freq == freq else {
                    continue
                }
                let pos = ant.pos
                let dx = abs(pos.x - x)
                let dy = abs(pos.y - y)
                [
                    Pos(x: pos.x + (pos.x > x ? dx : -dx),
                        y: pos.y - (pos.y < y ? dy : -dy)),
                    Pos(x: x - (x < pos.x ? dx : -dx),
                        y: y + (y > pos.y ? dy : -dy)),
                ].forEach {
                    if inside(pos: $0, map: map) {
                        antinodes.insert($0)
                    }
                }
            }
            ants.insert(Ant(pos: Pos(x:x, y:y), freq: freq))
        }
    }
    return antinodes.count
}

private struct Slope {
    let A: Int
    let B: Int
    let C: Int
}

private func part2(input: String) -> Int {
    let map = input
        .split(separator: "\n")
        .map { Array($0) }
    
    var ants = Set<Ant>()
    var slopes = [Slope]()
    for y in map.indices {
        for x in map[y].indices {
            let freq = map[y][x]
            if freq == "." {
                continue
            }
            for ant in ants {
                guard ant.freq == freq else {
                    continue
                }
                let pos = ant.pos
                slopes.append(Slope(A: y - pos.y,
                                    B: pos.x - x,
                                    C: pos.y * (x - pos.x) - (y - pos.y) * pos.x))
            }
            ants.insert(Ant(pos: Pos(x:x, y:y), freq: freq))
        }
    }
    var antinodes = Set<Pos>()
    for y in map.indices {
        for x in map[y].indices {
            for slope in slopes {
                if slope.A * x + slope.B * y + slope.C == 0 {
                    antinodes.insert(Pos(x: x, y: y))
                    break
                }
            }
        }
    }
    
//    print(map.indices.map { y in
//        String(map[y].indices.map { x in antinodes.contains(Pos(x: x, y: y)) ? "#" : map[y][x] })
//    }.joined(separator: "\n"))
    return antinodes.count
}

@Test func testDay8DebugPart1() async throws {
    #expect(part1(input: debugInput) == 14)
}

@Test func testDay8Part1() throws {
    print(part1(input: input))
}

@Test func testDay8Part2() async throws {
    #expect(part2(input: debugInput) == 34)
}

@Test func testDay8DebugPart2() async throws {
    print(part2(input: input))
}



private let debugInput = """
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
"""


private let input = """
.........................p........................
......................h....C............M.........
..............................p....U..............
..5..................p............................
..6z...........................................C..
...............c...........zV.....................
...5.....c........................................
.Z.............h........S...z....9................
.O............................9...z........M..C...
..O....5..............................F..M..C.....
..Z.........5.c...............M....V..............
........ZO................q.......................
s...O................h..Uq.....7V...........4.....
.q.g..............c.............p.......4.........
............hZ.............................4G.....
6s...........................U.Q.....3............
.......6.................9.......Q.............3..
....s..D.........................6................
.............................................FL...
..................................................
..g...D.........q.....f.......Q...F....L......7...
...............2.........f.............V.L...4....
...................2.s...................f3......G
....g...........................v......7P.........
..2..g.............d.....v...........P.......1....
..............u.........f.............L........G..
.........l.D....u...............d........o..P.....
..................8...............9..1......o...7.
............l.....................................
...................l...S...........F.......o..U...
.......................u...S......................
..........l....u...............m...........P....G.
......................................1.8.......o.
..................................................
..................v.......S................0......
.............v........d.....1.....................
..................................................
..........D....................................0..
...................m.............H..........0.....
...................................d......0.......
..................................................
....Q.............................................
................................H.................
........................H....................8....
..................................................
..................................................
.........................................8........
.......................H3.........................
............................m.....................
................................m.................
"""

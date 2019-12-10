//  Created by Krys Jurgowski on 12/1/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func day8(_ input: String) -> Int {
    var digits = input.compactMap { Int(String($0)) }

    var layers = _convertToLayers(&digits)
    let lowerLayerIndex = layers
        .map { $0.reduce(0) { $0 + $1.reduce(0) { $0 + ($1 == 0 ? 1 : 0) }}}
        .enumerated()
        .sorted { $0.1 < $1.1 }
        .first!.0

    let lowestLayer = layers[lowerLayerIndex]
    var map = [Int: Int]()
    lowestLayer.forEach { $0.forEach { map[$0] = (map[$0] ?? 0) + 1 } }

    layers.reverse()
    let finalLayer = layers.reduce(layers.first!) { (currentLayer, layer) -> [[Int]] in
        return zip(currentLayer, layer).map { rows -> [Int] in
            return zip(rows.0, rows.1).map { (pixels) -> Int in
                pixels.1 == 1 ? 1 : pixels.1 == 0 ? 0 : pixels.0
            }
        }
    }

    _print(grid: finalLayer)
    return  map[1]! * map[2]!
}

func _convertToLayers(_ digits: inout [Int]) -> [[[Int]]] {
    var layers = [[[Int]]]()
    while digits.count > 0 {
        var rows = [[Int]]()
        while rows.count < 6 {
            var row = [Int]()
            while row.count < 25 {
                row.append(digits.removeFirst())
            }
            rows.append(row)
        }
        layers.append(rows)
    }
    return layers
}

func _print(grid: [[Int]]) {
    grid.map { $0.map { $0 == 1 ? "*" : " " }.joined() }
        .forEach { print($0) }
}

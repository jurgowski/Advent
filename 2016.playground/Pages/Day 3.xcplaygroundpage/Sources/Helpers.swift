import Foundation

public func numOfWierdTriangles(_ input: String) -> Int {
    let triangles = input.components(separatedBy: CharacterSet.newlines)
    var triangleSides: [[Int]] = []
    for triangle in triangles {
        let sides = triangle.components(separatedBy: CharacterSet.whitespaces).filter({ (side) -> Bool in
            return !side.isEmpty
        }).map({ (side) -> Int in
            return Int(side)!
        })
        triangleSides.append(sides)
    }
    
    var vertTriangleSides: [[Int]] = []
    var firstTriangle: [Int] = []
    var secondTriangle: [Int] = []
    var thirdTriangle: [Int] = []
    
    for i in 0..<triangleSides.count {
        let triangleSide = triangleSides[i]
        firstTriangle.append(triangleSide[0])
        secondTriangle.append(triangleSide[1])
        thirdTriangle.append(triangleSide[2])
        if (i % 3 == 2) {
            vertTriangleSides.append(Array(firstTriangle))
            vertTriangleSides.append(Array(secondTriangle))
            vertTriangleSides.append(Array(thirdTriangle))
            firstTriangle.removeAll()
            secondTriangle.removeAll()
            thirdTriangle.removeAll()
        }
    }
    
    var validTris = 0
    for vertTriangle in vertTriangleSides {
        let sides = vertTriangle.sorted()
        if sides[0] + sides[1] > sides[2] {
            validTris += 1
        }
    }
    
    return validTris
}

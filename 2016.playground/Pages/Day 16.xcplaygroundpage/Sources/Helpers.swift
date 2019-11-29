import Foundation

public func checksum(_ input: String, diskSpace: Int) {
    var a = [Bool]()
    for bit in input.characters {
        switch bit {
        case "0":
            a.append(false)
        case "1":
            a.append(true)
        default: assertionFailure()
        }
    }
    while a.count < diskSpace {
        a = dragon(a)
    }
    a = Array(a.prefix(diskSpace))
    while a.count % 2 == 0 {
        a = reduce(a)
    }
    p(a)
}

func dragon(_ a: [Bool]) -> [Bool] {
    let b = a.reversed().map { return !$0 }
    return a + [false] + b
}

func reduce(_ a: [Bool]) -> [Bool] {
    var b = [Bool]()
    var index = 0
    while index < a.count {
        b.append(a[index] == a[index+1])
        index += 2
    }
    return b
}

func p(_ a: [Bool]) {
    for bit in a {
        print(bit ? "1" : "0", terminator:"")
    }
}

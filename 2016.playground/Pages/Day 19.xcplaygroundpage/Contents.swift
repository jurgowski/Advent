//: [Previous](@previous)

import Foundation

func lastElfNext(_ input: Int) -> Int {
    var last = input - highestBit(input)
    return last * 2 + 1
}

func highestBit(_ input: Int) -> Int {
    var test = 1
    while test <= input {
        test *= 2
    }
    return test/2
}

lastElfNext(3004953)

func lastElfAcross(_ input: Int) -> Int {
    let highThree = highestThree(input)
    if input == highThree { return input }
    var rem = input - highThree
    if rem > highThree {
        return rem * 2 - highThree
    } else {
        return rem
    }
}

func highestThree(_ input: Int) -> Int {
    var test = 1
    while test <= input {
        test *= 3
    }
    return test/3
}

lastElfAcross(3004953)
//: [Previous](@previous)

import Foundation

func shiftLeft<T>(_ arr: [T], amount: Int) -> [T] {
    let shift = amount % arr.count
    return Array(arr[shift ..< arr.count] + arr[0 ..< shift])
}

func shiftRight<T>(_ arr: [T], amount: Int) -> [T] {
    let shift = (arr.count - amount) % arr.count
    return Array(arr[shift ..< arr.count] + arr[0 ..< shift])
}

shiftLeft([1, 2, 3, 4, 5], amount: 2)
shiftRight([1, 2, 3, 4, 5], amount: 2)
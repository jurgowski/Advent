//  Created by Krys Jurgowski on 12/2/18.
//  Copyright © 2018 United States. All rights reserved.

import Foundation

func day5a(_ input: String) -> String {
    let code = react(input.unicodeScalars)
    return "\(code.count)"
}

func day5b(_ input: String) -> String {
    let minimum = (0..<26).reduce(input.count) {
        (currentMin, i) -> Int in
        return min(currentMin, react(input.unicodeScalars.filter { ($0.value != (65 + i)) && ($0.value != 97 + i) }).count )
    }
    return "\(minimum)"
}

private func react(_ scalars:String.UnicodeScalarView) -> String.UnicodeScalarView {
    var code = scalars
    var currentIndex = code.startIndex
    while currentIndex < code.endIndex {
        let nextIndex = code.index(after: currentIndex)
        if nextIndex >= code.endIndex { break }
        if match(code[currentIndex].value, code[nextIndex].value) {
            let previous = currentIndex == code.startIndex ? code.startIndex : code.index(before: currentIndex)
            code.remove(at: nextIndex)
            code.remove(at: currentIndex)
            currentIndex = previous
        } else {
            currentIndex = code.index(after: currentIndex)
        }
    }
    return code
}

private func match(_ a: UInt32, _ b: UInt32) -> Bool {
    return abs(Int32(a) - Int32(b)) == 32
}

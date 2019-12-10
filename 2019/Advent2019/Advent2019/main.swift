//  Created by Krys Jurgowski on 12/1/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func run(day: Int, first: Bool, test: Bool) {
    print("Problem \(day) part \(first ? "a" : "b") \(test ? "(test)" : "")")
    let str = input(day, test)
    let any: Any
    switch day {
    case 1:  any = day1(str)
    case 2:  any = day2(str)
    case 3:  any = first ? day3a(str) : day3b(str)
    case 4:  any = first ? day4a(str) : day4b(str)
    case 5:  any = first ? day5a(str) : day5b(str)
    case 6:  any = first ? day6a(str) : day6b(str)
    case 7:  any = first ? day7a(str) : day7b(str)
    case 8:  any = first ? day8a(str) : day8b(str)
    case 9:  any = first ? day9a(str) : day9b(str)
    default: fatalError()
    }

    print(any)
}

let day = 2

//run(day: day, first: true, test: true)
run(day: day, first: true, test: false)

//run(day: day, first: false, test: true)
run(day: day, first: false, test: false)





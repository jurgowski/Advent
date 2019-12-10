//  Created by Krys Jurgowski on 12/1/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func run(day: Int, test: Bool) {
    print("Problem \(day) \(test ? "(test)" : "")")
    let str = input(day, test)
    let any: Any
    switch day {
    case  1: any =  day1(str)
    case  2: any =  day2(str)
    case  3: any =  day3(str)
    case  4: any =  day4(str)
    case  5: any =  day5(str)
    case  6: any =  day6(str)
    case  7: any =  day7(str)
    case  8: any =  day8(str)
    case  9: any =  day9(str)
    case 10: any = day10(str)
    default: fatalError()
    }

    print(any)
}

let day = 10

//run(day: day, test: true)
run(day: day, test: false)






//  Created by Krys Jurgowski on 12/1/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

let day = 2
let test = false
let first = false

let dayFunc: (String) -> Any
switch day {
case 1:  dayFunc = first ? day1a(_:) : day1b(_:)
case 2:  dayFunc = first ? day2a(_:) : day2b(_:)
case 3:  dayFunc = first ? day3a(_:) : day3b(_:)
case 4:  dayFunc = first ? day4a(_:) : day4b(_:)
case 5:  dayFunc = first ? day5a(_:) : day5b(_:)
case 6:  dayFunc = first ? day6a(_:) : day6b(_:)
case 7:  dayFunc = first ? day7a(_:) : day7b(_:)
case 8:  dayFunc = first ? day8a(_:) : day8b(_:)
case 9:  dayFunc = first ? day9a(_:) : day9b(_:)
default: fatalError()
}

print("Problem \(day) part \(first ? "a" : "b") \(test ? "(test)" : "")")
print(dayFunc(input(day)))

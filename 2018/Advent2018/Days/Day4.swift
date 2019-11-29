//  Created by Krys Jurgowski on 12/2/18.
//  Copyright © 2018 United States. All rights reserved.

import Foundation

func day4a(_ input: String) -> String {
    let formatter = _formatter()
    let sortedRecords = input
        .components(separatedBy: CharacterSet.newlines)
        .map { Record(string:$0, formatter:formatter) }
        .sorted { return $0.date < $1.date }
    let sleepIntervals = sleepTimes(sortedRecords: sortedRecords)
    let maxSleepTime = sleepIntervals
        .sorted { $0.value.reduce(0,+) < $1.value.reduce(0,+) }
        .last!
    return "\(maxSleepTime.key * maxSleepTime.value.firstIndex(of: maxSleepTime.value.max()!)!)"
}

func day4b(_ input: String) -> String {
    let formatter = _formatter()
    let sortedRecords = input
        .components(separatedBy: CharacterSet.newlines)
        .map { Record(string:$0, formatter:formatter) }
        .sorted { return $0.date < $1.date }
    let sleepIntervals = sleepTimes(sortedRecords: sortedRecords)
    let maxSleepTime = sleepIntervals
        .sorted { $0.value.max()! < $1.value.max()! }
        .last!
    return "\(maxSleepTime.key * maxSleepTime.value.firstIndex(of: maxSleepTime.value.max()!)!)"
}

private func sleepTimes(sortedRecords: [Record]) -> [Int:[Int]] {
    let calendar = Calendar.current
    var sleepTimes = [Int:[Int]]()
    var currentGuard = 0
    var asleepMinute = 0
    for record in sortedRecords {
        switch record.event {
        case .shiftBegin(let guardId):  currentGuard = guardId
        case .asleep:                   asleepMinute = calendar.component(.minute, from: record.date)
        case .awake:
            let awakeMinute = calendar.component(.minute, from: record.date)
            var sleepTime = sleepTimes[currentGuard] ?? Array(repeating: 0, count: 60)
            for minute in asleepMinute..<awakeMinute {
                sleepTime[minute] += 1
            }
            sleepTimes[currentGuard] = sleepTime
        }
    }
    return sleepTimes
}

struct Record {
    let date: Date
    let event: Event

    enum Event {
        case shiftBegin(Int)
        case asleep
        case awake
    }

    init(string: String, formatter: DateFormatter) {
        let components = string.components(separatedBy: "]")
        date = formatter.date(from: String(components[0].dropFirst()))!
        let key = components[1].dropFirst().components(separatedBy: CharacterSet.whitespaces)[1]
        switch key {
        case "up":      event = .awake
        case "asleep":  event = .asleep
        default:        event = .shiftBegin(Int(key.dropFirst())!)
        }
    }
}

private func _formatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    return formatter
}

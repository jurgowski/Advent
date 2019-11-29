//: Day 10

import Foundation

let fileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let input =
    try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
        .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)



class Bot {
    private var _first: Int?
    private var _second: Int?
    var lowTarget: Target?
    var highTarget: Target?
    
    
    var isReady: Bool { get {return hasValues && hasTargets}}
    var hasTargets: Bool { get {return lowTarget != nil && highTarget != nil}}
    var hasValues: Bool { get { return _first != nil && _second != nil }}
    var low:  Int { get { return _first! > _second! ? _second! : _first!  }}
    var high: Int { get { return _first! > _second! ? _first!  : _second! }}
    
    func addValue(_ value: Int) {
        if _first == nil {
            _first = value
            return
        }
        if _second == nil {
            _second = value
            return
        }
        assertionFailure()
    }
}

enum Target {
    case bot(Int)
    case output(Int)
}

func findBot(_ input: String, lowChip: Int, highChip: Int) -> Int {
    let instructions = input.components(separatedBy: CharacterSet.newlines)
    var bots: [Int: Bot] = [:]
    for instruction in instructions {
        let commands = instruction.components(separatedBy: CharacterSet.whitespaces)
        switch commands[0] {
        case "value":
            addValue(value: Int(commands[1])!,
                     botId: Int(commands[5])!,
                     bots: &bots)
        case "bot":
            let low = Int(commands[6])!
            let high = Int(commands[11])!
            addTargets(botId: Int(commands[1])!,
                       lowTarget:  commands[5]  == "bot" ? .bot(low):  .output(low),
                       highTarget: commands[10] == "bot" ? .bot(high): .output(high),
                       bots: &bots)
        default: assertionFailure()
        }
    }
    for (index, bot) in bots {
        if bot.low == lowChip && bot.high == highChip {
            return index
        }
    }
    return 0
}

func addValue(value:Int,
              botId:Int,
              bots:inout [Int: Bot]) {
    let bot = getBot(botId, bots: &bots)
    bot.addValue(value)
    runBotIfReady(bot, bots: &bots)
}

func addTargets(botId:Int,
                lowTarget: Target,
                highTarget: Target,
                bots:inout [Int: Bot]) {
    let bot = getBot(botId, bots: &bots)
    assert(bot.lowTarget == nil)
    assert(bot.highTarget == nil)
    bot.lowTarget = lowTarget
    bot.highTarget = highTarget
    runBotIfReady(bot, bots: &bots)
}

func runBotIfReady(_ bot: Bot,
                   bots:inout [Int: Bot]) {
    if (bot.isReady) {
        resolveTarget(bot.lowTarget!,  value: bot.low,  bots: &bots)
        resolveTarget(bot.highTarget!, value: bot.high, bots: &bots)
    }
}

func resolveTarget(_ target: Target, value: Int, bots:inout [Int: Bot]) {
    switch target {
    case .bot(let botId):
        addValue(value: value, botId: botId, bots: &bots)
    case .output(let output):
        print("\(output)'s value is \(value)")
        break
    }
}

func getBot(_ botId:Int, bots:inout [Int:Bot]) -> Bot {
    if let bot = bots[botId] {
        return bot
    }
    let bot = Bot()
    bots[botId] = bot
    return bot
}

findBot(input, lowChip: 17, highChip: 61)

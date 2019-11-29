import Foundation

public func validPasswords(input: String) -> Int {
  var validPasswords = 0
  let passwords = input.components(separatedBy: CharacterSet.newlines)
  for password in passwords {
    let words = password.components(separatedBy: " ")
    let wordSet = Set(words)
    validPasswords += wordSet.count == words.count ? 1 : 0
  }
  return validPasswords
}

public func validAnagramPasswords(input: String) -> Int {
  var validPasswords = 0
  let passwords = input.components(separatedBy: CharacterSet.newlines)
  for password in passwords {
    let words = password.components(separatedBy: " ").map { return String($0.sorted()) }
    let wordSet = Set(words)
    validPasswords += wordSet.count == words.count ? 1 : 0
  }
  return validPasswords
}

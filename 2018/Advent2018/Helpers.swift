//  Created by Krys Jurgowski on 12/2/18.
//  Copyright © 2018 United States. All rights reserved.

import Foundation

func input(_ day: Int, _ test: Bool = false) -> String {
    let home = FileManager.default.homeDirectoryForCurrentUser
    let inputPath = home
        .appendingPathComponent("Developer")
        .appendingPathComponent("Advent")
        .appendingPathComponent("Advent2018")
        .appendingPathComponent("Inputs")
    let fileURL = inputPath
        .appendingPathComponent(test ? "test" : String(format: "%02d", day))
        .appendingPathExtension("txt")
    return try! String(contentsOf: fileURL, encoding: String.Encoding.utf8)
        .trimmingCharacters(in: CharacterSet.newlines)
}

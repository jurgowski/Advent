//  Created by Krys Jurgowski on 12/1/19.
//  Copyright © 2019 United States. All rights reserved.

import Foundation

func input(_ day: Int, _ test: Bool = false) -> String {
    let home = FileManager.default.homeDirectoryForCurrentUser
    let inputPath = home
        .appendingPathComponent("Developer")
        .appendingPathComponent("krys_repos")
        .appendingPathComponent("Advent")
        .appendingPathComponent("2019")
        .appendingPathComponent("Inputs")
    let fileURL = inputPath
        .appendingPathComponent(test ? "test" : String(format: "%02d", day))
        .appendingPathExtension("txt")
    return try! String(contentsOf: fileURL, encoding: String.Encoding.utf8)
        .trimmingCharacters(in: CharacterSet.newlines)
}

//
//  String+.swift
//  GitHubClientTests
//
//  Created by fox on 20/04/2024.
//

import Foundation

extension String {
    var data: Data? {
        let subPath = "PlugIns/GitHubClientTests.xctest/"
        guard let jsonPath = Bundle.main.path(forResource: subPath + self, ofType: "json") else {
            fatalError("path = \(self).json is not in Bundle: \(Bundle.main)/\(subPath)")
        }
        return try? Data(contentsOf: URL(fileURLWithPath: jsonPath))
    }
}

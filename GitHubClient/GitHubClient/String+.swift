//
//  String+.swift
//  GitHubClientTests
//
//  Created by fox on 20/04/2024.
//

import Foundation

extension String {
    var data: Data? {
        guard let jsonPath = Bundle.main.path(forResource: "PlugIns/GitHubClientTests.xctest/" + self, ofType: "json") ?? Bundle.main.path(forResource: self, ofType: "json") else {
            fatalError("path = \(self).json is not in Bundle: \(Bundle.main)/")
        }
        return try? Data(contentsOf: URL(fileURLWithPath: jsonPath))
    }
}

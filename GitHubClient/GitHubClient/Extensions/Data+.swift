//
//  Data+.swift
//  GitHubClient
//
//  Created by fox on 28/04/2024.
//

import Foundation

extension Data {
    static func cacheUrl() throws -> URL {
        let folder = try FileManager.default
            .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("cache")
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        return folder.appendingPathComponent("Repository.json")
    }
    
    func saveCache() throws {
        try write(to: try Self.cacheUrl())
    }
    
    static func retrieveCache() throws -> Data {
        return try Data(contentsOf: try cacheUrl())
    }
}

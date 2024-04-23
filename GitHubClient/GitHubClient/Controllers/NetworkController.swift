//
//  NetworkController.swift
//  GitHubClient
//
//  Created by fox on 23/04/2024.
//

import Foundation
import CoreData

class NetworkController {
    static func requestRepositories(isPreview: Bool, isCacheEnabled: Bool) async throws {
        guard isPreview == false else {
            try PersistenceController.shared.clean(isCacheEnabled: isCacheEnabled)
            try PersistenceController.shared.placeholder()
            // ON preview, just clean and recreate placeholders
            return
        }
        guard ProcessInfo.isRunningUnitTests == false else {
            // On Unit Tests
            return
        }
        if try PersistenceController.shared.isRepositoriesCacheEmpty() {
            try PersistenceController.shared.placeholder()
        }
        let url = URL(string: "https://api.github.com/search/repositories?q=language=+sort:stars")!
        let (data, _) = try await URLSession.shared.data(from: url)
        try PersistenceController.shared.clean(isCacheEnabled: isCacheEnabled)
        _ = try PersistenceController.shared.jsonDecoder.decode(RepositoryResponse.self, from: data)
    }
}



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
        guard isPreview == false,
              ProcessInfo.isRunningUnitTests == false
        else {
            // ON preview or Unit Tests, just clean and recreate placeholders
            try PersistenceController.shared.clean()
            return
        }
        let url = URL(string: "https://api.github.com/search/repositories?q=language=+sort:stars")!
        let (data, _) = try await URLSession.shared.data(from: url)
        try PersistenceController.shared.clean()
        _ = try PersistenceController.shared.jsonDecoder.decode(RepositoryResponse.self, from: data)
        if isCacheEnabled {
            try data.saveCache()
        }
        try PersistenceController.shared.container.viewContext.save()
    }
}

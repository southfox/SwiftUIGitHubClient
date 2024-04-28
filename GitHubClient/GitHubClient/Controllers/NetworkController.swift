//
//  NetworkController.swift
//  GitHubClient
//
//  Created by fox on 23/04/2024.
//

import CoreData
import Foundation
import SwiftUI

class NetworkController {
    static func requestRepositories(viewContext: NSManagedObjectContext, isPreview: Bool, isCacheEnabled: Bool) async throws {
        guard isPreview == false,
              ProcessInfo.isRunningUnitTests == false
        else {
            // ON preview or Unit Tests, just clean and recreate placeholders
            try PersistenceController.shared.clean(viewContext)
            return
        }
        let url = URL(string: "https://api.github.com/search/repositories?q=language=+sort:stars")!
        let (data, _) = try await URLSession.shared.data(from: url)
        try PersistenceController.shared.clean(viewContext)
        _ = try PersistenceController.shared.jsonDecoder.decode(RepositoryResponse.self, from: data)
        try viewContext.save()
    }

}


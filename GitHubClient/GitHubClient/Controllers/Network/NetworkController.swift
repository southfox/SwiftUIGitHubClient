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
    private var persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
    }
    
    func requestRepositories(isPreview: Bool, isCacheEnabled: Bool) async throws {
        let viewContext = persistenceController.container.viewContext

        guard isPreview == false,
              ProcessInfo.isRunningUnitTests == false
        else {
            // ON preview or Unit Tests, just clean and recreate placeholders
            try persistenceController.clean(viewContext)
            return
        }
        let url = URL(string: "https://api.github.com/search/repositories?q=language=+sort:stars")!
        let (data, _) = try await URLSession.shared.data(from: url)
        try persistenceController.clean(viewContext)
        _ = try persistenceController.jsonDecoder.decode(RepositoryResponse.self, from: data)
        try viewContext.save()
    }
}


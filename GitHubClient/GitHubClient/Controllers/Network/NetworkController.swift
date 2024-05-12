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
    
    func requestRepositories(isPreview: Bool, isCacheEnabled: Bool) async throws -> [RepositoryModel] {
        guard isPreview == false,
              ProcessInfo.isRunningUnitTests == false
        else {
            // ON preview or Unit Tests, just clean and recreate placeholders
            return RepositoryModel.placeholders
        }
        return try await RepositoryResponseModel.request()
    }

    func requestCoreDataRepositoryResponse(isPreview: Bool, isCacheEnabled: Bool) async throws {
        let viewContext = await persistenceController.persistence.container.viewContext

        guard isPreview == false,
              ProcessInfo.isRunningUnitTests == false
        else {
            // ON preview or Unit Tests, just clean and recreate placeholders
            try await persistenceController.clean(viewContext)
            return
        }
        try await RepositoryResponse.request(persistenceController: &persistenceController)
    }
}

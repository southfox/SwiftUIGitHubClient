//
//  PersistenceController+.swift
//  GitHubClient
//
//  Created by fox on 23/04/2024.
//

import Foundation
import CoreData

extension PersistenceController {
    func clean(_ context: NSManagedObjectContext) throws {
        try cleanRepositories(context,
                              repositoryResponseFetcher: RepositoryResponse.fetcher,
                              repositoryFetcher: Repository.fetcher)
    }
    
    private func cleanRepositories(_ context: NSManagedObjectContext,
                                   repositoryResponseFetcher: NSFetchRequest<RepositoryResponse>,
                                   repositoryFetcher: NSFetchRequest<Repository>) throws {
        let viewContext = context
        try viewContext.fetch(repositoryResponseFetcher).forEach { object in
            viewContext.delete(object)
        }
        try viewContext.fetch(repositoryFetcher).forEach { object in
            viewContext.delete(object)
        }
        try viewContext.save()
    }
    
    func isRepositoriesCacheEmpty() throws -> Bool {
        try container.viewContext.fetch(RepositoryResponse.fetcher).isEmpty
    }
}

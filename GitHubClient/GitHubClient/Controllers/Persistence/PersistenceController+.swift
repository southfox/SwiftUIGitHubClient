//
//  PersistenceController+.swift
//  GitHubClient
//
//  Created by fox on 23/04/2024.
//

import Foundation

extension PersistenceController {
    func clean(isCacheEnabled: Bool) throws {
        try cleanRepositoryResponse(isCacheEnabled: isCacheEnabled)
        try cleanRepositories(isCacheEnabled: isCacheEnabled)
    }
    
    private func cleanRepositories(isCacheEnabled: Bool) throws {
        let viewContext = container.viewContext
        let fetchRequest = Repository.fetchRequest()
        
        // Check if we have only one response
        try viewContext.fetch(fetchRequest).forEach { object in
            viewContext.delete(object)
        }
        if isCacheEnabled == false {
            try viewContext.save()
        }
    }
    
    private func cleanRepositoryResponse(isCacheEnabled: Bool) throws {
        let viewContext = container.viewContext
        let fetchRequest = RepositoryResponse.fetchRequest()
        
        // Check if we have only one response
        try viewContext.fetch(fetchRequest).forEach { object in
            viewContext.delete(object)
        }
        if isCacheEnabled == false {
            try viewContext.save()
        }
    }
    
    func rollBack() {
        let viewContext = container.viewContext
        viewContext.rollback()
    }
    
    func isRepositoriesCacheEmpty() throws -> Bool {
        try container.viewContext.fetch(RepositoryResponse.fetchRequest()).isEmpty
    }
    
    func placeholder() throws {
        let viewContext = container.viewContext
        /// Loading state enum from Shimmer framework, it's used for redacted views.
        (0..<10).forEach {
            let repository = Repository(context: viewContext)
            repository.brief = "The #\($0) programming language"
            repository.fullName = "some/#\($0)"
            repository.icon = $0 % 2 == 0 ? "https://avatars.githubusercontent.com/u/4314092?v=4" : "https://avatars.githubusercontent.com/u/1507452?v=4"
            repository.language = "L#\($0)"
            repository.name = "l#\($0)"
            repository.stars = Int32(arc4random() % 1000)
        }
        try viewContext.save()
    }
}

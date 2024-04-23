//
//  PersistenceController+.swift
//  GitHubClient
//
//  Created by fox on 23/04/2024.
//

import Foundation

extension PersistenceController {
    func clean() throws {
        try cleanRepositoryResponse()
        try cleanRepositories()
    }
    
    private func cleanRepositories() throws {
        let viewContext = container.viewContext
        let fetchRequest = Repository.fetchRequest()
        
        // Check if we have only one response
        try viewContext.fetch(fetchRequest).forEach { object in
            viewContext.delete(object)
        }
        try viewContext.save()
    }
    
    private func cleanRepositoryResponse() throws {
        let viewContext = container.viewContext
        let fetchRequest = RepositoryResponse.fetchRequest()
        
        // Check if we have only one response
        try viewContext.fetch(fetchRequest).forEach { object in
            viewContext.delete(object)
        }
        try viewContext.save()
    }
    
    func isRepositoriesCacheEmpty() throws -> Bool {
        try container.viewContext.fetch(RepositoryResponse.fetchRequest()).isEmpty
    }
    
    func placeholder() throws{
        let viewContext = container.viewContext
        for i in 0..<10 {
            let repository = Repository(context: viewContext)
            repository.brief = "The #\(i) programming language"
            repository.fullName = "some/#\(i)"
            repository.icon = i % 2 == 0 ? "https://avatars.githubusercontent.com/u/4314092?v=4" : "https://avatars.githubusercontent.com/u/1507452?v=4"
            repository.language = "L#\(i)"
            repository.name = "l#\(i)"
            repository.stars = Int32(arc4random() % 1000)
        }
        try viewContext.save()
    }
}

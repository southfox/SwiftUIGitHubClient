//
//  RepositoryActor.swift
//  GitHubClient
//
//  Created by fox on 02/05/2024.
//

import CoreData
import Foundation

actor RepositoryActor: Identifiable {
    let id = UUID()
    var isSelected: Bool = false
    var item: Repository
    
    init(isSelected: Bool, item: Repository) {
        self.isSelected = isSelected
        self.item = item
    }
    
    func toggle() {
        isSelected.toggle()
    }
    
    static var placeholder = RepositoryActor(isSelected: false, item: .placeholder)
}

extension RepositoryActor {
    func requestRepositories(persistenceController: inout PersistenceController, viewContext: NSManagedObjectContext, isPreview: Bool, isCacheEnabled: Bool) async throws {
        let url = URL(string: "https://api.github.com/search/repositories?q=language=+sort:stars")!
        let (data, _) = try await URLSession.shared.data(from: url)
        _ = try await persistenceController.jsonDecoder.decode(RepositoryResponse.self, from: data)
        try viewContext.save()
    }
}

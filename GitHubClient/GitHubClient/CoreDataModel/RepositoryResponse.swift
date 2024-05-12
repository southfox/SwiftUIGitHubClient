//
//  RepositoryResponse.swift
//  GitHubClient
//
//  Created by fox on 22/04/2024.
//

import CoreData

public class RepositoryResponse: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        // Attributes
        case repositories = "items"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init(context: PersistenceController.shared.viewContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        repositories = NSOrderedSet(array: try container.decode([Repository].self, forKey: .repositories))
    }
}

extension RepositoryResponse {
    static var fetcher: NSFetchRequest<RepositoryResponse> {
        RepositoryResponse.fetchRequest()
    }

    static func request(persistenceController: inout PersistenceController) async throws {
        let url = URL(string: "https://api.github.com/search/repositories?q=language=+sort:stars")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let viewContext = await persistenceController.container.viewContext
        try await persistenceController.clean(viewContext)
        _ = try await persistenceController.jsonDecoder.decode(RepositoryResponse.self, from: data)
        try viewContext.save()
    }
}

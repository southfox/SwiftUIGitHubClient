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
        guard let context = decoder.userInfo[PersistenceController.managedObjectContext] as? NSManagedObjectContext else {
            throw GitHubError.managedObjectContextIsMissing
        }
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        repositories = NSOrderedSet(array: try container.decode([Repository].self, forKey: .repositories))
    }
}

extension RepositoryResponse {
    static var fetcher: NSFetchRequest<RepositoryResponse> {
        RepositoryResponse.fetchRequest()
    }
}

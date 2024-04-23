//
//  Repository.swift
//  GitHubClient
//
//  Created by fox on 20/04/2024.
//

import CoreData

public class Repository: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        // Attributes
        case brief = "description"
        case fullName = "full_name"
        case owner
        case language
        case name
        case stars = "stargazers_count"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[PersistenceController.managedObjectContext] as? NSManagedObjectContext else {
            throw GitHubError.managedObjectContextIsMissing
        }
        self.init(context: context)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        brief = try container.decode(type(of: brief), forKey: .brief)
        fullName = try container.decode(type(of: fullName), forKey: .fullName)
        let owner = try container.decode(Owner.self, forKey: .owner)
        icon = owner.avatar
        language = try container.decode(type(of: language), forKey: .language)
        name = try container.decode(type(of: name), forKey: .name)
        stars = try container.decode(type(of: stars), forKey: .stars)
    }
}

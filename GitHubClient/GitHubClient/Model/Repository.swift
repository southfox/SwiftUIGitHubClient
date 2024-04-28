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
    
    convenience init(placeholderIndex index: Int) {
        let context = PersistenceController.db.container.viewContext
        self.init(context: context)
        brief = "The #\(index) programming language"
        fullName = "some/#\(index)"
        icon = index % 2 == 0 ? "https://avatars.githubusercontent.com/u/4314092?v=4" : "https://avatars.githubusercontent.com/u/1507452?v=4"
        language = "L#\(index)"
        name = "l#\(index)"
        stars = Int32(arc4random() % 1000)
    }
}

extension Repository {
    static var fetcher: NSFetchRequest<Repository> {
        Repository.fetchRequest()
    }
        
    static var placeholder: [Repository] {
        /// Loading state enum from Shimmer framework, it's used for redacted views.
        (0..<10).map { Repository(placeholderIndex: $0) }
    }
    
    static var placeholderOrderedSet: NSOrderedSet {
        /// Loading state enum from Shimmer framework, it's used for redacted views.
        NSOrderedSet(array: placeholder)
    }

}

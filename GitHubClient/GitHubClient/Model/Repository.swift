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

extension Repository {
    class func reload() {
        let persistence = PersistenceController.shared
        let viewContext = persistence.container.viewContext
        let i = Int32(arc4random() % 1000)
        let repository = Repository(context: viewContext)
        repository.brief = "The #\(i) programming language"
        repository.fullName = "some/#\(i)"
        repository.icon = i % 2 == 0 ? "https://avatars.githubusercontent.com/u/4314092?v=4" : "https://avatars.githubusercontent.com/u/1507452?v=4"
        repository.language = "L#\(i)"
        repository.name = "l#\(i)"
        repository.stars = Int32(arc4random() % 1000)
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

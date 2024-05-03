//
//  RepositoryModel.swift
//  GitHubClient
//
//  Created by fox on 03/05/2024.
//

import Foundation

struct RepositoryModel: Identifiable, Decodable {
    var id: UUID?
    var brief: String?
    var fullName: String?
    var icon: String?
    var language: String?
    var name: String?
    var stars: Int32

    enum CodingKeys: String, CodingKey {
        // Attributes
        case brief = "description"
        case fullName = "full_name"
        case owner
        case language
        case name
        case stars = "stargazers_count"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        brief = try container.decode(type(of: brief), forKey: .brief)
        fullName = try container.decode(type(of: fullName), forKey: .fullName)
        let owner = try container.decode(Owner.self, forKey: .owner)
        icon = owner.avatar
        language = try container.decode(type(of: language), forKey: .language)
        name = try container.decode(type(of: name), forKey: .name)
        stars = try container.decode(type(of: stars), forKey: .stars)
    }
    
    init(placeholderIndex index: Int) {
        let context = PersistenceController.shared.container.viewContext
        brief = "The #\(index) programming language"
        fullName = "some/#\(index)"
        icon = index % 2 == 0 ? "https://avatars.githubusercontent.com/u/4314092?v=4" : "https://avatars.githubusercontent.com/u/1507452?v=4"
        language = "L#\(index)"
        name = "l#\(index)"
        stars = Int32(arc4random() % 1000)
    }
}

extension RepositoryModel {
    
    static var placeholder: RepositoryModel {
        RepositoryModel(placeholderIndex: 0)
    }

    static var placeholders: [RepositoryModel] {
        /// Loading state enum from Shimmer framework, it's used for redacted views.
        (0..<10).map { RepositoryModel(placeholderIndex: $0) }
    }
}

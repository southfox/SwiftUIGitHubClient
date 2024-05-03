//
//  RepositoryModel.swift
//  GitHubClient
//
//  Created by fox on 03/05/2024.
//

import Foundation

struct RepositoryModel: Identifiable, Codable {
    var id: UUID?
    var brief: String?
    var fullName: String?
    var owner: OwnerModel?
    var icon: String? { owner?.avatar }
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
        owner = try container.decode(OwnerModel.self, forKey: .owner)
        language = try container.decode(type(of: language), forKey: .language)
        name = try container.decode(type(of: name), forKey: .name)
        stars = try container.decode(type(of: stars), forKey: .stars)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(brief, forKey: .brief)
        try container.encode(fullName, forKey: .fullName)
        try container.encode(owner, forKey: .owner)
        try container.encode(language, forKey: .language)
        try container.encode(name, forKey: .name)
        try container.encode(stars, forKey: .stars)
    }
    
    init(placeholderIndex index: Int) {
        brief = "The #\(index) programming language"
        fullName = "some/#\(index)"
        owner = OwnerModel.placeholder
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

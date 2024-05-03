//
//  OwnerModel.swift
//  GitHubClient
//
//  Created by fox on 03/05/2024.
//

import Foundation

class OwnerModel: Codable {
    var avatar: String?

    enum CodingKeys: String, CodingKey {
        // Attributes
        case avatar = "avatar_url"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        avatar = try container.decode(type(of: avatar), forKey: .avatar)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(avatar, forKey: .avatar)
    }
    
    init(placeholderIndex index: Int) {
        avatar = index % 2 == 0 ? "https://avatars.githubusercontent.com/u/4314092?v=4" : "https://avatars.githubusercontent.com/u/1507452?v=4"
    }
}

extension OwnerModel {
    static var placeholder: OwnerModel {
        OwnerModel(placeholderIndex: 0)
    }
}

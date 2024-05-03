//
//  Owner.swift
//  GitHubClient
//
//  Created by fox on 22/04/2024.
//

import Foundation

class Owner: Decodable {
    var avatar: String?

    enum CodingKeys: String, CodingKey {
        // Attributes
        case avatar = "avatar_url"
    }
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        avatar = try container.decode(type(of: avatar), forKey: .avatar)
    }
}

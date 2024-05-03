//
//  RepositoryResponseModel.swift
//  GitHubClient
//
//  Created by fox on 03/05/2024.
//

import Foundation

class RepositoryResponseModel: Codable {
    var repositories: [RepositoryModel]

    enum CodingKeys: String, CodingKey {
        // Attributes
        case repositories = "items"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        repositories = try container.decode([RepositoryModel].self, forKey: .repositories)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(repositories, forKey: .repositories)
    }
}

extension RepositoryResponseModel {
    static func request() async throws -> [RepositoryModel] {
        let url = URL(string: "https://api.github.com/search/repositories?q=language=+sort:stars")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(RepositoryResponseModel.self, from: data).repositories
    }
}

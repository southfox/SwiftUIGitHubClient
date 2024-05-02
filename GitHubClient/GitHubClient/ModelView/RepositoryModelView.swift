//
//  RepositoryModelView.swift
//  GitHubClient
//
//  Created by fox on 02/05/2024.
//

import Foundation

struct RepositoryModelView: Identifiable {
    var id: UUID
    var title: String
    var subTitle: String
    var urlString: String
    var detail: String
    var language: String
    var stars: String
    init(id: UUID, item: Repository) {
        self.id = id
        self.title = item.name!
        self.subTitle = item.fullName!
        self.urlString = item.icon!
        self.detail = item.brief!
        self.language = item.language ?? ""
        self.stars = "\(item.stars)"
    }
    
    static var placeholder = RepositoryModelView(id: UUID(), item: Repository.placeholder.first!)
}

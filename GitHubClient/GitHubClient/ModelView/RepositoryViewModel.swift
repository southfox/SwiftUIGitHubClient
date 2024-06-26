//
//  RepositoryViewModel.swift
//  GitHubClient
//
//  Created by fox on 02/05/2024.
//

import SwiftUI

struct RepositoryViewModel: Identifiable {
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
    
    static var placeholder = RepositoryViewModel(id: UUID(), item: .placeholder)
}

class RepositoryClassViewModel: ObservableObject {
    @State var repositoryViewModel = RepositoryViewModel.placeholder
}

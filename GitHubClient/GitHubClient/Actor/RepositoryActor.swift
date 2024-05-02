//
//  RepositoryActor.swift
//  GitHubClient
//
//  Created by fox on 02/05/2024.
//

import Foundation

actor RepositoryActor: Identifiable {
    let id = UUID()
    var isSelected: Bool = false
    var item: Repository
    
    init(isSelected: Bool, item: Repository) {
        self.isSelected = isSelected
        self.item = item
    }
}

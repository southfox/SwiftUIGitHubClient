//
//  RepositoriesPlaceholderView.swift
//  GitHubClient
//
//  Created by fox on 28/04/2024.
//

import SwiftUI

struct RepositoriesPlaceholderView: View {
    let item: RepositoryModelView
    
    var body: some View {
        List {
            ForEach (0..<10) { _ in
                VStack(spacing: 10) {
                    RepositoryCellView(item: item,
                                       itemIdExpanded: .constant(UUID()))
                    .redacted(reason: .placeholder)
                    .shimmering(active: true)
                }
            }
        }
    }
}

#Preview {
    RepositoriesPlaceholderView(item: RepositoryModelView(id: UUID(), item: Repository.placeholder.first!))
}

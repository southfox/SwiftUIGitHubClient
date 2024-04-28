//
//  RepositoriesPlaceholderView.swift
//  GitHubClient
//
//  Created by fox on 28/04/2024.
//

import SwiftUI

struct RepositoriesPlaceholderView: View {
    var body: some View {
        List {
            ForEach (0..<10) { _ in
                VStack(spacing: 10) {
                    RepositoryCellView(title: "lorem ipsum",
                                       subTitle: "lorem ipsum",
                                       urlString: "lorem ipsum",
                                       detail: "lorem ipsum",
                                       language: "lorem ipsum",
                                       stars: "333",
                                       itemIdExpanded: .constant("lorem"))
                    .redacted(reason: .placeholder)
                    .shimmering(active: true)
                }
            }
        }
    }
}

#Preview {
    RepositoriesPlaceholderView()
}

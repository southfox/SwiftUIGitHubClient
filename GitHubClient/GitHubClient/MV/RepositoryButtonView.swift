//
//  RepositoryButtonView.swift
//  GitHubClient
//
//  Created by fox on 28/04/2024.
//

import SwiftUI

struct RepositoryButtonView: View {
    @State private var itemIdExpanded: String = ""
    var isLoading: Bool = false
    var item: Repository

    var body: some View {
        Button {
            if itemIdExpanded == item.name {
                itemIdExpanded = ""
            } else {
                itemIdExpanded = item.name ?? ""
            }
        } label: {
            VStack(spacing: 10) {
                RepositoryCellView(title: item.name ?? "",
                         subTitle: item.fullName ?? "",
                         urlString: item.icon!,
                         detail: item.brief ?? "",
                         language: item.language ?? "",
                         stars: "\(item.stars)",
                         itemIdExpanded: $itemIdExpanded)
                .redacted(reason: isLoading ? .placeholder : .privacy)
                .shimmering(active: isLoading)
            }
        }
    }
}

#Preview {
    List {
        RepositoryButtonView(item: Repository.placeholder.first!)
        RepositoryButtonView(isLoading: true, item: Repository.placeholder.first!)
        RepositoryButtonView(item: Repository.placeholder.last!)
    }
}

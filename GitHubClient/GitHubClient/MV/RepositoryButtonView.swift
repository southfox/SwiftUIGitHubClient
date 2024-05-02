//
//  RepositoryButtonView.swift
//  GitHubClient
//
//  Created by fox on 28/04/2024.
//

import SwiftUI

struct RepositoryButtonView: View {
    @State private var itemIdExpanded: UUID? = nil
    var isLoading: Bool = false
    var item: RepositoryModelView

    var body: some View {
        Button {
            if itemIdExpanded == item.id {
                itemIdExpanded = nil
            } else {
                itemIdExpanded = item.id
            }
        } label: {
            VStack(spacing: 10) {
                RepositoryCellView(item: item,
                         itemIdExpanded: $itemIdExpanded)
                .redacted(reason: isLoading ? .placeholder : .privacy)
                .shimmering(active: isLoading)
            }
        }
    }
}

#Preview {
    List {
        RepositoryButtonView(item: .placeholder)
        RepositoryButtonView(isLoading: true, item: .placeholder)
    }
}

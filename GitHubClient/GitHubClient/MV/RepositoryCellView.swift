//
//  RepositoryCellView.swift
//  GitHubClient
//
//  Created by fox on 23/04/2024.
//

import SwiftUI

struct RepositoryCellView: View {
    let item: RepositoryViewModel
    @Binding var itemIdExpanded: UUID?
    
    var body: some View {
        HStack(alignment: .top) {
            CellImageView(urlString: item.urlString)
            VStack(alignment: .leading, spacing: 10) {
                CellTextView(title: item.title, subTitle: item.subTitle)
                if item.id == itemIdExpanded {
                    CellDetailView(detail: item.detail, language: item.language, stars: item.stars)
                        .padding(.top, 20)
                }
            }
        }
    }
}

private struct CellTextView: View {
    var title: String
    var subTitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .foregroundColor(.primary)
                .font(.subheadline)
            Text(subTitle)
                .foregroundColor(.primary)
                .font(.headline)
        }
    }
}

private struct CellDetailView: View {
    var detail: String
    var language: String
    var stars: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text(detail)
                .foregroundColor(.primary)
                .font(.headline)
            HStack {
                HStack {
                    Label("", systemImage: "circle.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 8))
                        .padding(.top, -4)
                    Text(language)
                        .foregroundColor(.primary)
                        .font(.subheadline)
                        .padding(.leading, -25)
                }
                Spacer()
                HStack {
                    Label("", systemImage: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 8))
                        .padding(.top, -4)
                    Text(stars)
                        .foregroundColor(.primary)
                        .font(.subheadline)
                        .padding(.leading, -25)
                }
            }
        }
    }
}

private struct CellImageView: View {
    var urlString: String
    @Environment(\.displayScale) var scale
    private let size: CGFloat = 50

    var body: some View {
        AsyncImage(url: URL(string: urlString),
                   scale: 3) { phase in
            switch phase {
                case .empty:
                    ZStack {
                        Color.gray
                        ProgressView()
                    }
                case .success(let image):
                    image.resizable()
                case .failure(let error):
                    Text(error.localizedDescription)
                @unknown default:
                    EmptyView()
            }
        }
        .frame(width: size, height: size)
        .background(Color.gray.opacity(0.5))
        .clipShape(Circle())
    }
}

#Preview {
    struct BindingRepositoryCellViewNotExpanded : View {
        @State private var value: UUID? = UUID()
        
        var body: some View {
            RepositoryCellView(item: .placeholder, itemIdExpanded: $value)
        }
    }
    return BindingRepositoryCellViewNotExpanded()
}

#Preview {
    struct BindingRepositoryCellViewExpanded : View {
        @State private var value: UUID? = RepositoryViewModel.placeholder.id
        
        var body: some View {
            RepositoryCellView(item: .placeholder, itemIdExpanded: $value)
        }
    }
    return BindingRepositoryCellViewExpanded()
}

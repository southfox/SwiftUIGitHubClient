//
//  GitHubContentView.swift
//  GitHubClient
//
//  Created by fox on 20/04/2024.
//

import SwiftUI
import CoreData
import Shimmer

struct GitHubContentView: View {
    @State var isPreview: Bool = false
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.colorScheme) private var colorScheme: ColorScheme
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Repository.stars, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Repository>
    private let queue = DispatchQueue(label: "GitHubClientApp.GitHubContentView.sync")
    @State private var itemIdExpanded: String = ""
    @State private var isCacheEnabled = true
    @State private var isExpanded: Bool = false
    @State private var isLoading: Bool = false
    @State private var showSettingsAlert = false

    var body: some View {
        content
            .preferredColorScheme(colorScheme)
            .onAppear {
                isLoading = true
                refreshListAction()
            }
    }
    
    private var content: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    Button {
                        if itemIdExpanded == item.name {
                            itemIdExpanded = ""
                        } else {
                            itemIdExpanded = item.name ?? ""
                        }
                    } label: {
                        VStack(spacing: 10) {
                            CellView(title: item.name ?? "",
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
            .refreshable {
                refreshListAction()
            }
            .navigationBarTitle(Text("Trending"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showSettingsAlert = true
                    }) {
                        Label("", systemImage: "gearshape")
                    }
                }
            }
            .alert("Settings", isPresented: $showSettingsAlert) {
                Button("Cache is \(isCacheEnabled ? "ON" : "OFF")") {
                    isCacheEnabled = !isCacheEnabled
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Here you can change the following settings:")
            }
        }
    }

    private func refreshListAction() {
        queue.sync {
            self.isLoading = true
            Task {
                do {
                    try await NetworkController.requestRepositories(isPreview: isPreview)
                    self.isLoading = false
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    struct BindingGitHubContentView : View {
        var body: some View {
            GitHubContentView(isPreview: true)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
    return BindingGitHubContentView()
}

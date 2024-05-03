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
    @State var latestError: GitHubError = .none
    @State var isLoading: Bool = false
    @State var isPreview: Bool = false
    private(set) var networkController: NetworkController

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Repository.stars, ascending: false)],
        animation: .default
    ) private var items: FetchedResults<Repository>
    
    private var repositories: [RepositoryViewModel] {
        items.map({RepositoryViewModel(id: UUID(), item: $0)})
    }
    
    @State private var isCacheEnabled = true
    @State private var showSettingsAlert = false

    var body: some View {
        ZStack {
            content
            if (latestError == .none) == false {
                errorView
            }
        }
        .task {
            guard isPreview == false else { return }
            isLoading = true
            try? await refreshListAction()
        }
    }
    
    private var errorView: some View {
        ErrorAnimationView(error: latestError,
                           retryAction: {
            Task {
                try? await refreshListAction()
            }
        }, cancelAction: {
            if isCacheEnabled {
                isLoading = false
            }
            latestError = .none
        })
    }
    
    private var content: some View {
        navigation
            .preferredColorScheme(colorScheme)
            .onAppear {
                configureCache()
            }
    }
        
    private var navigation: some View {
        NavigationView {
            ZStack {
                if isLoading {
                    RepositoriesPlaceholderView(item: .placeholder)
                } else {
                    List {
                        ForEach(repositories) { item in
                            RepositoryButtonView(isLoading: isLoading, item: item)
                        }
                    }
                    .refreshable {
                        Task {
                            try? await refreshListAction()
                        }
                    }
                }
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
                    configureCache()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Here you can change the following settings:")
            }
        }
    }
    
    private func refreshListAction() async throws {
        latestError = .none
        isLoading = true
        do {
            try await networkController.requestCoreDataRepositoryResponse(isPreview: isPreview, isCacheEnabled: isCacheEnabled)
            isLoading = false
        } catch {
            latestError = error.githubError
        }
    }
    
    private var useCache: Bool {
        isCacheEnabled && items.isEmpty
    }
    
    private func configureCache() {
        guard isCacheEnabled else {
            URLSession.shared.configuration.requestCachePolicy = .useProtocolCachePolicy
            URLCache.shared.memoryCapacity = 512_000
            URLCache.shared.diskCapacity = 10_000_000
            return
        }
        URLSession.shared.configuration.requestCachePolicy = .returnCacheDataElseLoad
        URLCache.shared.memoryCapacity = 10_000_000 // ~10 MB memory space
        URLCache.shared.diskCapacity = 1_000_000_000 // ~1GB disk cache space
    }
}

#Preview("Success") {
    struct BindingGitHubContentView : View {
        var body: some View {
            GitHubContentView(isPreview: true, networkController: NetworkController(persistenceController:  PersistenceController.preview))
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
    return BindingGitHubContentView()
}

#Preview("Loading") {
    struct BindingGitHubContentView : View {
        var body: some View {
            GitHubContentView(isLoading: true, isPreview: true, networkController: NetworkController(persistenceController:  PersistenceController.preview))
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
    return BindingGitHubContentView()
}

#Preview("Fail") {
    struct BindingGitHubContentView : View {
        var body: some View {
            GitHubContentView(latestError: .unknown, isPreview: true, networkController: NetworkController(persistenceController:  PersistenceController.preview))
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
    return BindingGitHubContentView()
}

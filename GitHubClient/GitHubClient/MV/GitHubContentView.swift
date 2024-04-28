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
    @State var isError: Bool = false
    @State var isLoading: Bool = false
    @State var isPreview: Bool = false

    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.colorScheme) private var colorScheme: ColorScheme
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Repository.stars, ascending: false)],
        animation: .default
    ) private var items: FetchedResults<Repository>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Repository.stars, ascending: false)],
        animation: .default
    ) private var itemsInCache: FetchedResults<Repository2>
    @State private var isCacheEnabled = true
    @State private var showSettingsAlert = false

    var body: some View {
        ZStack {
            content
            if isError {
                errorView
            }
        }
        .task {
            isLoading = true
            try? await refreshListAction()
        }
    }
    
    private var errorView: some View {
        ErrorAnimationView(retryAction: {
            Task {
                try? await refreshListAction()
            }
        }, cancelAction: {
            if isCacheEnabled {
                isLoading = false
                try? Repository.retrieveCache()
            }
            isError.toggle()
        })
    }
    
    private var content: some View {
        navigation
            .preferredColorScheme(colorScheme)
            .onAppear {
                configureCache()
            }
    }
    
    private var useCache: Bool {
        isCacheEnabled && items.isEmpty
    }
    
    private func configureCache() {
        guard isCacheEnabled else {
            URLSession.shared.configuration.requestCachePolicy = .useProtocolCachePolicy
            URLCache.shared.memoryCapacity = 512000
            URLCache.shared.diskCapacity = 10000000
            return
        }
        URLSession.shared.configuration.requestCachePolicy = .returnCacheDataElseLoad
        URLCache.shared.memoryCapacity = 10_000_000 // ~10 MB memory space
        URLCache.shared.diskCapacity = 1_000_000_000 // ~1GB disk cache space
    }
        
    private var navigation: some View {
        NavigationView {
            List {
                if useCache {
                    ForEach(itemsInCache) { item in
                        RepositoryView(isLoading: isLoading, item: item)
                    }
                } else {
                    ForEach(items) { item in
                        RepositoryView(isLoading: isLoading, item: item)
                    }
                }
            }
            .refreshable {
                Task {
                    try? await refreshListAction()
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
        isError = false
        isLoading = true
        do {
            try await NetworkController.requestRepositories(isPreview: isPreview, isCacheEnabled: isCacheEnabled)
            isLoading = false
        } catch {
            isError = true
        }
    }
}

#Preview("Success") {
    struct BindingGitHubContentView : View {
        var body: some View {
            GitHubContentView(isPreview: true)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
    return BindingGitHubContentView()
}

#Preview("Loading") {
    struct BindingGitHubContentView : View {
        var body: some View {
            GitHubContentView(isLoading: true, isPreview: true)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
    return BindingGitHubContentView()
}

#Preview("Fail") {
    struct BindingGitHubContentView : View {
        var body: some View {
            GitHubContentView(isError: true, isPreview: true)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
    return BindingGitHubContentView()
}

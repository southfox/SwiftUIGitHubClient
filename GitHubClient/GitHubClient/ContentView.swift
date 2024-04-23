//
//  ContentView.swift
//  GitHubClient
//
//  Created by fox on 20/04/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Repository.stars, ascending: false)],
        animation: .default)
    
    private var items: FetchedResults<Repository>
    
    @State private var showSettingsAlert = false
    @State private var isCacheEnabled = false
    @State private var isDarkModeEnbled = false
    @State private var isExpanded: Bool = false
    @State var itemIdExpanded: String

    var body: some View {
        content
            .preferredColorScheme(isDarkModeEnbled ? .dark : .light)
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
                Button("Dark Mode is \(isDarkModeEnbled ? "ON" : "OFF")") {
                    isDarkModeEnbled = !isDarkModeEnbled
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Please change settings.")
            }
        }
    }

    private func refreshListAction() {
        withAnimation {
            /// TODO: do the api call
            Repository.reload()
        }
    }
}

#Preview {
    struct BindingContentView : View {
        @State private var value = ""
        var body: some View {
            ContentView(itemIdExpanded: value).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
    return BindingContentView()
}

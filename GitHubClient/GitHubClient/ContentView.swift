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

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Repository at \(item.name!)")
                    } label: {
                        Text(item.name!)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: refreshList) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func refreshList() {
        withAnimation {
            //            let newItem = Repository(context: viewContext)
            //            newItem.timestamp = Date()
            //
            //            do {
            //                try viewContext.save()
            //            } catch {
            //                // Replace this implementation with code to handle the error appropriately.
            //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //                let nsError = error as NSError
            //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            // }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

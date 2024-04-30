//
//  GitHubClientApp.swift
//  GitHubClient
//
//  Created by fox on 20/04/2024.
//

import SwiftUI

@main
struct GitHubClientApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            GitHubContentView(networkController: NetworkController(persistenceController: persistenceController))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

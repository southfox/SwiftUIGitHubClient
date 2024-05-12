//
//  GitHubClientApp.swift
//  GitHubClient
//
//  Created by fox on 20/04/2024.
//

import CoreData
import SwiftUI

@main
struct GitHubClientApp: App {
    var persistenceController: PersistenceController {
        PersistenceController.shared
    }
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    var container: NSPersistentContainer {
        persistenceController.container
    }
    var networkController: NetworkController {
        NetworkController(persistenceController: persistenceController)
    }

    var body: some Scene {
        WindowGroup {
            GitHubContentView(networkController: networkController)
                .environment(\.managedObjectContext, viewContext)
                .task {
                    print("hi")
                }
        }
    }
}

//
//  PersistenceController.swift
//  GitHubClient
//
//  Created by fox on 20/04/2024.
//

import CoreData
import SwiftUI

struct PersistenceController {
    
    static var shared = ProcessInfo.isRunningUnitTests ? memory : db

    /// Test persistence using a sqlite file
    static var db = PersistenceController()

    /// Test persistence in memory only
    static var memory = PersistenceController(inMemory: true)

    /// Preview persistence for Swift UI Preview, in memory only
    static var preview: PersistenceController = {
        
        guard let jsonData = "GitHubRepositoryResponse".data else {
            fatalError("Unresolved error invalidDecode")
        }
        do {
            // No need to treat the response, will be in coredata anyway
            _ = try memory.jsonDecoder.decode(RepositoryResponse.self, from: jsonData)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return memory
    }()
    
    /// Special json decoder for CoreData entities
    public lazy var jsonDecoder: JSONDecoder = {
        JSONDecoder()
    }()

    let container: NSPersistentContainer
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!

    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "GitHubClient")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        if jsonDecoder.userInfo[Self.managedObjectContext] == nil {
            jsonDecoder.userInfo[Self.managedObjectContext] = container.viewContext
        }
    }
}


//
//  PersistenceController.swift
//  GitHubClient
//
//  Created by fox on 20/04/2024.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    /// Test persistence in memory only
    static var test: PersistenceController {
        PersistenceController(inMemory: true)
    }

    /// Preview persistence for Swift UI Preview, in memory only
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<10 {
            let repository = Repository(context: viewContext)
            repository.brief = "The #\(i) programming language"
            repository.fullName = "some/#\(i)"
            repository.icon = i % 2 == 0 ? "https://avatars.githubusercontent.com/u/4314092?v=4" : "https://avatars.githubusercontent.com/u/1507452?v=4"
            repository.language = "L#\(i)"
            repository.name = "l#\(i)"
            repository.stars = Int32(arc4random() % 1000)
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    /// Special json decoder for CoreData entities
    public lazy var jsonDecoder: JSONDecoder = {
        JSONDecoder()
    }()

    let container: NSPersistentContainer
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!

    init(inMemory: Bool = false) {
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

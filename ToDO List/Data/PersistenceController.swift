//
//  PersistenceController.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 16.08.25.
//

import Foundation
internal import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
// in this app we will use on-disk SQLite / default storage
//    init(inMemory: Bool = false) {
    private init() { 
        container = NSPersistentContainer(name: "ToDO_List")
//        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
//        }
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    
    // TODO: use when user logs out or app build changes?
    static func clearDatabase() {
        // Get the URL of the SQLite store
        guard let storeURL = PersistenceController.shared.container.persistentStoreDescriptions.first?.url else {
            return
        }
        
        let coordinator = PersistenceController.shared.container.persistentStoreCoordinator
        
        do {
            // Remove the persistent store from the coordinator
            if let store = coordinator.persistentStore(for: storeURL) {
                try coordinator.remove(store)
            }
            
            // Delete the SQLite file (and its -shm and -wal files)
            let fileManager = FileManager.default
            let shmSidecar = storeURL.appendingPathExtension("-shm")
            let walSidecar = storeURL.appendingPathExtension("-wal")
            
            try fileManager.removeItem(at: storeURL)
            try? fileManager.removeItem(at: shmSidecar)
            try? fileManager.removeItem(at: walSidecar)
            
            // Re-add a fresh store
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: storeURL,
                                               options: nil)
            
            print("Database cleared successfully!")
        } catch {
            print("Failed to clear database: \(error)")
        }
    }
}

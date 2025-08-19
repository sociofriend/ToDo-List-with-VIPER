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

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ToDO_List")
        let description = container.persistentStoreDescriptions.first
        description?.shouldMigrateStoreAutomatically = true
        description?.shouldInferMappingModelAutomatically = true
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}

//
//  DataImporter.swift
//  LearnCoreData
//
//  Created by Lilit Avdalyan on 16.08.25.
//


// DataImporter.swift
import Foundation
internal import CoreData

struct DataImporter<Task: TodoProtocol, Response: ResponseProtocol> where Response.Task == Task {
    
    static func importJSON(context: NSManagedObjectContext) async throws {
        guard let url = Bundle.main.url(forResource: "todos", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let response = try? JSONDecoder().decode(Response.self, from: data) else {
            print("url not found")
            return
        }
        
        for task in response.todos {
            // Check if entity exists (by ID for example)
            let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)
            fetchRequest.fetchLimit = 1
            
            let existing = try? context.fetch(fetchRequest).first
            
            let entity: ToDoEntity
            if let existing = existing {
                // Update existing entity
                entity = existing
            } else {
                // Insert new entity
                entity = ToDoEntity(context: context)
            }
            
            // Update fields
            entity.id = task.id
            entity.todo = task.todo
            entity.title = task.title
            entity.completed = task.completed
            entity.userId = task.userId
            entity.date = task.date
        }
        
        do {
            try context.save()
        } catch {
            print("❌ Failed to save: \(error)")
        }
    }
} 

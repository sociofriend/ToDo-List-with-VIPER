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
        
        // check if there is a data in container, don't import 
        let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        fetchRequest.fetchLimit = 1
        if  (try? context.fetch(fetchRequest).first) != nil {
            return }
        
        
        let response = try await Client<Response>.fetchResponse()
        
        for task in response.todos {
            // Check if entity exists (by ID for example)
            let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)
            fetchRequest.fetchLimit = 1
            
            if  (try? context.fetch(fetchRequest).first) != nil {
                return 
            } else {
                // Insert new entity
                let entity: ToDoEntity = ToDoEntity(context: context)
                
                // Update fields
                entity.id = task.id
                entity.title = task.title
                entity.todo = task.todo
                entity.completed = task.completed
                entity.userId = task.userId
                entity.date = task.date
            }
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to fetch from API: \(error)")
            return
        }
    }
} 

//
//  DataImporter.swift
//  LearnCoreData
//
//  Created by Lilit Avdalyan on 16.08.25.
//


// DataImporter.swift
import Foundation
internal import CoreData

struct DataImporter<Task: TodoProtocol, response: ResponseProtocol> {
    static func importJSON(context: NSManagedObjectContext) {
        guard let url = Bundle.main.url(forResource: "todos", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let response = try? JSONDecoder().decode(response.self, from: data) else {
            return
        }
        
        
        for task in response.todos {
            let entity = ToDoEntity(context: context)
            entity.id = task.id
            entity.todo = task.todo
            entity.completed = task.completed
            entity.userId = task.userId
        }

        do {
            try context.save()
        } catch {
            //TODO: implement error handling
            print("Failed to save: \(error)")
        }
    }
}


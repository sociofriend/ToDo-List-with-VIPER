//
//  TaskListInteractorProtocol.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 15.08.25.
//

import SwiftUI
internal import CoreData

protocol TaskListInteractorProtocol: AnyObject {
    associatedtype ToDo where ToDo: TodoProtocol
    associatedtype Response where Response: ResponseProtocol
    func fetchItems()
}

final class TaskListInteractor<ToDo, Response>: TaskListInteractorProtocol
where ToDo: TodoProtocol, Response: ResponseProtocol {
    
    typealias ToDo = ToDo
    typealias Response = Response
    
    var presenter: TaskListPresenter<ToDo, Response>?
    
    // Reference to Core Data
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    
    func fetchItems() {
        Task {
            do {
                // Perform fetch in background queue
                if let tasks = try await fetchTasksFromCoreData() as? [ToDo] {
                    
                    // Send tasks back to presenter on main thread
                    DispatchQueue.main.async {
                        self.presenter?.didFetchTasks(tasks)
                    }
                }
            } catch {
                print("Failed to fetch tasks from Core Data: \(error)")
            }
        }
    }
    
    func add(item: ToDo) {
        Task {
            do {
                try await self.addItemToCoreData(item: item)
            } catch {
                print("Failed to add item to Core Data: \(error)")
            }
        }
    }
    
    func removeItem(with id: Int) {
        Task {
            do {
                try await self.removeItemFromCoreData(id: Int64(id))
            } catch {
                print("Failed to remove item from Core Data: \(error)")
            }
        }
    }
    
    func update(_ item: ToDo) {
        Task {
            do {
                try await self.updateItemInCoreData(item: item)
            } catch {
                print("Failed to update item in Core Data: \(error)")
            }
        }
    }
    
    
    
    // MARK: - Core Data Fetch
    private func fetchTasksFromCoreData() async throws -> [TodoDTO] {
        try await context.perform {
            let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
            let entities = try self.context.fetch(fetchRequest)
            return entities.compactMap { entity in
                guard let todoValue = entity.todo else { return nil }
                let id = entity.id
                return TodoDTO(
                    id: id,
                    title: entity.title ?? "",
                    todo: todoValue,
                    completed: entity.completed,
                    userId: entity.userId,
                    date: entity.date
                )
            }
        }
    }
    
    private func addItemToCoreData(item: ToDo) async throws {
        try await context.perform {
            let entity = ToDoEntity(context: self.context)
            entity.id = item.id
            entity.todo = item.todo
            entity.title = item.title
            entity.completed = item.completed
            entity.userId = item.userId
            entity.date = item.date
            try self.context.save()
        }
    }
    
    private func removeItemFromCoreData(id: Int64) async throws {
        try await context.perform {
            let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %lld", id)
            let entities = try self.context.fetch(fetchRequest)
            for entity in entities {
                self.context.delete(entity)
            }
            try self.context.save()
        }
    }
    
    private func updateItemInCoreData(item: ToDo) async throws {
        try await context.perform {
            let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %lld", item.id)
            let entities = try self.context.fetch(fetchRequest)
            if let entity = entities.first {
                entity.title = item.title
                entity.todo = item.todo
                entity.completed = item.completed
                entity.userId = item.userId
                entity.date = item.date
                try self.context.save()
            }
        }
    }
}

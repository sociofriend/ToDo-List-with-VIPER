//
//  TaskListInteractorProtocol.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 15.08.25.
//

import SwiftUI
internal import CoreData

protocol TaskListInteractorProtocol: AnyObject {
    associatedtype ToDo: TodoProtocol
    associatedtype TaskModel: TodoPresentationProtocol
    associatedtype Response: ResponseProtocol
    
    //crud
    func add(item: ToDo)
    func fetchItems()
    func update(_ item: ToDo)
    func removeItem(with id: Int)
}

final class TaskListInteractor<ToDo, TaskModel, Response>: TaskListInteractorProtocol
where ToDo: TodoProtocol,
      TaskModel: TodoPresentationProtocol,
      Response: ResponseProtocol {
    
    // Presenter
    weak var presenter: TaskListPresenter<ToDo, TaskModel, Response>?
    var isLoaded: Bool = false {
        didSet {
            if isLoaded == true {
                fetchItems()
            }
        }
    }
    
    // Reference to Core Data
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
        
        Task {
            do {
                try await DataImporter<TodoDTO, ResponseDTO>.importJSON(context: context)
                DispatchQueue.main.async {
                    self.isLoaded = true
                }
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - Public Methods
    
    func add(item: ToDo) {
        Task {
            do {
                try await addItemToCoreData(item: item)
            } catch {
                print("❌ Failed to add item: \(error)")
            }
        }
    }
    
    func fetchItems() {
        Task {
            do {
                let tasks = try await fetchTasksFromCoreData()
                
                // Convert DTO -> Presentation model
                let presentationTasks = tasks.map { TaskModel(task: $0) }
                
                DispatchQueue.main.async {
                    self.presenter?.didFetchTasks(presentationTasks)
                }
            } catch {
                print("❌ Failed to fetch tasks from Core Data: \(error)")
            }
        }
    }

    func update(_ item: ToDo) {
        Task {
            do {
                try await updateItemInCoreData(item: item)
            } catch {
                print("❌ Failed to update item: \(error)")
            }
        }
    }
    
    func removeItem(with id: Int) {
        Task {
            do {
                try await removeItemFromCoreData(id: Int64(id))
            } catch {
                print("❌ Failed to remove item: \(error)")
            }
        }
    }
    
    // MARK: - Core Data Helpers
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
    
    private func fetchTasksFromCoreData() async throws -> [TodoDTO] {
        try await context.perform {
            let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
            let entities = try self.context.fetch(fetchRequest)
            return entities.compactMap { entity in
                return TodoDTO(
                    id: entity.id,
                    title: entity.title,
                    todo: entity.todo ?? "",
                    completed: entity.completed,
                    userId: entity.userId,
                    date: entity.date
                )
            }
        }
    }
    
    private func updateItemInCoreData(item: ToDo) async throws {
        try await context.perform {
            let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %lld", item.id)
            if let entity = try self.context.fetch(fetchRequest).first {
                entity.title = item.title
                entity.todo = item.todo
                entity.completed = item.completed
                entity.userId = item.userId
                entity.date = item.date
                try self.context.save()
            }
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
}

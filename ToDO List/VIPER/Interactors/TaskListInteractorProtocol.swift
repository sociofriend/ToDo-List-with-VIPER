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
    func fetchTasks()
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
    
    func fetchTasks() {
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
}


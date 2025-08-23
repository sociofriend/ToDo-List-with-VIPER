//
//  TaskListPresenterProtocol.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 15.08.25.
//

import SwiftUI
import Combine

protocol TaskListPresenterProtocol: ObservableObject {
    associatedtype Task where Task: TodoProtocol
    associatedtype TaskModel where TaskModel: TodoPresentationProtocol
    var tasks: [TaskModel] { get set }
    func loadTasks()
    func didFetchTasks(_ tasks: [TaskModel])
    func checkboxToggled(for id: Int)
    func update(_ task: Task)
    func addItem(id: Int, title: String, todo: String, completed: Bool, userID: Int, date: Date)
    func remove(at id: Int)
}

final class TaskListPresenter<Task, TaskModel, Response>: ObservableObject, TaskListPresenterProtocol where Task: TodoProtocol, TaskModel: TodoPresentationProtocol, Response: ResponseProtocol {
    
    @Published var tasks: [TaskModel] = []
    var interactor: any TaskListInteractorProtocol
    var router: (any TaskListRouterProtocol)?
    
    init(interactor: any TaskListInteractorProtocol, router: TaskListRouter<Task, TaskModel, Response>? = nil) {
        self.interactor = interactor
    }
    
    // Computed property for filtered and sorted tasks based on search text
    func filteredTasks(searchText: String) -> [TaskModel] {
        let filtered = searchText.isEmpty ? tasks : tasks.filter { task in
            task.title.lowercased().contains(searchText.lowercased()) ||
            task.todo.lowercased().contains(searchText.lowercased())
        }
        return filtered.sorted { $0.date > $1.date }
    }
    
    // Add or update task based on optional ID (for edit or create)
    func addOrUpdateItem(id: Int?, title: String, todo: String, completed: Bool, userID: Int, date: Date) {
        if let id = id, let index = tasks.firstIndex(where: { $0.id == id }) {
            // Update existing
            var taskModel = tasks[index]
            taskModel.title = title
            taskModel.todo = todo
            taskModel.completed = completed
            taskModel.userId = userID
            taskModel.date = date
            tasks[index] = taskModel
            update(Task(taskModel))
        } else {
            // Add new
            addItem(id: id ?? 0, title: title, todo: todo, completed: completed, userID: userID, date: date)
        }
    }
}

// functions for external usage
// for interactor
extension TaskListPresenter {
    func didFetchTasks(_ tasks: [TaskModel]) {
        self.tasks = tasks
    }
}

//crud
extension TaskListPresenter {
    // create
    func addItem(id: Int, title: String, todo: String, completed: Bool, userID: Int, date: Date) {
        // guard item with given id does not exist in db
        let newTask = Task(id: Int64(id), title: title, todo: todo, completed: completed, userId: Int64(userID), date: date)
        if let interactor = interactor as? TaskListInteractor<Task, TaskModel, Response> {
            interactor.add(item: newTask)
        }
    }
    
    //read
    func loadTasks() {
        interactor.fetchItems()
    }
    
    //update
    func checkboxToggled(for id: Int) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        var task = tasks[index]
        task.completed.toggle()
        tasks[index] = task
        update(Task(task))
    }
    
    func update(_ task: Task) {
        if let interactor = interactor as? TaskListInteractor<Task, TaskModel, Response> {
            interactor.update(task)
        }
    }
    
    private func update(_ task: TaskModel) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index] = task
        update(Task(task))
    }
    
    //delete
    func remove(at id: Int) {
        if let interactor = interactor as? TaskListInteractor<Task, TaskModel, Response> {
            interactor.removeItem(with: id)
            tasks.removeAll(where: { $0.id == id})
        }
    }
}

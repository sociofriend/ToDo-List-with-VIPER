//
//  TaskListPresenterProtocol.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 15.08.25.
//

import SwiftUI
import Combine

final class TaskListPresenter<Task, TaskModel, Response>: ObservableObject where Task: TodoProtocol, TaskModel: TodoPresentationProtocol, Response: ResponseProtocol {
    
    @Published var tasks: [TaskModel] = [] {
        didSet {
            filteredTasks = filteredTasks(searchText: searchInput)
        }
    }
    
    var interactor: any TaskListInteractorProtocol
    var router: (any TaskListRouterProtocol)?
    @Published var searchInput: String = "" {
        didSet {
            filteredTasks = filteredTasks(searchText: searchInput)
        }
    }
    @Published var selectedTaskId: Int? = nil
    
    @Published var filteredTasks: [TaskModel] = []
    
    /// Returns a new unique id, one greater than the current highest task id (or 1 if none exist)
    var newId: Int {
        (tasks.map { $0.id }.max() ?? 0) + 1
    }
    
    init(interactor: any TaskListInteractorProtocol, router: TaskListRouter<Task, TaskModel, Response>? = nil) {
        self.interactor = interactor
    }
    
    // Computed property for filtered and sorted tasks based on search text
    func filteredTasks(searchText: String) -> [TaskModel] {
        let filtered = searchText.isEmpty ? tasks : tasks.filter { task in
            task.title.lowercased().contains(searchText.lowercased()) ||
            task.todo.lowercased().contains(searchText.lowercased())
        }
        return filtered.sorted { $0.id > $1.id }
    }
    
    // Add or update task based on optional ID (for edit or create)
    func addOrUpdateItem(id: Int?, title: String, todo: String, completed: Bool, userID: Int, date: Date) {
        if let id = id, let index = tasks.firstIndex(where: { $0.id == id }) {
            if shouldUpdateTask(&tasks[index], title: title, todo: todo, completed: completed, userID: userID, date: date) {
                update(tasks[index])
            }
        } else {
            // Given that id is of Int type
            addItem(id: tasks.count + 1, title: title, todo: todo, completed: completed, userID: userID, date: date)
        }
    }
    
    private func shouldUpdateTask(_ task: inout TaskModel, title: String, todo: String, completed: Bool, userID: Int, date: Date) -> Bool {
        let originalTask = task
        task.title = title
        task.todo = todo
        task.completed = completed
        task.userId = userID
        task.date = date
        // Only update if something besides id and date has changed
        return originalTask.title != task.title ||
               originalTask.todo != task.todo ||
               originalTask.completed != task.completed ||
               originalTask.userId != task.userId
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


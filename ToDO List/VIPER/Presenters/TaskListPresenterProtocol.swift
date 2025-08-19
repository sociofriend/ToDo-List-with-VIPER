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
    func updateTitle(for id: Int, with newTitle: String)
    func updateTodo(for id: Int, with newTodo: String)
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

    func loadTasks() {
        interactor.fetchItems()
    }

    func didFetchTasks(_ tasks: [TaskModel]) {
        self.tasks = tasks
    }
    
    func remove(at id: Int) {
        if let interactor = interactor as? TaskListInteractor<Task, TaskModel, Response> {
            interactor.removeItem(with: id)
            tasks.removeAll(where: { $0.id == id})
        }
    }

    func checkboxToggled(for id: Int) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        var task = tasks[index]
        task.completed.toggle()
        tasks[index] = task
        update(Task(task))
    }
    
    func updateTitle(for id: Int, with newTitle: String) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        var task = tasks[index]
        task.title = newTitle
        task.date = Date()
        tasks[index] = task
        update(Task(task))
    }
    
    
    func updateTodo(for id: Int, with newTodo: String) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        var task = tasks[index]
        task.todo = newTodo
        task.date = Date()
        tasks[index] = task
        update(Task(task))
    }
    
    private func update(_ task: Task) {
        if let interactor = interactor as? TaskListInteractor<Task, TaskModel, Response> {
            interactor.update(task)
        }
    }
    
    func addItem(id: Int, title: String, todo: String, completed: Bool, userID: Int, date: Date) {
        // guard item with given id does not exist in db
        let newTask = Task(id: Int64(id), title: title, todo: todo, completed: completed, userId: Int64(userID), date: date)
        if let interactor = interactor as? TaskListInteractor<Task, TaskModel, Response> {
            interactor.add(item: newTask)
        }
    }
}

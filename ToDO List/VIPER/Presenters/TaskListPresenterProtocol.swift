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
    var tasks: [Task] { get set }
    func loadTasks()
    func didFetchTasks(_ tasks: [Task])
}


final class TaskListPresenter<Task, Response>: ObservableObject, TaskListPresenterProtocol where Task: TodoProtocol, Response: ResponseProtocol {
    @Environment(\.managedObjectContext) private var context

    @Published var tasks: [Task] = []
    var interactor: any TaskListInteractorProtocol
    var router: (any TaskListRouterProtocol)?

    init(interactor: any TaskListInteractorProtocol, router: TaskListRouter<Task, Response>? = nil) {
        self.interactor = interactor
    }

    func loadTasks() {
        interactor.fetchTasks()
    }

    func didFetchTasks(_ tasks: [Task]) {
        self.tasks = tasks
    }
}

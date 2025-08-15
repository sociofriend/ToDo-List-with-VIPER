//
//  TaskListRouter.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 15.08.25.
//

import SwiftUI

protocol TaskListRouterProtocol {
    associatedtype TaskListViewType: View
    static func createModule() -> TaskListViewType
}

class TaskListRouter<Task, Response>: TaskListRouterProtocol where Task: TodoProtocol, Response: ResponseProtocol {
    static func createModule() -> some View {
        let interactor = TaskListInteractor<Task, Response>()
        let presenter = TaskListPresenter<Task, Response>(interactor: interactor)
        interactor.presenter = presenter
        return TaskListView<Task, Response>(presenter: presenter)
    }
}

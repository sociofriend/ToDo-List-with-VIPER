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

final class TaskListRouter<Task, TaskModel, Response>: TaskListRouterProtocol where Task: TodoProtocol, TaskModel: TodoPresentationProtocol, Response: ResponseProtocol {
    
    static func createModule() -> some View {
        let interactor = TaskListInteractor<Task, TaskModel, Response>()
        let presenter = TaskListPresenter<Task, TaskModel, Response>(interactor: interactor)
        interactor.presenter = presenter
        return TaskListView<Task, TaskModel, Response>(presenter: presenter)
    }
}

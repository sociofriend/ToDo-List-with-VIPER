//
//  TaskListInteractorProtocol.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 15.08.25.
//
import SwiftUI

protocol TaskListInteractorProtocol: AnyObject {
    associatedtype ToDo where ToDo: TodoProtocol
    associatedtype Response where Response: ResponseProtocol
    func fetchTasks()
}

final class TaskListInteractor<ToDo, Response>: TaskListInteractorProtocol where ToDo: TodoProtocol, Response: ResponseProtocol {    
    
    typealias ToDo = ToDo
    typealias Response = Response
    
    var presenter: TaskListPresenter<ToDo, Response>?
    
    func fetchTasks() {
        Task {
            do {
                let tasks: [ToDo] = try await Client<Response>.fetchResponse().todos as! [ToDo]
                DispatchQueue.main.async {
                    self.presenter?.didFetchTasks(tasks)
                }
            } catch {
                //TODO: handle error
                print(error)
            }
        }
    } 
}



//
//  TodoPresentationProtocol.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 19.08.25.
//

import Foundation

protocol TodoPresentationProtocol: Codable, Identifiable, Hashable {
    var id: Int { get set}
    var title: String { get set }
    var todo: String { get set }
    var completed: Bool { get set }
    var userId: Int { get set }
    var date: Date { get set }
    
    init(task: any TodoProtocol)
}

struct TodoPresentationModel: TodoPresentationProtocol {
    
    var id: Int
    var title: String
    var todo: String
    var completed: Bool
    var userId: Int
    var date: Date
    
    init(task: any TodoProtocol) {
        self.id = Int(task.id)
        self.title = task.title ?? ""
        self.todo = task.todo
        self.completed = task.completed
        self.userId = Int(task.userId)
        self.date = task.date ?? Date()
    }
}


//
//  TodoDTO.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 16.08.25.
//


import Foundation

protocol TodoProtocol: Codable, Identifiable, Hashable {
    var id: Int64 { get set }
    var title: String { get set }
    var todo: String { get set }
    var completed: Bool { get set }
    var userId: Int64 { get set }
    var date: Date { get set }

    init(id: Int64, title: String?, todo: String, completed: Bool, userId: Int64, date: Date?)
    
    init(_ presentationTask: any TodoPresentationProtocol)
}

struct TodoDTO: TodoProtocol {
    
    var id: Int64
    var title: String
    var todo: String
    var completed: Bool
    var userId: Int64
    var date: Date
    
    init(id: Int64, title: String? = nil, todo: String, completed: Bool, userId: Int64, date: Date? = nil) {
        self.id = id
        self.title = title ?? "sample title"
        self.todo = todo
        self.completed = completed
        self.userId = userId
        self.date = Date()
    }
    
    init(_ presentationTask: any TodoPresentationProtocol) {
        self.id = Int64(presentationTask.id)
        self.title = presentationTask.title
        self.todo = presentationTask.todo
        self.completed = presentationTask.completed
        self.userId = Int64(presentationTask.userId)
        self.date = presentationTask.date
    }
}


//
//  TodoDTO.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 16.08.25.
//


import Foundation

protocol TodoProtocol: Codable, Identifiable, Hashable {
    var id: Int64 { get }
    var title: String? { get }
    var todo: String { get }
    var completed: Bool { get }
    var userId: Int64 { get }
    var date: Date? { get }

    init(id: Int64, title: String?, todo: String, completed: Bool, userId: Int64, date: Date?)
}

struct TodoDTO: TodoProtocol {
    
    let id: Int64
    var title: String? = nil
    let todo: String
    let completed: Bool
    let userId: Int64
    var date: Date? = nil
    
    init(id: Int64, title: String? = nil, todo: String, completed: Bool, userId: Int64, date: Date? = nil) {
        self.id = id
        self.title = title
        self.todo = todo
        self.completed = completed
        self.userId = userId
        self.date = date
    }
}


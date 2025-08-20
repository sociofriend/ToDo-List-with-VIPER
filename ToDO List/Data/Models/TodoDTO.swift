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
    
    enum CodingKeys: String, CodingKey {
        case id
        case todo
        case completed
        case userId
    }
    
    init(id: Int64, title: String? = nil, todo: String, completed: Bool, userId: Int64, date: Date? = nil) {
        self.id = id
        self.title = title ?? ""
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.todo = try container.decode(String.self, forKey: .todo)
        self.completed = try container.decode(Bool.self, forKey: .completed)
        self.userId = try container.decode(Int64.self, forKey: .userId)
        self.title = ""
        self.date = Date()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(todo, forKey: .todo)
        try container.encode(completed, forKey: .completed)
        try container.encode(userId, forKey: .userId)
    }
}


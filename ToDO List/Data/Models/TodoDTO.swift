//
//  TodoDTO.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 16.08.25.
//

import Foundation

protocol TodoProtocol: Identifiable, Hashable, Decodable {
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
        case title
        case todo
        case completed
        case userId
        case date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        todo = try container.decode(String.self, forKey: .todo)
        completed = try container.decode(Bool.self, forKey: .completed)
        userId = try container.decode(Int64.self, forKey: .userId)
        date = try container.decodeIfPresent(Date.self, forKey: .date) ?? Date()
    }
    
    init(id: Int64, title: String? , todo: String, completed: Bool, userId: Int64, date: Date? = nil) {
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
}

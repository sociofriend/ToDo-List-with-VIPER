//
//  Welcome.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 15.08.25.
//


import Foundation


protocol ResponseProtocol: Decodable {
    associatedtype Task: TodoProtocol
    var todos: [Task] { get set }
    var total: Int { get set }
    var skip: Int { get set }
    var limit: Int { get set }
}

// MARK: - Welcome
struct ResponseDTO: ResponseProtocol {
    var todos: [TodoDTO]
    var total, skip, limit: Int
}

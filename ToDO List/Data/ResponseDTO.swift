//
//  Welcome.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 15.08.25.
//


import Foundation


protocol ResponseProtocol: Codable {
    associatedtype Task: TodoProtocol
    var todos: [Task] { get }
    var total: Int { get }
    var skip: Int { get }
    var limit: Int { get }
}

// MARK: - Welcome
struct ResponseDTO: ResponseProtocol {
    let todos: [TodoDTO]
    let total, skip, limit: Int
}

//
//  TodoDTO.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 16.08.25.
//


import Foundation

protocol TodoProtocol: Codable, Identifiable {
    var id: Int { get }
    var todo: String { get }
    var description: String? { get }
    var completed: Bool { get }
    var userId: Int { get }
    var date: Date? { get }
}

struct TodoDTO: TodoProtocol {
    let id: Int
    let todo: String
    var description: String? = nil
    let completed: Bool
    let userId: Int
    var date: Date? = nil
}

//
//  TodoDTO.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 16.08.25.
//


import Foundation

protocol TodoProtocol: Codable, Identifiable, Hashable {
    var id: Int { get }
    var title: String? { get }
    var todo: String { get }
    var completed: Bool { get }
    var userId: Int { get }
    var date: Date? { get }
}

struct TodoDTO: TodoProtocol {
    let id: Int
    var title: String? = nil
    let todo: String
    let completed: Bool
    let userId: Int
    var date: Date? = nil
}

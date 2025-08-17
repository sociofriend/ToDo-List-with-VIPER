//
//  APIClient.swift
//  ToDo List
//
//  Created by Lilit Avdalyan on 12.08.25.
//

import Foundation

protocol APIClientProtocol {
    associatedtype ResponseDTO: ResponseProtocol
    func fetchResponse() async throws -> ResponseDTO
}

final class Client<ResponseDTO: ResponseProtocol> {
    
    static func fetchResponse() async throws -> ResponseDTO {
        //TODO: elaborate on error handling
        guard let url = Bundle.main.url(forResource: "tasks", withExtension: "json") else {
            throw NSError(domain: "APIClient", code: 404, userInfo: [NSLocalizedDescriptionKey: "todos.json not found in bundle"])
        }
        
        let data = try Data(contentsOf: url)
        
        let decoder = JSONDecoder()
        let todos = try decoder.decode(ResponseDTO.self, from: data)
        
        return todos
    }
} 



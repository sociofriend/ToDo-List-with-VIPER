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
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            throw NSError(domain: "APIClient", code: 404, userInfo: [NSLocalizedDescriptionKey: "Endpoint URL is invalid"])
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let todos = try decoder.decode(ResponseDTO.self, from: data)
        return todos
    }
} 

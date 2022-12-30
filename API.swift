//
//  API.swift
//  kidsnote
//
//  Created by Steven Jiang on 2022/12/30.
//

import Foundation

actor API {
    
    enum APIError: Error {
        case invalidServerResponse
        case invalidDataType
    }
    
    public func request<T>(_ url: URL) async throws -> T {
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidServerResponse
        }
        guard let result = data as? T else {
            throw APIError.invalidDataType
        }
        return result
    }
}

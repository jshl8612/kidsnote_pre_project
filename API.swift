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
        case invalidJSONType(Error)
    }
    
    private let apiKey = "AIzaSyBDANV5duP8FE9r-PxOoUPGRylAmXv9guo"
    
    public func request<T: Decodable>(type: T.Type, url: URL) async throws -> T {

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidServerResponse
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        }
        catch {
            throw APIError.invalidJSONType(error)
        }
    }
}

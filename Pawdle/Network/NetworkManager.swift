//
//  NetworkManager.swift
//  Pawdle
//
//  Created by Edward Downhill on 24/06/2025.
//

import Foundation
import Combine

// MARK: - Network Error
enum NetworkError: Error, LocalizedError {
    case noData
    case decodingError
    case serverError(Int)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .serverError(let code):
            return "Server error with code: \(code)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

// MARK: - HTTP Method
enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

// MARK: - Network Manager
struct NetworkManager {
    private let session: URLSession
    
    init() {
//        let config = URLSessionConfiguration.default
//        config.timeoutIntervalForRequest = 30
//        config.timeoutIntervalForResource = 60
//        self.session = URLSession(configuration: config)
        self.session = URLSession.shared
    }
    
    func request<T: Codable>(
        endpoint: URL,
        method: HTTPMethod = .GET,
        body: Data? = nil,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        var request = URLRequest(url: endpoint)
        request.httpMethod = method.rawValue
        
        if let body {
            request.httpBody = body
        }
        
        // Default headers
        switch method {
        case .POST, .PUT, .PATCH:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
        default:
            break
        }
        
        // Add custom headers
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.networkError(URLError(.badServerResponse))
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            
            guard !data.isEmpty else {
                throw NetworkError.noData
            }
            
            do {
                let decodedData = try JSONDecoder().decode(responseType, from: data)
                return decodedData
            } catch {
                throw NetworkError.decodingError
            }
            
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkError(error)
        }
    }
    
    // MARK: - Convenience Methods
    func get<T: Codable>(
        endpoint: URL,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        return try await request(
            endpoint: endpoint,
            method: .GET,
            headers: headers,
            responseType: responseType
        )
    }
    
    func post<T: Codable>(
        endpoint: URL,
        body: Data,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        return try await request(
            endpoint: endpoint,
            method: .POST,
            body: body,
            headers: headers,
            responseType: responseType
        )
    }
}

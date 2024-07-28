//
//  NetworkManager.swift
//  SymbolGlossary
//
//  Created by Matthew Auciello on 28/7/2024.
//

import Foundation
import Combine

// Defining the API Endpoint protocol
protocol APIEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: String] { get }
}

// Enum of HTTP Methods
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

// Enum of API Errors
enum APIError: Error {
    case invalidResponse
    case invalidData
    case invalidURL
}

enum SymbolGlossaryEndpoint: APIEndpoint {
    case getSymbol
    
    var baseURL: URL {
        return URL(string: "localhost")!
    }
    
    var path: String {
        switch self {
        case .getSymbol:
            return "/api/weather"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getSymbol:
            return .post
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getSymbol:
            return ["Authorization": "Default"]
        }
    }
    
    // Paramaters used in the endpoint
    var parameters: [String: String] {
        switch self {
        case .getSymbol:
            return ["H" : "H"]
        }
    }
}

protocol APIClient {
    associatedtype EndpointType: APIEndpoint
    func request<T: Decodable>(_ endpoint: EndpointType) throws -> AnyPublisher<T, Error>
}

class URLSessionAPIClient<EndpointType: APIEndpoint>: APIClient {
    
    func request<T: Decodable>(_ endpoint: EndpointType) throws -> AnyPublisher<T, Error> {
        
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = endpoint.parameters.map { URLQueryItem(name: $0.key, value: $0.key) }
        
        guard let finalURL = components.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = endpoint.method.rawValue
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.invalidResponse
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}

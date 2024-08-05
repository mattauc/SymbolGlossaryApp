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
        return URL(string: "http://127.0.0.1:5000")!
    }
    
    var path: String {
        switch self {
        case .getSymbol:
            return "/predict"
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
            return ["Content-Type": "multipart/form-data"]
        }
    }
    
    // Paramaters used in the endpoint
    var parameters: [String: String] {
        switch self {
        case .getSymbol:
            return [:]
        }
    }
}

protocol APIClient {
    associatedtype EndpointType: APIEndpoint
    func request<T: Decodable>(_ endpoint: EndpointType, imageData: Data) throws -> AnyPublisher<T, Error>
}

class URLSessionAPIClient<EndpointType: APIEndpoint>: APIClient {
    
    func request<T: Decodable>(_ endpoint: EndpointType, imageData: Data) throws -> AnyPublisher<T, Error> {
        
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // Set Content-Type for multipart/form-data
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Construct multipart/form-data body
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.png\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        // Logging the request details
        print("Request URL: \(url)")
        print("Request Method: \(request.httpMethod ?? "N/A")")
        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        
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

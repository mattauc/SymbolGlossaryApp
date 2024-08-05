//
//  SymbolService.swift
//  SymbolGlossary
//
//  Created by Matthew Auciello on 5/8/2024.
//

import Foundation
import Combine
import UIKit

class SymbolService {
    
    private let apiClient = URLSessionAPIClient<SymbolGlossaryEndpoint>()
    static let shared = SymbolService()
    
    func getImageSymbol(image: UIImage) -> AnyPublisher<Document.APIResponse, Error> {
        guard let imageData = image.pngData() else {
            return Fail(error: APIError.invalidData).eraseToAnyPublisher()
        }
        
        let endpoint = SymbolGlossaryEndpoint.getSymbol
        do {
            return try apiClient.request(endpoint, imageData: imageData)
                .map { (response: Document.APIResponse) in response }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}


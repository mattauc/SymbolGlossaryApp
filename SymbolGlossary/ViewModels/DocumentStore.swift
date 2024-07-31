//
//  DocumentStore.swift
//  SymbolGlossary
//
//  Created by Matthew Auciello on 28/7/2024.
//

import Foundation

// This will handle the different documents

class DocumentStore: ObservableObject {
    @Published var documents: [Document] = []
    
    private let fileURL: URL
    
    init() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        fileURL = documentsDirectory.appendingPathComponent("documents.json")
        
        loadDocuments()
    }
    
    func addDocument(_ document: Document) {
        documents.append(document)
        saveDocuments()
    }
        
    func deleteDocument(at index: Int) {
        documents.remove(at: index)
        saveDocuments()
    }
    
    private func saveDocuments() {
        do {
            let data = try JSONEncoder().encode(documents)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save documents: \(error.localizedDescription)")
        }
    }

    private func loadDocuments() {
        do {
            let data = try Data(contentsOf: fileURL)
            documents = try JSONDecoder().decode([Document].self, from: data)
        } catch {
            print("Failed to load documents: \(error.localizedDescription)")
        }
    }
}

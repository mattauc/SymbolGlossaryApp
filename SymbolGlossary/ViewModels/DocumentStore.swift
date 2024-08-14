//
//  DocumentStore.swift
//  SymbolGlossary
//
//  Created by Matthew Auciello on 28/7/2024.
//

import Foundation
import SwiftUI
import Combine

// This will handle the different documents

class DocumentStore: ObservableObject {
    @Published var documents: [Document] = []
    @Published private var _cursorIndex = 0
    private let symbolService: SymbolService
    private var cancellables = Set<AnyCancellable>()
    
    private let fileURL: URL
    
    init(symbolService: SymbolService) {
        self.symbolService = symbolService
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        fileURL = documentsDirectory.appendingPathComponent("documents.json")
        
        loadDocuments()
    }
    
    var cursorIndex: Int {
        get { boundsCheckedDocumentIndex(_cursorIndex)}
        set {_cursorIndex = boundsCheckedDocumentIndex(newValue)}
    }
    
    private func boundsCheckedDocumentIndex(_ index: Int) -> Int {
        var index = index % documents.count
        if index < 0 {
            index += documents.count
        }
        return index
    }
        
    func deleteDocument(at index: Int) {
        documents.remove(at: index)
        saveDocuments()
    }
    
    func saveDocuments() {
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
    
    
    func fetchSymbol() {
        if let imageData = documents[cursorIndex].imageData, let image = UIImage(data: imageData) {
            symbolService.getImageSymbol(image: image)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error fetching symbol data: \(error.localizedDescription)")
                    }
                }, receiveValue: { [weak self] symbol in
                    
                    if let self = self, self.documents.indices.contains(self.cursorIndex) {
                        self.documents[self.cursorIndex].symbol = symbol
                        print(symbol)
                    }
                })
                .store(in: &cancellables)
        }
    }
    
    func saveImage(withImageData imageData: Data) {
        documents[cursorIndex].imageData = imageData
    }
    
    func accessDocumentAtIndex(_ index: Int) -> Document {
        let cursorIndex = index
        return documents[cursorIndex]
    }
    
    func createNewDocument(_ index: Int) {
        let newDocument = Document()
        var cursorMod = index
        if documents.count >= 9 {
            documents.removeFirst()
            cursorMod -= 1
        }
        documents.append(newDocument)
        cursorIndex = cursorMod
        print(documents.count)
    }
    
    var symbolName: String? {
        return documents[cursorIndex].symbol?.symbol
    }
    
    var documentLines: [Line] {
        documents[cursorIndex].lines
    }
    
    var deletedLines: [Line] {
        documents[cursorIndex].deletedLines
    }
    
    func updateLine(_ newPoint: CGPoint) {
        documents[cursorIndex].updateLine(newPoint)
    }
    
    func removeLastLine() {
        documents[cursorIndex].removeLastLine()
    }
    
    func addLine(_ line: Line) {
        documents[cursorIndex].addLine(line)
    }
    
    func undoLine() {
        documents[cursorIndex].undoLine()
    }
    
    func redoLine() {
        documents[cursorIndex].redoLine()
    }
    
    func trashLines() {
        documents[cursorIndex].trashLines()
    }
}

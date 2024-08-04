//
//  Document.swift
//  SymbolGlossary
//
//  Created by Matthew Auciello on 28/7/2024.
//

import Foundation

// Each document will contain the drawn content

struct Document: Codable {
    var name: String?
    var id = UUID()
    //    var title: String
    //    var content: String
    var imageData: Data?
    
    var lines = [Line]()
    var deletedLines = [Line]()
    
    mutating func updateLine(_ newPoint: CGPoint) {
        let index = lines.count - 1
        lines[index].points.append(newPoint)
    }
    
    mutating func removeLastLine() {
        lines.removeLast()
    }
    
    mutating func addLine(_ line: Line) {
        lines.append(line)
    }
    
    mutating func undoLine() {
        let last = lines.removeLast()
        deletedLines.append(last)
    }
    
    mutating func redoLine() {
        let last = deletedLines.removeLast()
        lines.append(last)
    }
    
    mutating func trashLines() {
        lines = [Line]()
        deletedLines = [Line]()

    }
    


    
    struct APIResponse {
        
    }
}

struct Line: Codable {
    var points: [CGPoint]
    var colour: RGBA
    var lineWidth: CGFloat
}


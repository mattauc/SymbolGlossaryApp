//
//  DocumentPage.swift
//  SymbolGlossary
//
//  Created by Matthew Auciello on 28/7/2024.
//

import SwiftUI

struct DocumentPage: View {
    
    @State private var lines = [Line]()
    @State private var deletedLines = [Line]()
    @State private var eraser = false
    
    let engine = DrawingEngine()
    
    var body: some View {
        
        VStack {
            canvasPage
            toolBar
        }
    }
    
    private var canvasPage: some View {
        Canvas { context, size in
            for line in lines {
                //var path = Path()
                //path.addLines(line.points)
                
                let path = engine.createPath(for: line.points)
                
                //context.stroke(path, with: .color(line.colour), lineWidth: line.lineWidth)
                context.stroke(path, with: .color(line.colour), style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
            }
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged() { value in
                let newPoint = value.location
                
                if value.translation.width + value.translation.height == 0 {
                    lines.append(Line(points: [newPoint], colour: .black, lineWidth: 5))
                    
                } else {
                    let index = lines.count - 1
                    lines[index].points.append(newPoint)
                }
            }
            .onEnded() { value in
                if let last = lines.last?.points, last.isEmpty {
                    lines.removeLast()
                }
            }
        )
    }
    
    private var toolBar: some View {
        HStack {
            Button {
                let last = lines.removeLast()
                deletedLines.append(last)
            } label: {
                Image(systemName: "arrow.uturn.backward")
                    .foregroundColor(.black)
            }
            .disabled(lines.count == 0)
            
            Button {
                let last = deletedLines.removeLast()
                lines.append(last)
            } label: {
                Image(systemName: "arrow.uturn.forward")
                    .foregroundColor(.black)
            }
            .disabled(deletedLines.count == 0)
            
            Button {
                lines = [Line]()
                deletedLines = [Line]()
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.black)
            }
        }
    }
    
    struct Line {
        var points: [CGPoint]
        var colour: Color
        var lineWidth: CGFloat
    }
}

#Preview {
    DocumentPage()
}

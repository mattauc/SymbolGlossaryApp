//
//  DocumentCanvas.swift
//  SymbolGlossary
//
//  Created by Matthew Auciello on 31/7/2024.
//

import SwiftUI

struct DocumentCanvas: View {
    
    @State private var lines = [Line]()
    @State private var deletedLines = [Line]()
    @State private var eraser = false
    
    let engine = DrawingEngine()
    
    var body: some View {
        Canvas { context, size in
            for line in lines {
                
                let path = engine.createPath(for: line.points)
                
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
        .frame(width: 300, height: 400) // Set your desired frame width and height
        .border(Color.black, width: 1)
        .background(.white)
    }
    
    struct Line {
        var points: [CGPoint]
        var colour: Color
        var lineWidth: CGFloat
    }
}

#Preview {
    DocumentCanvas()
}

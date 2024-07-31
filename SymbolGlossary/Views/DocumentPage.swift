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
        ZStack {
            Color("Background")
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack {
                    Text("SYMBOL NAME")
                        .foregroundColor(.white)
                    canvasPage
                    toolBar
                        .padding(.top, 5)
                }
                symbolInformation
            }
        }
    }
    
    private var symbolInformation: some View {
        VStack {
            HStack {
                Text("SYMBOL INFORMATION")
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            
        }
    }
    
    private var canvasPage: some View {
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
        .frame(width: 300, height: 400)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color("DarkGrayColour"), lineWidth: 10)
        )
    }
    
    private var toolBar: some View {
        HStack {
            Button {
                let last = lines.removeLast()
                deletedLines.append(last)
            } label: {
                Image(systemName: "arrow.uturn.backward")
                    .foregroundColor(.white)
            }
            .disabled(lines.count == 0)
            
            Button {
                let last = deletedLines.removeLast()
                lines.append(last)
            } label: {
                Image(systemName: "arrow.uturn.forward")
                    .foregroundColor(.white)
            }
            .disabled(deletedLines.count == 0)
            
            Button {
                lines = [Line]()
                deletedLines = [Line]()
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.white)
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

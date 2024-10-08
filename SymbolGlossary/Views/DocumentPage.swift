//
//  DocumentPage.swift
//  SymbolGlossary
//
//  Created by Matthew Auciello on 28/7/2024.
//

import SwiftUI

struct DocumentPage: View {
    
    @State private var eraser = false
    @State private var documentCreated = false
    @State private var documentSaved = false
    
    @EnvironmentObject var documentStore: DocumentStore
    @EnvironmentObject var symbolGlossaryManager: SymbolGlossaryManager
    
    let documentIndex: Int
    let engine = DrawingEngine()
    var newDocument: Bool
    
    
    var body: some View {
        ZStack {
            Color("Background")
                .edgesIgnoringSafeArea(.all)
            if documentCreated {
                ScrollView {
                    VStack {
                        
                        Text(documentStore.symbolName ?? "Inconclusive")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                        canvasPage
                        toolBar
                            .padding(.top, 5)
                    }
                    symbolInformation
                }
            }
        }
        .onAppear() {
            if newDocument {
                documentStore.createNewDocument(documentIndex)
            } else {
                documentStore.cursorIndex = documentIndex
            }
            documentCreated = true
        }
        .onDisappear() {
            if (!documentSaved && newDocument) {
                documentStore.deleteDocument(at: documentStore.documents.count - 1)
            } else if (documentStore.documentLines.count == 0) {
                if newDocument {
                    documentStore.deleteDocument(at: documentStore.documents.count - 1)
                } else {
                    documentStore.deleteDocument(at: documentIndex)
                }
            } else if documentSaved {
                if let name = documentStore.symbolName {
                    symbolGlossaryManager.addToSymbolList(name)
                }
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
            for line in documentStore.documentLines {
                
                let path = engine.createPath(for: line.points)
                
                context.stroke(path, with: .color(Color(rgba: line.colour)), style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
            }
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged() { value in
                let newPoint = value.location
                
                if value.translation.width + value.translation.height == 0 {
                    documentStore.addLine(Line(points: [newPoint], colour: RGBA(colour: .black), lineWidth: 5))
                    
                } else {
                    documentStore.updateLine(newPoint)
                }
            }
            .onEnded() { value in
                if let last = documentStore.documentLines.last?.points, last.isEmpty {
                    documentStore.removeLastLine()
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
                captureAndSaveImage()
                documentStore.fetchSymbol()
                documentStore.saveDocuments()
                documentSaved = true
            } label: {
                Image(systemName: "target")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
            
            Button {
                documentStore.undoLine()
            } label: {
                Image(systemName: "arrow.uturn.backward")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
            .disabled(documentStore.documentLines.count == 0)
            Button {
                documentStore.redoLine()
            } label: {
                Image(systemName: "arrow.uturn.forward")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
            .disabled(documentStore.deletedLines.count == 0)
            //Spacer()
            Button {
                documentStore.trashLines()
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .frame(width:300)
    }
    
    private func captureAndSaveImage() {
         let renderer = ImageRenderer(content: canvasPage.overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white, lineWidth: 10)
        ))
         if let image = renderer.uiImage {
             if let imageData = image.jpegData(compressionQuality: 0.8) {
                 documentStore.saveImage(withImageData: imageData)
             }
         }
     }
}

struct DocumentPage_Previews: PreviewProvider {
    static var previews: some View {
        let documentStore = DocumentStore(symbolService: SymbolService.shared)
        DocumentPage(documentIndex: 0, newDocument: true)
            .environmentObject(documentStore)
    }
}

//
//  DrawingCard.swift
//  SymbolGlossary
//
//  Created by Matthew Auciello on 31/7/2024.
//

import SwiftUI

struct DrawingCard: View {
    
    var isEmpty: Bool
    var documentIndex: Int
    //private var documentDisplay:
    var cornerRadius = 10.0
    
    @EnvironmentObject var documentStore: DocumentStore
    
    var body: some View {
        ZStack {
            
           RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(Color("DarkGrayColour"))
            
            if isEmpty {
                NavigationLink(destination: DocumentPage(documentIndex: documentIndex, newDocument: true)) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray)
                        .padding(50)
                }
            } else {
                NavigationLink(destination: DocumentPage(documentIndex: documentIndex, newDocument: false)) {
                    if documentIndex < documentStore.documents.count {
                        if let imageData = documentStore.documents[documentIndex].imageData,
                           let image = UIImage(data: imageData) {
                            Image(uiImage: image)
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                                .overlay(
                                   RoundedRectangle(cornerRadius: cornerRadius)
                                    .stroke(Color("DarkGrayColour"), lineWidth: 5))
                        } else {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
        .frame(width: 150, height: 150)
    }
}
//
//#Preview {
//    DrawingCard(isEmpty: false)
//}

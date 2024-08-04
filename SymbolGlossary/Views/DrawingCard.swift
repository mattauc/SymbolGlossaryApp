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
    
    //Likely import the document model that belong to each card and just dispaly the UIimage
    
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
                    Image(systemName: "pencil.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray)
                        .padding(50)
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

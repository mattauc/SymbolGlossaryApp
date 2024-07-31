//
//  DrawingCard.swift
//  SymbolGlossary
//
//  Created by Matthew Auciello on 31/7/2024.
//

import SwiftUI

struct DrawingCard: View {
    
    private var isEmpty = true
    //private var documentDisplay:
    private var cornerRadius = 10.0
    //private var documentIndex: I
    
    //Likely import the document model that belong to each card and just dispaly the UIimage
    
    var body: some View {
        ZStack {
            
           RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(Color("DarkGrayColour"))
            
            if isEmpty {
                NavigationLink(destination: DocumentPage()) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray)
                        .padding(50)
                }
            } else {
                EmptyView()
            }
        }
        .frame(width: 150, height: 150)
    }
}

#Preview {
    DrawingCard()
}

//
//  ContentView.swift
//  SymbolGlossary
//
//  Created by Matthew Auciello on 27/7/2024.
//

import SwiftUI

struct HomePage: View {
    
    @EnvironmentObject var documentStore: DocumentStore
    @EnvironmentObject var symbolGlossaryManager: SymbolGlossaryManager
    
    var body: some View {
        NavigationStack {
            VStack {
                homeContent
                    ScrollView() {
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            DrawingCard(isEmpty: true, documentIndex: documentStore.documents.count)
                            ForEach(documentStore.documents.indices.reversed(), id: \.self) { index in
                                withAnimation {
                                    DrawingCard(isEmpty: false, documentIndex: index)
                                }
                            }
                        }
                        .padding()
                    }
            }
            .padding()
            .background(Color("Background"))
        }
    }
    
    var homeContent: some View {
        VStack {
            Text("MATH SYMBOL GLOSSARY")
                .foregroundColor(.white)
            
            SortDropMenu()
        }
    }
}

#Preview {
    HomePage()
        .environmentObject(DocumentStore(symbolService: SymbolService.shared))
}

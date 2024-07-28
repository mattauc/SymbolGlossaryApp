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
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    HomePage()
}

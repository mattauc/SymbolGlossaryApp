//
//  SortDropMenu.swift
//  SymbolGlossary
//
//  Created by Matthew Auciello on 14/8/2024.
//

import SwiftUI

struct SortDropMenu: View {
    
    @State private var isOptionsPresented = false
    @State var selectedOption: String?
    @EnvironmentObject var symbolGlossaryManager: SymbolGlossaryManager
    
    var body: some View {
        Button(action: {
            withAnimation {
                self.isOptionsPresented.toggle()
            }
        }) {
            HStack {
                Text(symbolGlossaryManager.sortSymbol)
                    .fontWeight(.medium)
                    .foregroundColor(selectedOption == nil ? .gray : .black)
                
                Spacer()
                
                Image(systemName: self.isOptionsPresented ? "chevron.up" : "chevron.down")
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .overlay(
        RoundedRectangle(cornerRadius: 5)
            .stroke(.gray, lineWidth: 2))
        .overlay(alignment: .top) {
            VStack {
                if self.isOptionsPresented {
                    Spacer(minLength: 60)
                    optionSelector
                }
            }
        }
        .padding(.horizontal)
    }
    
    var optionSelector: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 2) {
                ForEach(symbolGlossaryManager.symbolList, id: \.self) { option in
                    Button(action: {}) {
                        Text(option)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                }
            }
        }
        .frame(height: 200)
        .padding(.vertical, 5)
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(.gray, lineWidth: 2)
        }
    }
    
}

#Preview {
    SortDropMenu()
}

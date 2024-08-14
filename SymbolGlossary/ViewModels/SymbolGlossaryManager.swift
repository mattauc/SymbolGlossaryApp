//
//  SymbolGlossaryManager.swift
//  SymbolGlossary
//
//  Created by Matthew Auciello on 28/7/2024.
//

import Foundation

class SymbolGlossaryManager: ObservableObject {
    @Published private(set) var symbolGlossary: SymbolGlossary
    
    init() {
        self.symbolGlossary = SymbolGlossary()
    }
    
    var symbolList: [String] {
        symbolGlossary.symbols
    }
    
    var sortSymbol: String {
        symbolGlossary.option
    }
    
    
    func addToSymbolList(_ symbol: String) {
        symbolGlossary.addNewSymbol(symbol)
    }
    
    
}

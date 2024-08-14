//
//  SymbolGlossary.swift
//  SymbolGlossary
//
//  Created by Matthew Auciello on 28/7/2024.
//

import Foundation

//enum Symbols: String, CaseIterable {
//    case all = "Sort by"
//    case sigma = "Sigma"
//    case neq = "Neq"
//    case lambda = "Lambda"
//    case delta = "Delta"
//    case sin = "Sin"
//}

struct SymbolGlossary {
    
    private(set) var option: String = "Sort by"
    private(set) var symbols: [String] = []
    
    mutating func addNewSymbol(_ symbol: String) {
        symbols.append(symbol)
    }
}

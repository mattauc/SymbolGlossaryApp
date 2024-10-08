//
//  SymbolGlossaryApp.swift
//  SymbolGlossary
//
//  Created by Matthew Auciello on 27/7/2024.
//

import SwiftUI

@main
struct SymbolGlossaryApp: App {
    @StateObject private var documentStore = DocumentStore(symbolService: SymbolService.shared)
    @StateObject private var symbolGlossaryManager = SymbolGlossaryManager()
    
    var body: some Scene {
        WindowGroup {
            HomePage()
                .environmentObject(documentStore)
                .environmentObject(symbolGlossaryManager)
        }
    }
}

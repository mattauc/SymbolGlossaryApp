//
//  SymbolGlossaryApp.swift
//  SymbolGlossary
//
//  Created by Matthew Auciello on 27/7/2024.
//

import SwiftUI

@main
struct SymbolGlossaryApp: App {
    @StateObject private var documentStore = DocumentStore()
    @StateObject private var symbolGlossaryManager = SymbolGlossaryManager()
    
    var body: some Scene {
        WindowGroup {
            DocumentPage()
                .environmentObject(documentStore)
                .environmentObject(symbolGlossaryManager)
        }
    }
}

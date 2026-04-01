//
//  TranslateMeApp.swift
//  TranslateMe
//
//  Created by Brianna Thelwell on 4/1/26.
//

import SwiftUI
import Firebase

@main
struct TranslationMeApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

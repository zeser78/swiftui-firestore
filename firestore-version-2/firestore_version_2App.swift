//
//  firestore_version_2App.swift
//  firestore-version-2
//
//  Created by Sergio Olivares on 12/13/20.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct firestore_version_2App: App {
    
    init() {
        FirebaseApp.configure()
        Auth.auth().signInAnonymously()
        
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

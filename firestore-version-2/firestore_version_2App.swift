//
//  firestore_version_2App.swift
//  firestore-version-2
//
//  Created by Sergio Olivares on 12/13/20.
//

import SwiftUI
import Firebase

@main
struct firestore_version_2App: App {
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView(clientsData: [])
        }
    }
}

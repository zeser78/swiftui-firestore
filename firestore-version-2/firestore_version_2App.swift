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
////        Auth.auth().createUser(withEmail: "zaravmarine@gmail.com", password: "nadia123") { authResult, error in
////          // ...
////            if let authUser = authResult {
////                print("authUser \(authResult)")
////            } else {
////                print(error)
////            }
////        }
//
//        Auth.auth().signIn(withEmail:"zaravmarine@gmail.com", password: "nadia123") { authResult, error in
////            guard self != nil else { return }
//            if let authUser = authResult {
//                           print("authUser \(authResult)")
//                       } else {
//                           print(error)
//                       }
//          // ...
//        }
        
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

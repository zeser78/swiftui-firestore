//
//  LogInView.swift
//  firestore-version-2
//
//  Created by Sergio Olivares on 12/25/20.
//

import SwiftUI

struct LogInView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}


//struct LoginView: View {
//    var body: some View {
//        ...
//    }
//}
//
//struct NextView: View {
//    var body: some View {
//        ...
//    }
//}
//
//// Your starting view
//struct ContentView: View {
//
//    @EnvironmentObject var userAuth: UserAuth
//
//    var body: some View {
//        if !userAuth.isLoggedin {
//            LoginView()
//        } else {
//            NextView()
//        }
//
//    }
//}

///
//struct ContentView: View {
//
//    @EnvironmentObject var userAuth: UserAuth
//
//    var body: some View {
//        if !userAuth.isLoggedin {
//            return AnyView(LoginView())
//        } else {
//            return AnyView(NextView())
//        }
//
//    }
//}

///
//import Combine
//
//class UserAuth: ObservableObject {
//
//  let didChange = PassthroughSubject<UserAuth,Never>()
//
//  // required to conform to protocol 'ObservableObject'
//  let willChange = PassthroughSubject<UserAuth,Never>()
//
//  func login() {
//    // login request... on success:
//    self.isLoggedin = true
//  }
//
//  var isLoggedin = false {
//    didSet {
//      didChange.send(self)
//    }
//
//    // willSet {
//    //       willChange.send(self)
//    // }
//  }
//}

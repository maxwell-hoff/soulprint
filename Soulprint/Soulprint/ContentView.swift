//
//  ContentView.swift
//  Soulprint
//
//  Created by Max Hoff on 6/23/23.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var loggedIn: Bool = false

    var body: some View {
        Group {
            if loggedIn {
                PromptView(loggedIn: $loggedIn)
            } else {
                LoginView(loggedIn: $loggedIn)
            }
        }
        .onAppear {
            checkLoginStatus()
        }
    }

    private func checkLoginStatus() {
        if Auth.auth().currentUser != nil {
            loggedIn = true
        }
    }
}


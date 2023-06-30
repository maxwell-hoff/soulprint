//
//  ContentView.swift
//  Soulprint
//
//  Created by Max Hoff on 6/23/23.
//

import SwiftUI

struct ContentView: View {
    @State private var loggedIn = false

    var body: some View {
        if loggedIn {
            PromptView()
        } else {
            LoginView(loggedIn: $loggedIn)
        }
    }
}


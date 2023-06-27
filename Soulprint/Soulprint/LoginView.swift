//
//  LoginView.swift
//  Soulprint
//
//  Created by Max Hoff on 6/26/23.
//

import SwiftUI
import FirebaseAuth

let darkGray = Color(UIColor(white: 0.1, alpha: 1))
let forestGreen = Color(UIColor(red: 0.05, green: 0.25, blue: 0.05, alpha: 1))

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var error: String = ""
    @Binding var loggedIn: Bool

    var body: some View {
        VStack {
            Text("Soulprint")
                .font(.largeTitle)
                .padding(.bottom, 50)
            TextField("Email", text: $email)
                .padding()
                .background(Color.gray)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            if !error.isEmpty {
                Text(error)
                    .foregroundColor(.red)
                    .padding(.bottom, 20)
            }
            Button(action: {
                signIn()
            }) {
                Text("Log In")
                    .font(.headline)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(darkGray) // Changes the button color to dark gray.
                    .foregroundColor(forestGreen) // Changes the text color to forest green.
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(forestGreen, lineWidth: 2) // Adds a forest green outline.
                    )
            }
            Button(action: {
                signUp()
            }) {
                Text("Sign Up")
                    .font(.headline)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(darkGray) // Changes the button color to dark gray.
                    .foregroundColor(forestGreen) // Changes the text color to forest green.
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(forestGreen, lineWidth: 2) // Adds a forest green outline.
                    )
            }
        }
        .padding()
        .background(darkGray.edgesIgnoringSafeArea(.all))
        .foregroundColor(forestGreen) // Makes the text color forest green.
    }

    func signIn() {
        if !email.isEmpty && !password.isEmpty {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let error = error as NSError? {
                    self.error = self.handleError(error)
                } else {
                    self.loggedIn = true
                }
            }
        } else {
            error = "Please enter email and password"
        }
    }

    func signUp() {
        if !email.isEmpty && !password.isEmpty {
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let error = error as NSError? {
                    self.error = self.handleError(error)
                } else {
                    self.loggedIn = true
                }
            }
        } else {
            error = "Please enter email and password"
        }
    }

    private func handleError(_ error: Error) -> String {
        return "An error occurred: \(error.localizedDescription)"
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loggedIn: .constant(false))
            .background(darkGray.edgesIgnoringSafeArea(.all))
            .foregroundColor(forestGreen)
    }
}


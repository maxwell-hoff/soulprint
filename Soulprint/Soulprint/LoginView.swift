//
//  LoginView.swift
//  Soulprint
//
//  Created by Max Hoff on 6/26/23.
//

import SwiftUI
import FirebaseAuth

let backgroundColor = Color(UIColor(white: 0.25, alpha: 1))
let fontColor = Color(UIColor(red: 0.2, green: 0.3, blue: 0.6, alpha: 1))
let buttonColor = Color(UIColor(white: 0.12, alpha: 1))

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var error: String = ""
    @Binding var loggedIn: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("fingerprint-logo-v5")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .opacity(1.0)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                VStack {
                    Text("")
                        .font(.largeTitle.bold().italic())
                        .padding(.bottom, 150)
                    TextField("Email", text: $email)
                        .padding()
                        .foregroundColor(.black)
                        .background(Color.gray)
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                    SecureField("Password", text: $password)
                        .padding()
                        .foregroundColor(.black)
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
                            .background(buttonColor) // Changes the button color to dark gray.
                            .foregroundColor(fontColor) // Changes the text color to forest green.
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(fontColor, lineWidth: 2) // Adds a forest green outline.
                            )
                    }
                    Button(action: {
                        signUp()
                    }) {
                        Text("Sign Up")
                            .font(.headline)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(buttonColor) // Changes the button color to dark gray.
                            .foregroundColor(fontColor) // Changes the text color to forest green.
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(fontColor, lineWidth: 2) // Adds a forest green outline.
                            )
                    }
                }
                .padding()
                .foregroundColor(fontColor)
            }
            .background(backgroundColor.edgesIgnoringSafeArea(.all))
        }
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
            .background(backgroundColor.edgesIgnoringSafeArea(.all))
            .foregroundColor(fontColor)
    }
}

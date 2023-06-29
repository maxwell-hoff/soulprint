//
//  PromptView.swift
//  Soulprint
//
//  Created by Max Hoff on 6/26/23.
//

import SwiftUI
import FirebaseAuth

struct PromptView: View {
    let dailyPrompts = ["What was the high of your day?", "What was the low of your day?"]
    let deepDivePrompts = ["Who are the most important people in your life?", "What is your favorite memory and why?", "What was the worst day of your life?"]
    @State private var selectedPromptSetIndex = 0
    @State private var selectedPromptIndex = 0
    @State private var isVideoRecording = false
    @State private var videoURL: URL? = nil
    @Binding var loggedIn: Bool

    var body: some View {
        ZStack {
            VStack {
                Picker("Prompt Set", selection: $selectedPromptSetIndex) {
                    Text("Daily").tag(0)
                    Text("Deep Dive").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top, 50)

                ForEach(promptsForSelectedSet().indices) { index in
                    Button(action: {
                        selectedPromptIndex = index
                        isVideoRecording = true
                    }) {
                        Text(promptsForSelectedSet()[index])
                            .font(.title2.bold())
                            .foregroundColor(fontColor)
                            .frame(maxWidth: .infinity, minHeight: 44, alignment: .center)
                            .padding([.top, .bottom], 10)
                            .padding([.leading, .trailing], 4)
                            .background(buttonColor)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(fontColor, lineWidth: 2)
                            )
                            .padding([.leading, .trailing], 10)
                    }
                }
                Spacer()
            }

            VStack {
                HStack {
                    Button(action: {
                        signOut()
                    }) {
                        Text("Sign Out")
                            .font(.headline)
                            .foregroundColor(fontColor) // Changes the text color to forest green.
                    }
                    .padding()
                    Spacer()
                }
                Spacer()
            }
        }
        .background(backgroundColor.edgesIgnoringSafeArea(.all))
        .foregroundColor(fontColor)
        .sheet(isPresented: $isVideoRecording) { // Present VideoRecorder when isVideoRecording is true
            VideoRecorder(isShown: $isVideoRecording, videoURL: $videoURL)
        }
    }
    
    private func signOut() {
        do {
            try Auth.auth().signOut()
            self.loggedIn = false
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

    private func promptsForSelectedSet() -> [String] {
        switch selectedPromptSetIndex {
        case 0:
            return dailyPrompts
        case 1:
            return deepDivePrompts
        default:
            return []
        }
    }
}


struct PromptView_Previews: PreviewProvider {
    static var previews: some View {
        PromptView(loggedIn: .constant(true))
    }
}

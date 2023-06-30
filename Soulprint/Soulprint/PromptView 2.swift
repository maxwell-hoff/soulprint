//
//  PromptView.swift
//  Soulprint
//
//  Created by Max Hoff on 6/26/23.
//

import SwiftUI

struct PromptView: View {
    let dailyPrompts = ["What was the high of your day?", "What was the low of your day?"]
    let deepDivePrompts = ["Who are the most important people in your life?", "What is your favorite memory and why?", "What was the worst day of your life?"]
    @State private var selectedPromptSetIndex = 0
    @State private var selectedPromptIndex = 0
    @State private var isVideoRecording = false
    @State private var videoURL: URL? = nil


    var body: some View {
        VStack {
            Picker("Prompt Set", selection: $selectedPromptSetIndex) {
                Text("Daily").tag(0)
                Text("Deep Dive").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            ForEach(promptsForSelectedSet().indices) { index in
                Button(action: {
                    selectedPromptIndex = index
                    isVideoRecording = true
                }) {
                    Text(promptsForSelectedSet()[index])
                        .font(.title2)
                        .padding()
                        .background(darkGray)
                        .foregroundColor(forestGreen)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(forestGreen, lineWidth: 2)
                        )
                }
                .frame(maxWidth: .infinity)
                .sheet(isPresented: $isVideoRecording) {
                    VideoRecorder(isShown: $isVideoRecording, videoURL: $videoURL)
                }
            }
            Spacer()
        }
        .background(darkGray.edgesIgnoringSafeArea(.all))
        .foregroundColor(forestGreen)
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
        PromptView()
    }
}


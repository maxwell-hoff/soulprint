//
//  InformationView.swift
//  Soulprint
//
//  Created by Max Hoff on 7/7/23.
//

import SwiftUI

struct InformationView: View {
    var body: some View {
        VStack {
            Text("Hey,\n\nI'm Max and I created this app because I've always wished I could have met my dad's father. The central assumption behind this app is that AI will continue to improve, but models won't be able to replicate most people since not enough data will be available (even given the wealth of personal information avaiable today). This app is designed to collect data to fill that gap.\n\nThis app is currently just focused on data collection, but works is under way to produce models that replicate individuals.")
                .font(.body)
                .padding()
            VStack {
                Button(action: {}) {
                    Text("Tips")
                }
                .buttonStyle(AppButtonStyle())

                Button(action: {}) {
                    Text("Assumptions")
                }
                .buttonStyle(AppButtonStyle())

                Button(action: {}) {
                    Text("Models")
                }
                .buttonStyle(AppButtonStyle())

                Button(action: {}) {
                    Text("Help")
                }
                .buttonStyle(AppButtonStyle())
            }
        }
        .background(backgroundColor.edgesIgnoringSafeArea(.all))
        .foregroundColor(.gray)
    }
}

struct AppButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2.bold())
            .foregroundColor(fontColor)
            .frame(maxWidth: .infinity, minHeight: 44, alignment: .center)
            .padding([.top, .bottom], 10)
            .padding([.leading, .trailing], 4)
            .background(buttonColor.shadow(color: .black, radius: 5, x: 0, y: 2))
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(fontColor, lineWidth: 2)
            )
            .padding([.leading, .trailing], 10)
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}

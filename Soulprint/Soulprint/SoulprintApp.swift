//
//  SoulprintApp.swift
//  Soulprint
//
//  Created by Max Hoff on 6/23/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct SoulprintApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

struct StatusBarStyle: ViewModifier {
    var style: UIStatusBarStyle
    func body(content: Content) -> some View {
        content
            .onAppear {
                let app = UIApplication.shared
                app.windows.first?.overrideUserInterfaceStyle = style == .lightContent ? .dark : .light
            }
    }
}

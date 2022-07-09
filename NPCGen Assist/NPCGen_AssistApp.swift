//
//  NPCGen_AssistApp.swift
//  NPCGen Assist
//
//  Created by Michael Craun on 4/21/22.
//

import SwiftUI

import Firebase

enum AppEnvironment {
    case debug
    case production
}

@main
struct NPCGen_AssistApp: App {
    private let environment: AppEnvironment = .debug
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        switch environment {
        case .debug:
            if let filePath = Bundle.main.path(forResource: "GoogleService-Info-DEBUG", ofType: "plist") {
                if let options = FirebaseOptions(contentsOfFile: filePath) {
                    print("############ You are currently running in debug ############")
                    FirebaseApp.configure(options: options)
                }
            }
        case .production:
            print("############ WARNING: YOU ARE CURRENTLY RUNNING IN PRODUCTION ############")
            FirebaseApp.configure()
        }
    }
}

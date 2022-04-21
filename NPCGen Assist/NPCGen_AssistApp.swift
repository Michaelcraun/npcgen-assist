//
//  NPCGen_AssistApp.swift
//  NPCGen Assist
//
//  Created by Michael Craun on 4/21/22.
//

import SwiftUI

import Firebase

@main
struct NPCGen_AssistApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        FirebaseApp.configure()
    }
}

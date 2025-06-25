//
//  PawdleApp.swift
//  Pawdle
//
//  Created by Edward Downhill on 24/06/2025.
//

import SwiftUI

@main
struct PawdleApp: App {
    
    init() {
        Theme.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}

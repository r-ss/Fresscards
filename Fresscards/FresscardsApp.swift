//
//  FresscardsApp.swift
//  Fresscards
//
//  Created by Alex Antipov on 01.04.2023.
//

import SwiftUI

@main
struct FresscardsApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    var dataManager = DataManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                print("scenePhase Active")
            case .inactive:
                print("scenePhase Inactive")
                dataManager.saveData()
            case .background:
                print("scenePhase background")
                dataManager.saveData()
            default:
                print("scenePhase unknown")
            }
        }
    }
}

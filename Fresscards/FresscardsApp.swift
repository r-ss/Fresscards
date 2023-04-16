//
//  FresscardsApp.swift
//  Fresscards
//
//  Created by Alex Antipov on 01.04.2023.
//

import SwiftUI
import Firebase


// Google Analytics
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    -> Bool {
    FirebaseApp.configure()
    return true
  }
}


@main
struct FresscardsApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate // Google Analytics
    
    
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

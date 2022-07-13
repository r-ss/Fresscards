//
//  FresscardsApp.swift
//  Fresscards
//
//  Created by Alex Antipov on 30.06.2022.
//

import SwiftUI




@main
struct FresscardsApp: App {
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//                .environmentObject(jsonData()) // necessary
        }
    }
}

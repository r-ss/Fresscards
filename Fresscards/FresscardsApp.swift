//
//  FresscardsApp.swift
//  Fresscards
//
//  Created by Alex Antipov on 30.06.2022.
//

import SwiftUI


@main
struct FresscardsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(jsonData()) // necessary
        }
    }
}

//
//  FresscardsApp.swift
//  Fresscards
//
//  Created by Alex Antipov on 30.06.2022.
//

import SwiftUI




@main
struct FresscardsApp: App {
    
    init() {
        
//        UITableView.appearance().separatorStyle = .none
//        UITableViewCell.appearance().backgroundColor = .green
//        UITableView.appearance().backgroundColor = .green
//        
//        UIListContentView.appearance().backgroundColor = .green
//        
//        UITabBar.appearance().backgroundColor = UIColor(Palette.background)
        UITabBarItem.appearance().badgeColor = UIColor(Palette.cardBackground) // custom color for tab badge
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(jsonData()) // necessary
        }
    }
}

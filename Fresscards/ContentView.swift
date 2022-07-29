//
//  ContentView.swift
//  Fresscards
//
//  Created by Alex Antipov on 30.06.2022.
//

import SwiftUI



struct ContentView: View {
    
    @EnvironmentObject var jsonData: jsonData
    //    @EnvironmentObject var modelData: CardRealmViewModel
    
    // Solution to navigate on doble tap tab icon
    // https://designcode.io/swiftui-handbook-tabbar-to-root-view
    @State private var uuidTiles = UUID()
    @State private var uuidList = UUID()
    @State private var uuidDebug = UUID()
    @State private var uuidSettings = UUID()

    
    var body: some View {
        //let _ = print(ModelData().cards
        
        VStack {
            //            Text("Fresscards")
            //                .font(Font.system(Font.TextStyle.title))
            //                Divider()
            
            TabView {
                Tiles()
                    .tabItem {
                        Label("Tiles", systemImage: "tray.full")
                    }
                    .tag(uuidTiles)
                
                
                CardList()
                    .badge(jsonData.cards.count)
                    .tabItem {
                        Label("List", systemImage: "list.bullet.rectangle.portrait")
                    }
                    .tag(uuidList)
                
                
                DebugView()
                    .tabItem {
                        Label("Debug", systemImage: "cpu")
                    }
                    .tag(uuidDebug)
                
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                    .tag(uuidSettings)
                
                
            }
        }.background(Palette.background)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(jsonData())
    }
}

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
    

    
    var body: some View {
        //let _ = print(ModelData().cards
        
        VStack {
            Text("Fresscards")
                .font(Font.system(Font.TextStyle.title))
            //                Divider()
            
            TabView {
                Tiles()
                    .tabItem {
                        Label("Tiles", systemImage: "stop.fill")
                    }
                CardList()
                    .badge(jsonData.cards.count)
                    .tabItem {
                        Label("List", systemImage: "tray.full")
                    }
                DebugView()
                    .tabItem {
                        Label("Debug", systemImage: "cpu")
                    }
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
            }
        }.background(Palette.background)
        
        
        
        //        VStack {
        //            Text("Fresscards")
        //                .font(Font.system(Font.TextStyle.title))
        ////                Divider()
        
        
        //
        //            NavigationView {
        //
        //                VStack {
        //
        //                    Rectangle().fill(Palette.a).frame(width: 200, height: 30)
        //                    Rectangle().fill(Palette.b).frame(width: 200, height: 30)
        //                    Rectangle().fill(Palette.c).frame(width: 200, height: 30)
        //                    Rectangle().fill(Palette.d).frame(width: 200, height: 30)
        //                    Rectangle().fill(Palette.e).frame(width: 200, height: 30)
        //
        //                    ShareView()
        //
        //                    NavigationLink {
        //                        RawJsonView()
        //                    } label: {
        //                        Text("RAW JSON")
        //                    }
        //                    .padding()
        //
        //                    NavigationLink {
        //                        Tiles(withCards: jsonData.cards)
        //                    } label: {
        //                        Text("Tiles")
        //                    }
        //                    .padding()
        //
        //
        //                    NavigationLink {
        //                        CardList()
        //                    } label: {
        //                        Text("CardList")
        //                    }
        //                    .padding()
        //
        //
        //                }
        //
        //
        //
        //            }
        //
        
        
        
        
        
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(jsonData())
    }
}

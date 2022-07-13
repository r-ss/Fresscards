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
        //let _ = print(ModelData().cards)
        

        
        VStack {
            Text("Fresscards")
                .font(Font.system(Font.TextStyle.title))
//                Divider()
//
            NavigationView {
                
                VStack {
                    
                    Rectangle().fill(Palette.a).frame(width: 200, height: 30)
                    Rectangle().fill(Palette.b).frame(width: 200, height: 30)
                    Rectangle().fill(Palette.c).frame(width: 200, height: 30)
                    Rectangle().fill(Palette.d).frame(width: 200, height: 30)
                    Rectangle().fill(Palette.e).frame(width: 200, height: 30)
                    
                    ShareView()
                
                    NavigationLink {
                        Tiles(withCards: jsonData.cards)
                    } label: {
                        Text("Tiles")
                    }
                    .padding()
                    
                    
                    NavigationLink {
                        CardList()
                    } label: {
                        Text("CardList")
                    }
                    .padding()
                    
                    
                }
                
                
                
            }
                

                

  
    
        }.background(Palette.background)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(jsonData())
    }
}

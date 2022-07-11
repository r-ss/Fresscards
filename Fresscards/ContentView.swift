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
        ZStack {
            
            Palette.e.edgesIgnoringSafeArea(.all)
            
//            CardView()
            
            VStack {
                Text("Fresscards")
                    .font(Font.system(Font.TextStyle.title))
                    .bold()
                    .padding()
//                Divider()
//
                NavigationView {
                    
                    VStack {
                        
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
                

                
                
//                .environmentObject(modelData)
//                Divider()
                
//                CardList()
//                Tiles()
//                        ReferenceContentView()
                
                
                
//                CardView()
                
  
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environmentObject(ModelData())
//    }
//}

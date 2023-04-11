//
//  CardsListView.swift
//  Fresscards
//
//  Created by Alex Antipov on 03.04.2023.
//

import SwiftUI

struct GeneratedCardsReviewView: View {
    
    let response: NeuralResponse?
    let titleTheme: String?
    
    var body: some View {
            GeometryReader { cards_geometry in
                
                if let resp = response {
                    
                    List {
                        //                                        Toggle(isOn: $showUserCardsOnly) {
                        //                                            Text("Only added by user")
                        //                                        }
                        //                    if (self.filteredCards.count == 0) {
                        //                        Text("No cards, add some")
                        //                    }
                        ForEach(resp.result, id: \.self) { item in
                            HStack(spacing: 3*2){
                                Text(item.side_a)
                                    .frame(width: cards_geometry.size.width / 2 - 3, alignment: .leading)
                                //                                                    .background(.red)
                                Text(item.side_b)
                                    .frame(width: cards_geometry.size.width / 2 - 3, alignment: .leading)
                                //                                                    .background(.green)
                            }.frame(width: cards_geometry.size.width, height: 20)
                        }
                        
                        
                    }
                    .listStyle(PlainListStyle())
                    .navigationBarTitle(titleTheme ?? "")
                    
                }
            }.padding()
    }
}

struct GeneratedCardsReviewView_Previews: PreviewProvider {
    static var previews: some View {
        GeneratedCardsReviewView(response: NeuralResponse.mocked.response1, titleTheme: "Example theme")
    }
}

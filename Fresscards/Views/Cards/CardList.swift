//
//  CardsList.swift
//  Fresscards
//
//  Created by Alex Antipov on 05.07.2022.
//

import SwiftUI

struct CardList: View {
    
    @State private var addMode = false
    
    @EnvironmentObject var jsonData: jsonData
    
//    @EnvironmentObject var modelData: CardRealmViewModel
//    @State private var showFavoritesOnly = false
//
//    var filteredCards: [Card] {
//        modelData.cards.filter { card in
//            (!showFavoritesOnly || card.isFavorite)
//        }
//    }
    var filteredCards: [Card] {
        jsonData.cards
    }
    
    private func deleteCard(at offsets: IndexSet) {
//        modelData.cards.remove(atOffsets: offsets)
        
        
        
        jsonData.removeCards(atIndexes: offsets)
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                List {
                    ForEach(filteredCards) { card in
                        NavigationLink {
                            CardDetail(with_card: card)
                        } label: {
                            CardRow(card: card)
                        }.listRowSeparator(.hidden)
                    }.onDelete(perform: deleteCard)
                        .padding(0)
                }

                .navigationBarTitle(Text("Cards"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                      self.addMode = true
                    } ) {
                    Image(systemName: "plus")
                        .padding([.leading, .top, .bottom])
                } )

                // invisible link inside NavigationView for add mode
                NavigationLink(destination: CardAdd(),
                    isActive: $addMode) { EmptyView() }
            }
        }
    }
}
        
        
        
        
        
//        NavigationView {
//
//            VStack {
//                HStack {
//                    Spacer()
//                    AddButton()
//                }
//                List {
//    //                Toggle(isOn: $showFavoritesOnly) {
//    //                                    Text("Favorites only")
//    //                                }
//
//
//                    ForEach(filteredCards) { card in
//                    NavigationLink {
//                        CardDetail(with_card: card)
//                    } label: {
//                        CardRow(card: card)
//                    }
//                }
//                .onDelete(perform: deleteCard)
//
//
//                }
//            }
//
//
//        }
//        .navigationTitle("Cards")
//    }
    

struct CardList_Previews: PreviewProvider {
    static var previews: some View {
        // ["iPhone SE (2nd generation)", "iPhone XS Max"]
        CardList().previewDevice(PreviewDevice(rawValue: "iPhone 12")).environmentObject(jsonData())
    }
}

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
                    }.onDelete(perform: deleteCard).listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                }.listStyle(PlainListStyle())

                .navigationBarTitle(Text("Cards List"), displayMode: .inline)
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
            .padding(0)
            //.background(Palette.background)
        }
    }
}
        
struct CardList_Previews: PreviewProvider {
    static var previews: some View {
        // ["iPhone SE (2nd generation)", "iPhone XS Max"]
        CardList().previewDevice(PreviewDevice(rawValue: "iPhone 12")).environmentObject(jsonData())
    }
}

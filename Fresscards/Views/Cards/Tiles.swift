//
//  Tiles.swift
//  Fresscards
//
//  Created by Alex Antipov on 06.07.2022.
//

import SwiftUI

struct Tiles: View {
    
    @EnvironmentObject var jsonData: jsonData
    
    @State var cards: [Card] = []
    @State private var addMode = false
    
    private func readAndShuffleCards(){
        self.cards = jsonData.cards
        self.cards.shuffle()
    }
    
    func findCardIndex(for_card:Card) -> Int {
//        log("findCardIndex forCard: \(for_card)")
        return cards.firstIndex(where: { $0.id == for_card.id })!
    }
    
    let tilesPadding:CGFloat = 10
    
    // https://betterprogramming.pub/swiftui-create-a-tinder-style-swipeable-card-view-283e257cb102
    private func getCardWidth(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        let offset: CGFloat = CGFloat(cards.count - 1 - id) * tilesPadding
        return geometry.size.width - offset
    }
    
    private func getCardOffset(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        return CGFloat(cards.count - 1 - id) * tilesPadding
    }
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    ZStack {
                        ForEach(self.cards, id: \.self) { card in
                            Group {
                                if (self.cards.count - 5)...self.cards.count ~= findCardIndex(for_card: card) {
                                    CardTile(card: card, onRemove: { removedCard in
                                        // Remove that user from our array
                                        withAnimation(.easeInOut(duration: 0.15)) { // add animation
                                            self.cards.removeAll { $0.id == removedCard.id }
                                        }
                                    })
//                                    .frame(width: self.getCardWidth(geometry, id: findCardIndex(for_card: card)), height: self.getCardWidth(geometry, id: findCardIndex(for_card: card)))
                                    .offset(x: 0, y: self.getCardOffset(geometry, id: findCardIndex(for_card: card)))
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .navigationBarTitle(Text("Cards"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.addMode = true
                } ) {
                    Image(systemName: "plus")
                        .padding([.leading, .top, .bottom])
                } )
                // invisible link inside NavigationView for add mode
                NavigationLink(destination: CardAdd(), isActive: $addMode) { EmptyView() }
            }.onAppear {
                self.readAndShuffleCards()
            }.padding()//.background(Palette.background)
        }
    }
}

struct Tiles_Previews: PreviewProvider {
    static var cards = jsonData().cards
    static var previews: some View {
        CardTile(card: cards[0], onRemove: { _ in })
    }
}

//
//  Tiles.swift
//  Fresscards
//
//  Created by Alex Antipov on 06.07.2022.
//

import SwiftUI

struct Tiles: View, EasyHardButtonsHandler {
    
    @EnvironmentObject var jsonData: jsonData
    
//    @EnvironmentObject var logic: CardsLogic
    
    @State var tiles: [Card] = []
    @State private var addMode = false
    
    private func readAndShuffleCards(){
        self.tiles = jsonData.cards
        self.tiles.shuffle()
        
    }
    
    // protocol EasyHardButtonsHandler method
    func reactionHandle(easy: Bool) {
        log("reactionHandle, easy: \(easy)")
        if var currentCard: Card = self.tiles.last {
            log("current card: \(currentCard.a)")

            
            currentCard.addReaction(easy: easy, jsonEngine: self.jsonData)
            
            withAnimation(.easeInOut(duration: 0.15)) { // add animation
                self.tiles.removeAll { $0.id == currentCard.id }
            }
            
        }
    }
    
    func findCardIndex(for_card:Card) -> Int {
//        log("findCardIndex forCard: \(for_card)")
        return tiles.firstIndex(where: { $0.id == for_card.id })!
    }
    
    let tilesPadding:CGFloat = 10
    
    // https://betterprogramming.pub/swiftui-create-a-tinder-style-swipeable-card-view-283e257cb102
    private func getCardWidth(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        let offset: CGFloat = CGFloat(tiles.count - 1 - id) * tilesPadding
        return geometry.size.width - offset
    }
    
    private func getCardOffset(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        return CGFloat(tiles.count - 1 - id) * tilesPadding
    }
    
//    func previewGetTileWidth(_ geometry: GeometryProxy) -> CGFloat {
//        max(geometry.size.width - 20.0, 0.0) // preventing negative values
//    }
//    
//    func previewCenterLocation(_ geometry: GeometryProxy) -> CGPoint {
//        let x = geometry.size.width / 2
//        let y = geometry.size.height / 2 - (geometry.size.height / 10)
//        return CGPoint(x:x, y:y)
//    }
    
    func easyHardButtonsPositions(_ geometry: GeometryProxy) -> CGPoint {
        let x = geometry.size.width / 2
        let y = geometry.size.height / 2 + (geometry.size.height / 2.5)
        return CGPoint(x:x, y:y)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    ZStack {
                        
                        if (self.tiles.count == 0) {
                            Text("No cards")
                        }
                        
                        ForEach(self.tiles, id: \.self) { card in
                            Group {
                                ZStack {
                                
                                if (self.tiles.count - 4)...self.tiles.count + 1 ~= findCardIndex(for_card: card) {
                                    
//                                    CardDummy().offset(x: 0, y: self.getCardOffset(geometry, id: findCardIndex(for_card: card)) - 5.0)
//                                    CardTile(card: card, onRemove: { removedCard in
//                                        // Remove that card from our array
//                                        withAnimation(.easeInOut(duration: 0.15)) { // add animation
//                                            self.cards.removeAll { $0.id == removedCard.id }
//                                        }
//                                    })
//                                    .offset(x: 0, y: self.getCardOffset(geometry, id: findCardIndex(for_card: card)))
                                    
                                    if (self.tiles.count - 5)...self.tiles.count ~= findCardIndex(for_card: card) {
                                        CardTile(card: card, reactionSubscriber: self, onRemove: { removedCard in
                                            // Remove that card from our array
                                            withAnimation(.easeInOut(duration: 0.15)) { // add animation
                                                self.tiles.removeAll { $0.id == removedCard.id }
                                            }
                                        })
                                        .offset(x: 0, y: self.getCardOffset(geometry, id: findCardIndex(for_card: card)))
                                    }
                                }
                                }
                                
                            }
                        }
                    }
//                    Spacer()
                    EasyHardButtons(reactionSubscriber: self)
                        .position(easyHardButtonsPositions(geometry))
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
//    static var cards = jsonData().cards
    static var previews: some View {
        Group {
            Tiles().environmentObject(jsonData())
        }
//        CardTile(card: cards[0], onRemove: { _ in })
    }
}

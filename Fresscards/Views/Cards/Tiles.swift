//
//  Tiles.swift
//  Fresscards
//
//  Created by Alex Antipov on 06.07.2022.
//


import SwiftUI


struct Tiles: View {
    
//        @EnvironmentObject var modelData: ModelData
    
    //    @State private var cardIndex: Int = 0 // Current card's index
    
    //    struct Card: Codable, Hashable, Identifiable {
    //        var id: Int
    //        var side_a: String
    //        var side_b: String
    //        var isFavorite: Bool = false
    //
    //    }
    
        @State var cards: [Card]
    
    init(withCards: [Card]){
        self.cards = withCards
    }
    
    func findCardIndex(for_card:Card) -> Int {
        cards.firstIndex(where: { $0.id == for_card.id })!
    }
    
//    @State var cards: [Card] = [
//        Card(id: 0, side_a: "0A", side_b: "0B", isFavorite: false),
//        Card(id: 1, side_a: "1A", side_b: "1B", isFavorite: false),
//        Card(id: 2, side_a: "2A", side_b: "2B", isFavorite: false),
//        Card(id: 3, side_a: "3A", side_b: "3B", isFavorite: false),
//        Card(id: 4, side_a: "4A", side_b: "4B", isFavorite: false),
//        Card(id: 5, side_a: "5A", side_b: "5B", isFavorite: false),
//        Card(id: 6, side_a: "6A", side_b: "6B", isFavorite: false)
//    ]
    //    @State private var currentCard: Card = ModelData().cards[0] // Current card
    
    let tilesPadding:CGFloat = 10
    
    // https://betterprogramming.pub/swiftui-create-a-tinder-style-swipeable-card-view-283e257cb102
    private func getCardWidth(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        let offset: CGFloat = CGFloat(cards.count - 1 - id) * tilesPadding
        return geometry.size.width - offset
    }
    
    
    private func getCardOffset(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        return  CGFloat(cards.count - 1 - id) * tilesPadding
    }
    
//    private var maxID: Int {
//        return self.cards.map { $0.id }.max() ?? 0
//    }
//
    
    
    
    var body: some View {
        
        VStack {
            GeometryReader { geometry in
                ZStack {
                    ForEach(self.cards, id: \.self) { card in
                        
                        
//                            if (self.maxID - 3)...self.maxID ~= card.id {
                                
                                

                                
                                CardTile(card: card, onRemove: { removedCard in
                                    // Remove that user from our array
                                    withAnimation(.easeInOut(duration: 0.15)) { // add animation
                                        self.cards.removeAll { $0.id == removedCard.id }
                                    }
                                    //                                let _ = print("Removed card \(removedCard.id)")
                                    
                                    
                                })
//                                .animation(.interactiveSpring())
                                .frame(width: self.getCardWidth(geometry, id: findCardIndex(for_card: card)), height: self.getCardWidth(geometry, id: findCardIndex(for_card: card)))
                                .offset(x: 0, y: self.getCardOffset(geometry, id: findCardIndex(for_card: card)))
//                                .border(Color.black)
//                                .environmentObject(modelData)
                                
//                            }
                        
                    }
                }
                Spacer()
            }
        }.padding()
    }
}



struct Tiles_Previews: PreviewProvider {
    static var cards = jsonData().cards
    static var previews: some View {
        CardTile(card: cards[0], onRemove: { _ in })
    }
}



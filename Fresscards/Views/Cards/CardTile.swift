//
//  CardTile.swift
//  Fresscards
//
//  Created by Alex Antipov on 05.07.2022.
//

import SwiftUI


struct CardTile: View {
//    static let gradientStart = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255)
//    static let gradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)
//
    @EnvironmentObject var jsonData: jsonData
    
    
    @State private var translation: CGSize = .zero
//    @State private var cardIndex = 0 // Current card's index
    @State var isTapped:Bool = false
    
    
    private var card: Card
    private var onRemove: (_ card: Card) -> Void
    private var thresholdPercentage: CGFloat = 0.3 // when the user has draged 50% the width of the screen in either direction
    
    
    init(card: Card, onRemove: @escaping (_ card: Card) -> Void) {
        self.card = card
        self.onRemove = onRemove
    }
    
    private func getGesturePercentage(_ geometry: GeometryProxy, from gesture: DragGesture.Value) -> CGFloat {
        gesture.translation.width / geometry.size.width
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                
                Group{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Palette.a)
                        .shadow(radius: 7)
                    
                        .offset(x: self.translation.width, y: self.translation.height)
                        .gesture(
                            TapGesture().onEnded {


                                isTapped = !isTapped

                            })
                        .gesture(
                            DragGesture()
                                .onChanged { value in
//                                    log(s:"aa")
                                    self.translation = value.translation
                                    if !self.isTapped {
                                        self.isTapped = true
                                    }
                                }
                                .onEnded { value in
//                                    log(s:"zzzzz")
                                    //                                if -value.predictedEndTranslation.width > geometry.size.width / 2, self.cardIndex < 5 {
                                    //                                    cardIndex += 1
                                    ////                                    currentCard = modelData.cards[cardIndex]
                                    //                                }
                                    //                                if value.predictedEndTranslation.width > geometry.size.width / 2, self.cardIndex > 0 {
                                    //                                    cardIndex -= 1
                                    ////                                    currentCard = modelData.cards[cardIndex]
                                    //                                }
                                    
                                    if abs(self.getGesturePercentage(geometry, from: value)) > self.thresholdPercentage {
                                        self.onRemove(self.card)
                                    } else {
                                        withAnimation(.interactiveSpring()) {
                                            self.translation = .zero
                                        }
    //                                    self.offset = .zero
                                    }
                                }
                        )
                        
                    
                    //                Text(card.side_a).offset(x: viewState.width, y: viewState.height)
                    VStack {
                        //                        Text(String(cardIndex))
                        Text(card.side_a)
                        Divider()
                        if (isTapped){
                            
                                Text(card.side_b)
                            
                        }
                    }.offset(x: self.translation.width, y: self.translation.height)
                }
//                .border(Color.red)
//                .offset(x: self.translation.width, y: self.translation.height)
//                .animation(nil, value: UUID())
            }
        }
    }
    
    
}

struct CardTile_Previews: PreviewProvider {
    static var cards = jsonData().cards
    static var previews: some View {
        CardTile(card: cards[0], onRemove: { _ in })
    }
}



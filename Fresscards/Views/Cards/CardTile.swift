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
    
    @State private var confirmationShown = false
    
    
    private var card: Card
    private var onRemove: (_ card: Card) -> Void
    //    private var thresholdDragDistance: CGFloat = 220
    private var thresholdPercentage: CGFloat = 0.5 // when the user has draged 50% the width of the screen in either direction
    
    
    init(card: Card, onRemove: @escaping (_ card: Card) -> Void) {
        self.card = card
        self.onRemove = onRemove
    }
    
    //    private var handler: ((Directions) -> Void)?
    private enum Directions: Int {
        case up, down, left, right, none
    }
    
    private func judgeGesture(_ geometry: GeometryProxy, from gesture: DragGesture.Value) -> Directions {
        
        let hDelta = gesture.translation.width
        let vDelta = gesture.translation.height
        
        let thresholdDistance = geometry.size.width * self.thresholdPercentage
        
        if (abs(hDelta) + abs(vDelta)) > thresholdDistance {
            //            log("distance: \(abs(hDelta) + abs(vDelta))")
            if abs(hDelta) > abs(vDelta) {
                return (hDelta < 0 ? .left : .right)
            } else {
                return (vDelta < 0 ? .up : .down)
            }
        } else {
            return .none
        }
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
                            DragGesture(minimumDistance: 3, coordinateSpace: .local)
                                .onChanged { value in
                                    self.translation = value.translation
                                    if !self.isTapped {
                                        self.isTapped = true
                                    }
                                }
                                .onEnded { value in
                                    
                                    let direction = self.judgeGesture(geometry, from: value)
                                    log("Direction: \(direction)")
                                    
                                    switch direction {
                                    case .none:
                                        // if drag distance threshold is not reached, return tile to initial position
                                        withAnimation(.interactiveSpring()) {
                                            self.translation = .zero
                                        }
                                    case .up:
                                        log("UP UP")
                                        self.confirmationShown = true
                                        withAnimation(.interactiveSpring()) {
                                            self.translation = .zero
                                        }
                                        
                                    default:
                                        // in other cases we assume that drag threshold distance is reached and card swiped
                                        self.onRemove(self.card)
                                    }
                                    
                                    //                                    if (dir == .none){
                                    //                                        withAnimation(.interactiveSpring()) {
                                    //                                            self.translation = .zero
                                    //                                        }
                                    //                                    } else {
                                    //                                        self.onRemove(self.card)
                                    //                                    }
                                    
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
                .confirmationDialog(
                    "Are you sure?",
                    isPresented: $confirmationShown
                ) {
                    Button("Delete this card?", role: .destructive) {
                        log("Removing card")
                        jsonData.removeCard(withId: card.id)
                        withAnimation {
                            self.onRemove(self.card)
                        }
                    }
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



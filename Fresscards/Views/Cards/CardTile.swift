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
    
//    var initialCardPosition: CGPoint {
//        let x = UIScreen.main.bounds.width / 2
//        let y = UIScreen.main.bounds.height / 2
//        return CGPoint(x:x,y:y)
//    }
//
    @State var geometryWidth: CGFloat = 0.0 // sets on appear and used in judjeGesture()
    
    @State private var location: CGPoint = CGPoint(x: 0, y: 0)
    @GestureState private var fingerLocation: CGPoint? = nil
    @GestureState private var startLocation: CGPoint? = nil
    
    func moveToCenterOnAppear(_ geometry: GeometryProxy){
        self.geometryWidth = geometry.size.width
        let x = geometry.size.width / 2
        let y = geometry.size.height / 2
        self.location = CGPoint(x:x, y:y)
    }
    
    func getTileWidth(_ geometry: GeometryProxy) -> CGFloat {
        let width = max(geometry.size.width - 20.0, 0.0) // preventing negative values
        log("tile width: \(width)")
        return width
    }
    
    var simpleDrag: some Gesture {
        DragGesture(minimumDistance: 3, coordinateSpace: .local)
            .onChanged { value in
                var newLocation = startLocation ?? location
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                self.location = newLocation
            }.updating($startLocation) { (value, startLocation, transaction) in
                startLocation = startLocation ?? location
            }
            .onEnded { value in
                let direction = self.judgeGesture(from: value)
                log("Direction: \(direction)")
                switch direction {
                case .none:
                    // if drag distance threshold is not reached, return tile to initial position
                    withAnimation(.interactiveSpring()) { self.translation = .zero }
                case .up:
                    self.confirmationShown = true
                    withAnimation(.interactiveSpring()) { self.translation = .zero }
                default:
                    // in other cases we assume that drag threshold distance is reached and card swiped
                    self.onRemove(self.card)
                }
            }
    }
    
    var fingerDrag: some Gesture {
        DragGesture(minimumDistance: 3, coordinateSpace: .local)
            .updating($fingerLocation) { (value, fingerLocation, transaction) in
                fingerLocation = value.location
            }
    }
    
    
    
    @State private var translation: CGSize = .zero
    //    @State private var cardIndex = 0 // Current card's index
    @State var isTapped:Bool = false
    
    @State private var confirmationShown = false
    
    
    private var card: Card
    private var onRemove: (_ card: Card) -> Void
    //    private var thresholdDragDistance: CGFloat = 220
    private var thresholdPercentage: CGFloat = 0.4 // when the user has draged 50% the width of the screen in either direction
    
    
    init(card: Card, onRemove: @escaping (_ card: Card) -> Void) {
        self.card = card
        self.onRemove = onRemove
    }
    
    //    private var handler: ((Directions) -> Void)?
    private enum Directions: Int {
        case up, down, left, right, none
    }
    
    private func judgeGesture(from gesture: DragGesture.Value) -> Directions {
        
        let hDelta = gesture.translation.width
        let vDelta = gesture.translation.height
        
        let thresholdDistance = self.geometryWidth * self.thresholdPercentage
        
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
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Palette.a)
                            .frame(
                                width: getTileWidth(geometry),
                                height: getTileWidth(geometry)
                            )
                            .shadow(radius: 7)
//                            .offset(x: self.translation.width, y: self.translation.height)
                            .position(location)
                            .onAppear { self.moveToCenterOnAppear(geometry) }
                            .gesture(TapGesture().onEnded { isTapped = !isTapped })
                            .gesture(simpleDrag.simultaneously(with: fingerDrag))
                        VStack {
                            Text(card.a)
//                            Divider()
                            if (isTapped){ Text(card.b) }
                        }.position(location)//.offset(x: self.translation.width, y: self.translation.height)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.pink.opacity(0.6))
                                .frame(width: 100, height: 100)
                                .position(location)
                                .gesture(simpleDrag.simultaneously(with: fingerDrag))
                            if let fingerLocation = fingerLocation {
                                Circle()
                                    .stroke(Color.green, lineWidth: 2)
                                    .frame(width: 44, height: 44)
                                    .position(fingerLocation)
                            }
                        }
                    }
                    .confirmationDialog(
                        "Are you sure?",
                        isPresented: $confirmationShown
                    ) {
                        Button("Delete this card?", role: .destructive) {
                            log("Removing card")
                            jsonData.removeCard(withId: card.id)
                            withAnimation { self.onRemove(self.card) }
                        }
                    }
                } // ZStack
            } // Group
        } // ZStack
    } // GeometryReader
}

struct CardTile_Previews: PreviewProvider {
    static var cards = jsonData().cards
    static var previews: some View {
        CardTile(card: cards[0], onRemove: { _ in })
    }
}



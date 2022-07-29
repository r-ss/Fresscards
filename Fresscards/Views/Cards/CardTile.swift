//
//  CardTile.swift
//  Fresscards
//
//  Created by Alex Antipov on 05.07.2022.
//

import SwiftUI


struct CardTile: View {
    @EnvironmentObject var jsonData: jsonData
    
    @State var geometryWidth: CGFloat = 0.0 // sets on appear and used in judjeGesture()
    @State private var centerLocation: CGPoint = CGPoint(x: 0, y: 0) // used in dragJudge if threshhold not reached
    
    @State private var location: CGPoint = CGPoint(x: 0, y: 0)
    @GestureState private var fingerLocation: CGPoint? = nil
    @GestureState private var startLocation: CGPoint? = nil
    
    
    func moveToCenterOnAppear(_ geometry: GeometryProxy){
        self.geometryWidth = geometry.size.width
        let x = geometry.size.width / 2
        let y = geometry.size.height / 2 - (geometry.size.height / 10)
        self.centerLocation = CGPoint(x:x, y:y)
        self.location = CGPoint(x:x, y:y)
    }
    
    func getTileWidth(_ geometry: GeometryProxy) -> CGFloat {
        max(geometry.size.width - 20.0, 0.0) // preventing negative values
    }
    
    func getMaxTextWidth(_ geometry: GeometryProxy) -> CGFloat {
        max(geometry.size.width - 60.0, 80.0) // preventing negative values
    }
    
    @State var opacityGestureHintEasy: Double = 0.0
    @State var opacityGestureHintHard: Double = 0.0
    
    var simpleDrag: some Gesture {
        DragGesture(minimumDistance: 3, coordinateSpace: .local)
            .onChanged { value in
                var newLocation = startLocation ?? location
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                showSideB = true
                
                let hDelta = value.translation.width
                if (abs(hDelta) > 50){
                    if (hDelta > 0) {
                        withAnimation(.easeOut(duration: 0.2)) {
                            opacityGestureHintEasy = 1.0
                            opacityGestureHintHard = 0.0
                        }
                    } else {
                        withAnimation(.easeOut(duration: 0.2)) {
                            opacityGestureHintEasy = 0.0
                            opacityGestureHintHard = 1.0
                        }
                    }
                } else {
                    withAnimation(.easeOut(duration: 0.2)) {
                        opacityGestureHintEasy = 0.0
                        opacityGestureHintHard = 0.0
                    }
                }

                
                
                
                
                withAnimation(.easeOut(duration: 0.1)) {
                    self.location = newLocation
                }
            }.updating($startLocation) { (value, startLocation, transaction) in
                startLocation = startLocation ?? location
            }
            .onEnded { value in
                let direction = self.judgeGesture(from: value)
                log("Direction: \(direction)")
                switch direction {
                case .none:
                    // if drag distance threshold is not reached, return tile to initial position
                    withAnimation(.interactiveSpring()) { self.location = self.centerLocation }
                case .up:
                    self.confirmationShown = true
                    withAnimation(.interactiveSpring()) { self.location = self.centerLocation }
                default:
                    // in other cases we assume that drag threshold distance is reached and card swiped
                    self.onRemove(self.card)
                }
            }
    }
    
    
    @State private var translation: CGSize = .zero
    @State var showSideB:Bool = false
    var opacitySideB: Double {
        showSideB ? 1.0 : 0.0
    }
    
    @State private var confirmationShown = false
    
    var calculateRotation: Double {
        Double((self.location.x - self.centerLocation.x) / 30)
    }
    

    
    private var card: Card
    private var onRemove: (_ card: Card) -> Void
    private var thresholdPercentage: CGFloat = 0.4 // when the user has draged 50% the width of the screen in either direction
    
    let settingsManager = SettingsManager()
    
    var aOptionallyCapitalized: String {
        settingsManager.getBoolValue(name: "AutoCapitalization") ? card.a.firstWordCapitalization() : card.a
    }
    
    var bOptionallyCapitalized: String {
        settingsManager.getBoolValue(name: "AutoCapitalization") ? card.b.firstWordCapitalization() : card.b
    }
    
    init(card: Card, onRemove: @escaping (_ card: Card) -> Void) {
        self.card = card
        self.onRemove = onRemove
    }
    
    private enum Directions: Int {
        case up, down, left, right, none
    }
    
    private func judgeGesture(from gesture: DragGesture.Value) -> Directions {
        
        let hDelta = gesture.translation.width
        let vDelta = gesture.translation.height
        let thresholdDistance = self.geometryWidth * self.thresholdPercentage
        
        if (abs(hDelta) + abs(vDelta)) > thresholdDistance {
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
                        // BACKGROUND
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Palette.cardBackground)
                            .frame(
                                width: getTileWidth(geometry),
                                height: getTileWidth(geometry)
                            )
                            .shadow(radius: 7)
                            .onAppear { self.moveToCenterOnAppear(geometry) }
                        // CONTENT
                        VStack(alignment: .center, spacing: 15) {
                                
                                Text(aOptionallyCapitalized)
                                    .font(.system(size: 28, weight: .light, design: .serif))
                                    .foregroundColor(Palette.cardTextA)
                                    .frame(maxWidth: getMaxTextWidth(geometry))
                                Text(bOptionallyCapitalized)
                                    .font(.system(size: 18, weight: .light, design: .serif))
                                    .foregroundColor(Palette.cardTextB)
                                //                                .italic()
                                    .opacity(opacitySideB)
                                    .frame(maxWidth: getMaxTextWidth(geometry))
                        }
                        .offset(x:0,y:15)
                        HStack {
                            
                            Text("HARD").foregroundColor(Palette.difficultyHard)
                                .position(x: -getTileWidth(geometry)/2 + 230, y: getTileWidth(geometry)/2 + 20)
                                .opacity(opacityGestureHintEasy)
                            
                            Text("EASY").foregroundColor(Palette.difficultyEasy)
                                .position(x: getTileWidth(geometry)/2 - 50, y: getTileWidth(geometry)/2 + 20)
                                .opacity(opacityGestureHintHard)
                        }
                    }
                    .position(location)
                    .rotationEffect(.degrees(calculateRotation), anchor: .bottom)
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
            .gesture(TapGesture().onEnded {
                if showSideB {
                    withAnimation { self.onRemove(self.card) }
                } else {
                    showSideB = true
                }
                
            })
            .gesture(simpleDrag)//.simultaneously(with: fingerDrag))
        } // ZStack
    } // GeometryReader
}

struct CardTile_Previews: PreviewProvider {
    static var cards = jsonData().cards
    static var previews: some View {
        CardTile(card: cards[26], onRemove: { _ in }).environmentObject(jsonData())
    }
}



//
//  CardTile.swift
//  Fresscards
//
//  Created by Alex Antipov on 03.04.2023.
//

import SwiftUI


struct CardView: View {
    
    private let vibration = UIImpactFeedbackGenerator(style: .medium)
    
    @State var geometryWidth: CGFloat = 0.0 // sets on appear and used in judgeGesture()
    @State private var centerLocation: CGPoint = CGPoint(x: 0, y: 0) // used in dragJudge if threshhold not reached
    
    @State private var downPointLocation: CGPoint = CGPoint(x: 0, y: 300) // used to animate save action
    
    @State private var location: CGPoint = CGPoint(x: 0, y: 0)
    @GestureState private var fingerLocation: CGPoint? = nil
    @GestureState private var startLocation: CGPoint? = nil
    
    
    @ObservedObject var viewModel = CardEditorViewModel(card: nil)
    
    
    private func createCardFromTile() {
        log("> createCardFromTile")
//        let new = Card(id:UUID(), side_a: self.side_a, side_b: self.side_b, created_at: Date(), origin: .user)
        
//        print(new)
//        jsonData.add(card: new)
        
        viewModel.editingCard = Card(id: UUID(), side_a: card.side_a, side_b: card.side_b, created_at: Date(), origin: .generator)
        
        
//        viewModel.editingCard.side_a = card.side_a
//        viewModel.editingCard.side_b = card.side_b
//        viewModel.editingCard.origin = .generator
        
        
        withAnimation {
            viewModel.saveCard()
        }
        
        
    }
    
    
    private func moveToCenterOnAppear(_ geometry: GeometryProxy){
        self.geometryWidth = geometry.size.width
        let x = geometry.size.width / 2
        // let y = geometry.size.height / 2 - (geometry.size.height / 10) - 200
        self.centerLocation = CGPoint(x:x, y:0)
        self.location = CGPoint(x:x, y:0)
        
        self.downPointLocation = CGPoint(x:x, y:geometry.size.height + 150)
    }
    
    private func getTileWidth(_ geometry: GeometryProxy) -> CGFloat {
        let candidate = max(geometry.size.width - 20.0, 0.0) // preventing negative values
        
        return [candidate, 400].min()!
    }
    
    private func getMaxTextWidth(_ geometry: GeometryProxy) -> CGFloat {
        max(geometry.size.width - 60.0, 80.0) // preventing negative values
    }
    
//    @State var opacityGestureHintEasy: Double = 0.0
//    @State var opacityGestureHintHard: Double = 0.0
    @State var opacityGestureHintSave: Double = 0.0
    
    private var simpleDrag: some Gesture {
        DragGesture(minimumDistance: 3, coordinateSpace: .local)
            .onChanged { value in
                var newLocation = startLocation ?? location
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                showSideB = true
                
//                let hDelta = value.translation.width
                let vDelta = value.translation.height
                
//                if (abs(hDelta) > 50){
//                    if (hDelta > 0) {
//                        withAnimation(.easeOut(duration: 0.2)) {
//                            opacityGestureHintEasy = 1.0
//                            opacityGestureHintHard = 0.0
//                        }
//                    } else {
//                        withAnimation(.easeOut(duration: 0.2)) {
//                            opacityGestureHintEasy = 0.0
//                            opacityGestureHintHard = 1.0
//                        }
//                    }
//                } else {
//                    withAnimation(.easeOut(duration: 0.2)) {
//                        opacityGestureHintEasy = 0.0
//                        opacityGestureHintHard = 0.0
//                    }
//                }
                
                //                if (abs(vDelta) > 100){
                
                if !savingDisabled {
                    if (vDelta > 100) {
                        withAnimation(.easeOut(duration: 0.2)) {
                            opacityGestureHintSave = 1.0
                        }
                    } else {
                        withAnimation(.easeOut(duration: 0.2)) {
                            opacityGestureHintSave = 0.0
                        }
                    }
                }
                //                }
                
                
                
                
                
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
                    
                    
                    // TODO: About animations: https://medium.com/@amosgyamfi/learning-swiftui-spring-animations-the-basics-and-beyond-4fb032212487
                    
                    
                    withAnimation(.interpolatingSpring(stiffness: 120, damping: 14)) {
                        self.location = self.centerLocation
                        opacityGestureHintSave = 0.0
                    }
                    //                case .up:
                    //                    self.onRemove(self.card)
                    //
                    //                    withAnimation(.interpolatingSpring(stiffness: 120, damping: 14)) { self.location = self.centerLocation }
                    //                case .left:
                    //                    self.onRemove(self.card)
                    //                    withAnimation(.interpolatingSpring(stiffness: 120, damping: 14)) { self.location = self.centerLocation }
                    //                case .right:
                    //                    self.onRemove(self.card)
                    //                    withAnimation(.interpolatingSpring(stiffness: 120, damping: 14)) { self.location = self.centerLocation }
                case .down:
                    
                    if !savingDisabled {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            print("delay tick")
                            self.onRemove(self.card)
                            
                            
                        }
                        
                        
                        print("Saving....")
                        createCardFromTile()
                        
                        Notification.fire(name: .cardSavedFromGenerator)
                        
                        withAnimation(.interpolatingSpring(stiffness: 120, damping: 14)) { self.location = self.downPointLocation }
                    } else {
                        self.onRemove(self.card)
                    }
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
    
    var calculateRotation: Double {
        Double((self.location.x - self.centerLocation.x) / 30)
    }
    
    private var card: Card
    private var savingDisabled: Bool = false
    private var onRemove: (_ card: Card) -> Void
    
    private var thresholdPercentage: CGFloat = 0.3 // when the user has draged 50% the width of the
    
//    init(item: NeuralResponseItem, onRemove: @escaping (_ card: NeuralResponseItem) -> Void) {
//        self.card = Card(id:UUID(), side_a: item.side_a, side_b: item.side_b)
//        self.onRemove = onRemove
//
//    }
    
    init(card: Card, savingDisabled: Bool, onRemove: @escaping (_ card: Card) -> Void) {
        self.card = card
        self.savingDisabled = savingDisabled
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
                            .shadow(color: Palette.cardBackground.darker(), radius: 6)
                        
                        // CONTENT
                        VStack(alignment: .center, spacing: 15) {
                            
                            Text(card.side_a)
                                .font(.system(size: 36, weight: .light, design: .serif))
                                .foregroundColor(Palette.cardTextA)
                                .frame(maxWidth: getMaxTextWidth(geometry))
                            Text(card.side_b)
                                .font(.system(size: 20, weight: .light, design: .serif))
                                .foregroundColor(Palette.cardTextB)
                                .opacity(opacitySideB)
                                .frame(maxWidth: getMaxTextWidth(geometry))
                        }
                        .offset(x:0,y:5)
                        
                        Text("Save").foregroundColor(Palette.cardTextA)
                        
                            .font(.biggerTextField)
                            .frame(width: getTileWidth(geometry) - 60, height: 40, alignment: .center)
                            .padding(0)
                            .position(x: getTileWidth(geometry)/2 + 9, y: 55)
                            .opacity(opacityGestureHintSave)
                        
                        
                        
                        
                        //                            Text("EASY").foregroundColor(Palette.b)
                        //                                .position(x: getTileWidth(geometry)/2 - 50, y: getTileWidth(geometry)/2 + 20)
                        //                                .opacity(opacityGestureHintHard)
                        
                    } // ZStack
                    
                } // Group
                .offset(x:0,y: getTileWidth(geometry) / 2)
                .position(location)
                .rotationEffect(.degrees(calculateRotation), anchor: .bottom)
                .gesture(TapGesture().onEnded {
                    if showSideB {
                        withAnimation { self.onRemove(self.card) }
                    } else {
                        showSideB = true
                        vibration.impactOccurred()
                    }
                    
                })
                .gesture(simpleDrag)
            } // ZStack
            //            .background(.pink)
            .frame(width: geometry.size.width, height: 400)
            .onAppear { self.moveToCenterOnAppear(geometry) }
            
        } // GeometryReader
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CardView(card: Card.mocked.card1, savingDisabled: false, onRemove: { _ in
                
            })
        }
    }
}

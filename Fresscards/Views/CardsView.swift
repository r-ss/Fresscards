//
//  Tiles.swift
//  Fresscards
//
//  Created by Alex Antipov on 03.04.2023.
//

import SwiftUI

struct CardsView: View {
    
    //    var response: NeuralResponse?
    @ObservedObject var cardsWorker: CardsWorker
    @State var savingDisabled: Bool = false
    
    @AppStorage("swide_down_to_save_action_learned") var swipeDownToSaveLearned: Bool = false
    
    @Environment(\.dismiss) private var dismiss // to allow navigate back ti generator parameters screen
    
    @State private var cards: [Card] = []
    
    //    @State var tiles: [NeuralResponseItem]
    
    @State private var showTableScreen = false
    
    //    var cards: [Card] {
    //
    //        var cardsBin: [Card] = []
    //
    //        // converting [NeuralResponseItem] to [Card]
    //        for item in cardsWorker.cards {
    //            cardsBin.append( Card(id:UUID(), side_a: item.side_a, side_b: item.side_b) )
    //        }
    //
    //
    //        return cardsBin
    //
    //    }
    
    //    init(cardsWorker: CardsWorker) {
    //
    //        self.cardsWorker = cardsWorker
    //
    //        var cardsBin: [Card] = []
    //
    //        // converting [NeuralResponseItem] to [Card]
    //        for item in cardsWorker.cards {
    //            cardsBin.append( Card(id:UUID(), side_a: item.side_a, side_b: item.side_b) )
    //        }
    //
    //
    //        self.cards = cardsBin
    //    }
    //
    
    
    
    func findCardIndex(for_card:Card) -> Int {
        //        log("findCardIndex forCard: \(for_card)")
        return cards.firstIndex(where: { $0.id == for_card.id })!
    }
    
    let tilesPadding:CGFloat = 10
    
    //    func deleteCard(card:NeuralResponseItem) -> Void {
    //        cardsWorker.result?.result.removeAll { $0.side_a == card.side_a }
    //    }
    
    //    // https://betterprogramming.pub/swiftui-create-a-tinder-style-swipeable-card-view-283e257cb102
    //    private func getCardWidth(_ geometry: GeometryProxy, id: Int) -> CGFloat {
    //        let offset: CGFloat = CGFloat(tiles.count - 1 - id) * tilesPadding
    //        return [geometry.size.width - offset, 400].min()!
    //    }
    
    private func getCardOffset(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        return CGFloat(cards.count - 1 - id) * tilesPadding
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
    
    //    func easyHardButtonsPositions(_ geometry: GeometryProxy) -> CGPoint {
    //        let x = geometry.size.width / 2
    //        let y = geometry.size.height / 2 + (geometry.size.height / 2.5)
    //        return CGPoint(x:x, y:y)
    //    }
    
    var body: some View {
        //        NavigationStack {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    
                    if (self.cards.count == 0) {
                        
                        VStack(spacing: 30){
                            
                            if !savingDisabled {
                                Button() {
                                    showTableScreen = true
                                } label: {
                                    Label("Review", systemImage: "list.bullet.clipboard")
                                }
                            }
                            
                            Button {
                                dismiss()
                                
                            } label: {
                                HStack {
                                    Image(systemName: "chevron.backward")
                                    Text("Back")
                                }
                            }
                        }
                    }
                    
                    VStack {
                        
                        Group {
                            ZStack {
                                ForEach(self.cards, id: \.self) { card in
                                    //                                                                    Text(card.side_a)
                                    
                                    //                                if (self.tiles.count - 4)...self.tiles.count + 1 ~= findCardIndex(for_card: card) {
                                    
                                    if (self.cards.count - 5)...self.cards.count ~= findCardIndex(for_card: card) {
//                                        ZStack {
                                            CardView(card: card, savingDisabled: savingDisabled, onRemove: { removedCard in
                                                // Remove that card from our array
                                                withAnimation(.easeInOut(duration: 0.15)) { // add animation
                                                    //                                                self.tiles.removeAll { $0.id == removedCard.id }
                                                    self.cards.removeAll { $0.side_a == removedCard.side_a }
                                                    cardsWorker.cards.removeAll { $0.side_a == removedCard.side_a }
                                                }
                                            })
                                            .offset(x: 0, y: self.getCardOffset(geometry, id: findCardIndex(for_card: card)))
//                                            Text("index: \(findCardIndex(for_card: card))")
//                                                .foregroundColor(.white)
//                                        }
                                    }
                                    //                                }
                                }
                                
                            }
                        }
                        Spacer()
                        if !swipeDownToSaveLearned && !savingDisabled {
                            Text("Swipe card down to save on your list")
                        }
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .onAppear {
                    
                    // Subscribing to card save notification
                    NotificationCenter.simple(name: .cardSavedFromGenerator){
                        if !swipeDownToSaveLearned {
                            print("Setting swipeDownToSaveLearned to true...")
                            swipeDownToSaveLearned = true
                        }
                    }
                    
                    
                    
                    var cardsBin: [Card] = []
                    
                    // converting [NeuralResponseItem] to [Card]
                    for item in cardsWorker.cards {
                        cardsBin.append( Card(id:UUID(), side_a: item.side_a, side_b: item.side_b) )
                    }
                    
                    
                    self.cards = cardsBin
                    
                    
                }
                //                .background(.red)
                //                    Spacer()
                
                //                NavigationLink(
                //                    destination: CardsListView(response: cardsWorker.result, titleTheme: cardsWorker.result?.request.theme), isActive: $showTableScreen) { }
                
                //                NavigationLink(
                //                     destination: Verification(phoneLoginData: phoneLoginData),
                //                     isActive: $phoneLoginData.goToVerify) {
                //                          Text("")
                //                               .hidden()
                //                     }
                
                
            }
            .navigationBarTitle(Text( cardsWorker.result?.request.theme ?? ""))
            .toolbar {
                
                if !savingDisabled {
                    Button() {
                        showTableScreen = true
                    } label: {
                        Label("List", systemImage: "list.bullet.clipboard")
                    }
                }
                
            }
            .navigationDestination(isPresented: $showTableScreen) {
                GeneratedCardsReviewView(response: cardsWorker.result, titleTheme: cardsWorker.result?.request.theme)
            }
            .navigationTitle( cardsWorker.result?.request.theme ?? "" )
            //            .navigationDestination(
            //                 isPresented: $showTableScreen) {
            //                 }
            //                .navigationBarItems(trailing: Button(action: {
            //                    self.addMode = true
            //                } ) {
            //                    Image(systemName: "plus")
            //                        .padding([.leading, .top, .bottom])
            //                } )
            // invisible link inside NavigationView for add mode
        }
        .padding()//.background(Palette.background)
        //        }
        //        .onAppear {
        //
        //            if let resp = response {
        //                self.tiles = resp.result
        //            } else {
        //                print("nonon")
        //            }
        //                }
    }
}

struct CardsView_Previews: PreviewProvider {
    static let cw = CardsWorker()
    
    static var previews: some View {
        let result = NeuralResponse.mocked.response1
        NavigationStack {
            CardsView(cardsWorker: cw).onAppear {
                cw.resultReceived(result)
            }
            .navigationTitle("Pick color")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text("Back")
                        }
                    }
                }
            }
        }
        
    }
}

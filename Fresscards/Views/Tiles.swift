//
//  Tiles.swift
//  Fresscards
//
//  Created by Alex Antipov on 03.04.2023.
//

import SwiftUI

struct Tiles: View {
    
    //    var response: NeuralResponse?
    @ObservedObject var cardsWorker: CardsWorker
    
    @Environment(\.dismiss) private var dismiss // to allow navigate back ti generator parameters screen
    
    
    //    @State var tiles: [NeuralResponseItem]
    
    @State private var showTableScreen = false
    
    var tiles: [NeuralResponseItem] {
        
        //        if cardsWorker.result != nil {
        //            return cardsWorker.result!.result
        //        } else {
        //            return []
        //        }
        
        return cardsWorker.cards
        
    }
    
    
    func findCardIndex(for_card:NeuralResponseItem) -> Int {
        //        log("findCardIndex forCard: \(for_card)")
        return tiles.firstIndex(where: { $0.side_a == for_card.side_a })!
    }
    
    let tilesPadding:CGFloat = 5
    
    //    func deleteCard(card:NeuralResponseItem) -> Void {
    //        cardsWorker.result?.result.removeAll { $0.side_a == card.side_a }
    //    }
    
//    // https://betterprogramming.pub/swiftui-create-a-tinder-style-swipeable-card-view-283e257cb102
//    private func getCardWidth(_ geometry: GeometryProxy, id: Int) -> CGFloat {
//        let offset: CGFloat = CGFloat(tiles.count - 1 - id) * tilesPadding
//        return [geometry.size.width - offset, 400].min()!
//    }
    
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
                    
                    if (self.tiles.count == 0) {
                        //                        Text("No cards")
                        
                        VStack(spacing: 30){
                            Button() {
                                showTableScreen = true
                            } label: {
                                Label("Review", systemImage: "list.bullet.clipboard")
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
                    
                    
                    ForEach(self.tiles, id: \.self) { card in
                        Group {
                            ZStack {
                                //                                Text(card.side_a)
                                
                                //                                if (self.tiles.count - 4)...self.tiles.count + 1 ~= findCardIndex(for_card: card) {
                                
                                //                                    if (self.tiles.count - 5)...self.tiles.count ~= findCardIndex(for_card: card) {
                                CardTile(card: card, onRemove: { removedCard in
                                    // Remove that card from our array
                                    withAnimation(.easeInOut(duration: 0.15)) { // add animation
                                        //                                                self.tiles.removeAll { $0.id == removedCard.id }
                                        cardsWorker.cards.removeAll { $0.side_a == removedCard.side_a }
                                    }
                                })
                                .offset(x: 0, y: self.getCardOffset(geometry, id: findCardIndex(for_card: card)))
                                //                                    }
                                //                                }
                            }
                            
                        }
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
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
                Button() {
                    showTableScreen = true
                } label: {
                    Label("List", systemImage: "list.bullet.clipboard")
                }
                
            }
            .navigationDestination(isPresented: $showTableScreen) {
                CardsListView(response: cardsWorker.result, titleTheme: cardsWorker.result?.request.theme)
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

struct Tiles_Previews: PreviewProvider {
    static var previews: some View {
        Tiles(cardsWorker: CardsWorker())
    }
}

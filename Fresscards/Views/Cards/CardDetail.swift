//
//  CardDetail.swift
//  Fresscards
//
//  Created by Alex Antipov on 05.07.2022.
//

import SwiftUI

struct CardDetail: View {
//    @Environment(\.editMode) var editMode
    
    @EnvironmentObject var jsonData: jsonData
    @State var card: Card
//    @Binding var card: Card
//    @State var inputTextA: String
//    @State var inputTextB: String
    
    // compute the index of the input card by comparing it with the model data
//    var cardIndex: Int {
//        jsonData.cards.firstIndex(where: { $0.id == self.card.id })!
//    }
    
    
//    @State var item: Item

//    init(item: Item) {
//        _item = State(initialValue: item)
//    }
    
    
    init(with_card: Card) {
        _card = State(initialValue: with_card)
//        _inputTextA = State(initialValue: with_card.side_a)
//        _inputTextB = State(initialValue: with_card.side_b)

    }
    


    
    private func enter_side_a(text: String) {
        self.card.a = text
//        jsonData.cards[cardIndex] = card
        jsonData.update(card: self.card)
    }
    
    private func enter_side_b(text: String) {
        self.card.b = text
        jsonData.update(card: self.card)
    }
    
    private func save_edited_fields() {
//        self.card.side_b = text
        jsonData.update(card: self.card)
    }

    var body: some View {
            VStack {
                
//                HStack {
//                    Spacer()
//                    EditButton()
//                }
                
//                FavoriteButton(isSet: $modelData.cards[cardIndex].isFavorite)
                                
                
                Text("Side A:")
                TextField("Enter text...", text: $card.a)
                .onSubmit {
                    save_edited_fields()
                }
                Divider()
                Text("Side B:")
                TextField("Enter text...", text: $card.b)
                .onSubmit {
                    save_edited_fields()
                }
                
//                if editMode?.wrappedValue == .inactive {
//                    Text("Profile Viewer")
//                } else {
//                    Text("Profile Editor")
//                }
                
//                Group {
//                            TextField("Write something", text: $inputText)
////
//                            .onSubmit {
//                                enter_side_b(text: inputText)
//                            }
//                        }
//                Text(card.side_b)
                
            }.padding()
        }
}

struct CardDetail_Previews: PreviewProvider {
    static var cards = jsonData().cards
    static var previews: some View {
        CardDetail(with_card: cards[0])
    }
}

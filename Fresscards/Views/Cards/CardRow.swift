//
//  CardRow.swift
//  Fresscards
//
//  Created by Alex Antipov on 05.07.2022.
//

import SwiftUI

struct CardRow: View {
    var card: Card

    var body: some View {
            HStack {
                Text(card.a)
                Spacer()
                Text(card.b)
                
//                if card.isFavorite {
//                    Spacer()
//                    Image(systemName: "star.fill")
//                        .foregroundColor(.yellow)
//                }

//                Spacer()
            }.padding()
        }
}

struct CardRow_Previews: PreviewProvider {
    static var cards = jsonData().cards
    static var previews: some View {
        Group {
            CardRow(card: cards[0])
            CardRow(card: cards[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}

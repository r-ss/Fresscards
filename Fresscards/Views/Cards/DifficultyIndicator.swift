//
//  DifficultyIndicator.swift
//  Fresscards
//
//  Created by Alex Antipov on 29.07.2022.
//

import SwiftUI

struct DifficultyIndicator: View {
    
    @EnvironmentObject var jsonData: jsonData
    var for_card: Card
    
    var body: some View {
        if let color = for_card.difficultyColor {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
        } else {
            Circle()
                .fill(Color.blue)
                .frame(width: 8, height: 8)
                .opacity(0)
        }
    }
}

struct DifficultyIndicator_Previews: PreviewProvider {
    static var cards = jsonData().cards
    static var previews: some View {
        DifficultyIndicator(for_card: cards[0])
    }
}

//
//  CardsWorker.swift
//  Fresscards
//
//  Created by Alex Antipov on 04.04.2023.
//

import Foundation

class CardsWorker: ObservableObject {
    
    @Published var result: NeuralResponse?
    @Published var cards: [NeuralResponseItem] = []
    
    func resultReceived(_ result: NeuralResponse) {
        self.result = result
        self.cards = result.result
        
    }
    
    func cardsFill(_ cards: [Card]) {
        self.result = result
        
        var bin: [NeuralResponseItem] = []
        for card in cards {
            bin.append( NeuralResponseItem(side_a: card.side_a, side_b: card.side_b))
        }
        
        bin.shuffle()
        
        self.cards = bin
        
    }
    
}

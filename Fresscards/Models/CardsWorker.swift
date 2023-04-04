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
    
}

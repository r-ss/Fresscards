//
//  Config.swift
//  Fresscards
//
//  Created by Alex Antipov on 23.07.2022.
//

import Foundation

struct Config {
    
    // Files with predefined cards, used on initial app startup
        static let bakedCardsCSVsNames: [String] = ["base", "book_a1", "ru_poliglot", "verbs"]
//    static let bakedCardsCSVsNames: [String] = ["base"]
    
    static let maximumAnswersItemsForCard: Int = 12 // no more Easy/Hard reactions is stored for every card
    
    static let cardFieldCharacterLimit: Int = 10 // maximum length of text on the cards
    
}

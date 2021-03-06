//
//  Card.swift
//  Fresscards
//
//  Created by Alex Antipov on 04.07.2022.
//

import Foundation
import SwiftUI

enum CardOrigin: String, Codable {
    case baked, user
}

enum CardDifficulty: String {
    case none, easy, medium, hard
}

struct CardWireframe: Codable {
    // Used only to parse initial cards with just 2 text fields
    var a: String
    var b: String
}

struct Answer: Codable, Hashable {
    var easy: Bool
    var commited: Date
}

struct Card: Codable, Hashable, Identifiable {
    var id: UUID
    var a: String // max 60
    var b: String // max 60
    var added: Date?
    var answers: [Answer]?
    var origin: CardOrigin?
    
    var easyAnswers: Int {
        if let a = self.answers {
            return a.filter{$0.easy == true}.count
        } else {
            return 0
        }
    }
    
    var hardAnswers: Int {
        if let a = self.answers {
            return a.filter{$0.easy == false}.count
        } else {
            return 0
        }
    }
    
    var difficulty: CardDifficulty {
        
        let e = self.easyAnswers
        let h = self.hardAnswers
        let t = e+h
        
        if e > h {
            return .easy
        }
        
        if t>0 && e == h {
            return .medium
        }
        
        if e < h {
            return .hard
        }
        
        return .none
    }
    
    var difficultyColor: Color? {
        switch self.difficulty {
        case .easy:
            return Palette.difficultyEasy
            
        case .medium:
            return Palette.difficultyMedium
            
        case .hard:
            return Palette.difficultyHard
            
        default:
            return nil
        }
    }
}

extension Card {
    
    var printUUID: String {
        "UUID: \(self.id)"
    }
    
    var addedFormatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = self.added {
            return "Added: \(dateFormatter.string(from: date))"
        } else {
            return "Added: - no record -"
        }
    }
    
}

extension Card {
    mutating func addReaction(easy: Bool, jsonEngine:jsonData) {
        log("Card, addReaction, easy: \(easy)")
        log("for card: \(self.a)")
        
        // Make Answer object to commit
        let answer = Answer(easy: easy, commited: Date())
        if self.answers != nil {
            if self.answers!.count == Config.maximumAnswersItemsForCard {
                self.answers!.removeFirst()
            }
            self.answers!.append(answer)
        } else {
            self.answers = [answer]
        }
        jsonEngine.update(card: self)
    }
}

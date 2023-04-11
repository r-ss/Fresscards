//
//  Card.swift
//  Fresscards
//
//  Created by Alex Antipov on 09.04.2023.
//

import Foundation
//import SwiftUI

enum CardOrigin: String, Codable {
    case generator, user
}

//enum CardDifficulty: String {
//    case none, easy, medium, hard
//}

struct CardWireframe: Codable {
    // Used only to parse initial cards with just 2 text fields
    var a: String
    var b: String
}


struct Card: Codable, Hashable, Identifiable {
    var id: UUID
    var side_a: String // max 60
    var side_b: String // max 60
    var lang_a: String?
    var lang_b: String?
    var created_at: Date?
    var origin: CardOrigin?
    var theme: String?
}

extension Card {
    struct Mocked {
        var card1 = Card(id: UUID(), side_a: "Bolsa", side_b: "Bag")
        var card2 = Card(id: UUID(), side_a: "Coche", side_b: "Car")
    }

    static var mocked: Mocked {
        Mocked()
    }
}

//extension Card {
//
//    var printUUID: String {
//        "UUID: \(self.id)"
//    }
//
//    var addedFormatted: String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        if let date = self.added {
//            return "Added: \(dateFormatter.string(from: date))"
//        } else {
//            return "Added: - no record -"
//        }
//    }
//
//}


//
//  Card.swift
//  Fresscards
//
//  Created by Alex Antipov on 04.07.2022.
//

import Foundation

struct CardWireframe: Codable {
    // Used only to parse initial cards with just 2 text fields
    var a: String
    var b: String
}

struct Card: Codable, Hashable, Identifiable {
    var id: UUID
    var a: String
    var b: String
    var added: Date?
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

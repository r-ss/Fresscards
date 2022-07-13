//
//  Card.swift
//  Fresscards
//
//  Created by Alex Antipov on 04.07.2022.
//

import Foundation

struct Card: Codable, Hashable, Identifiable {
    var id: UUID
    var a: String
    var b: String
    var added: Date?
}

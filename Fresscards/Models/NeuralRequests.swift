//
//  NeuralRequest.swift
//  Fresscards
//
//  Created by Alex Antipov on 01.04.2023.
//

import Foundation


struct NeuralRequest: Codable {
    var lang_a: String
    var lang_b: String
    var theme: String
    var count: Int = 10
    var device: DeviceInfo?
}

struct NeuralResponseItem: Decodable, Hashable {
//    var id: UUID? = UUID()
    var side_a: String
    var side_b: String
    
    
}

struct NeuralResponse: Decodable {
    var request: NeuralRequest
    var result: [NeuralResponseItem]
}

// MARK: Mocked Data

extension NeuralRequest {
    struct Mocked {
        let request1 = NeuralRequest(lang_a: "Spanish", lang_b: "Russian", theme: "Food", count: 5)
    }
    
    static var mocked: Mocked {
        Mocked()
    }
}

extension NeuralResponseItem {
    struct Mocked {
        let item1 = NeuralResponseItem(side_a: "Jamón", side_b: "Ветчина")
        let item2 = NeuralResponseItem(side_a: "Verduras", side_b: "Овощи")
        let item3 = NeuralResponseItem(side_a: "Chocolate", side_b: "Шоколад")
        let item4 = NeuralResponseItem(side_a: "Pollo", side_b: "Курица")
        let item5 = NeuralResponseItem(side_a: "Queso", side_b: "Сыр")
    }
    
    static var mocked: Mocked {
        Mocked()
    }
}


extension NeuralResponse {
    struct Mocked {
        let response1 = NeuralResponse(request: NeuralRequest.mocked.request1, result: [
            NeuralResponseItem.mocked.item1,
            NeuralResponseItem.mocked.item2,
            NeuralResponseItem.mocked.item3,
            NeuralResponseItem.mocked.item4,
            NeuralResponseItem.mocked.item5
        ])
    }
    
    static var mocked: Mocked {
        Mocked()
    }
}

//
//  Config.swift
//  Energram
//
//  Created by Alex Antipov on 12.11.2022.
//

import Foundation

struct Config {
    
//    static let websiteUrl: String = "https://fresscards.ress.ws"
    
    static let enableDebugUI: Bool = false
    
    static let allowedGenerationsBeforePaywall: Int = 10
    
//    static let urlApiInfo: String = urlApi + "/info"
//    static let urlLatestPrice: String = urlApi + "/price/latest"
//    static let urlMultiplePrices: String = urlApi + "/price/all"
    
    static let baseLanguages = [
        "English",
        "Spanish",
        "French",
        "German",
        "Chinese",
        "Arabic",
        "Russian"
    ]
    
    static let additionalLanguages = [
        "Portuguese",
        "Korean",
        "Slovak",
        "Hindi",
        "Italian",
        "Japanese",
        "Turkish",
        "Polish"
    ]
    
}

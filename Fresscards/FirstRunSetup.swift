//
//  FirstRunSetup.swift
//  Fresscards
//
//  Created by Alex Antipov on 14.07.2022.
//

import Foundation
import TabularData

class FirstRunSetup {
    
    let settingsManager = SettingsManager()
    
//    let bakedCardsCSVsNames: [String] = ["base", "book_a1", "ru_poliglot", "verbs"]
    let bakedCardsCSVsNames: [String] = ["base"]
    
    init(){
        log("> class FirstRunSetup, init()")
        self.setDefaultSettings()
    }
    
    func setDefaultSettings(){
        self.settingsManager.createAndSaveDefault()
    }
    
    func loadBakedCards() -> [Card] {
        let options = CSVReadingOptions(hasHeaderRow: true, delimiter: ",")
        var resultCards: [Card] = []
        for CSVFilename in self.bakedCardsCSVsNames {

            guard let fileUrl = Bundle.main.url(forResource: CSVFilename, withExtension: "csv", subdirectory: "BakedCards") else {
                return []
            }
            
            let result = try! DataFrame(contentsOfCSVFile: fileUrl, options: options)
            
            let stringColumns: [Column<String>] = result.columns.map {
                $0.assumingType(String.self)
            }
            for row in result.rows.indices {
                let r = stringColumns.map({ $0[row] })
//                log("row: \(r)")
                let c = Card(id: UUID(), a: r[0]!, b: r[1]!, added: Date(), origin: .baked)
                resultCards.append(c)
            }
            
        }
        return resultCards
    }
    
}

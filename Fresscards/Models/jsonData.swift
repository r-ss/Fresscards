//
//  jsonData.swift
//  Fresscards
//
//  Created by Alex Antipov on 08.07.2022.
//

import Foundation

// Our main data object
class jsonData: ObservableObject {
    
    let initialContainerName = "initial_cards"  // loads on first run and upon reset
    let mainContainerName = "db"                // main json file with user's saved data
    let testContainerName = "test_db"           // db for unit tests
    
    private var testMode = false
    
    @Published var cards : [Card] // The Published wrapper marks this value as a source of truth for the view
    
    init(testMode:Bool = false) {
//        self.testMode = testMode
        let filename = testMode ? self.testContainerName : self.mainContainerName
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let jsonURL = documentDirectory.appendingPathComponent(filename).appendingPathExtension("json")
        if !FileManager.default.fileExists(atPath: jsonURL.path) {
            log("No database file found, make initial setup")
            let initialURL = Bundle.main.url(forResource: self.initialContainerName, withExtension: "json")! //Example json file in our bundle
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let result = try! decoder.decode([CardWireframe].self, from: Data(contentsOf: initialURL))
            
            var pile: [Card] = []
            
            for r in result {
                let c = Card(id: UUID(), a: r.a, b: r.b, added: Date())
                pile.append(c)
            }
            
            self.cards = pile
        } else {
            self.cards = Bundle.load(containerFilename: filename, initialFilename: initialContainerName) // Initailizing the array from a json file
        }
        
        
//        for var c in cards {
//            if (c.id == nil) {
//                log("Card without id: \(c)")
//                c.id = UUID()
//                self.saveJSON()
//            }
//            
//        }
    }
    
    public func add(card: Card){
        self.cards.append(card)
        self.saveJSON()
    }
    
    public func removeCard(withId: UUID){
        self.cards.removeAll(where: { $0.id == withId })
        self.saveJSON()
    }
    
    
    public func removeCards(atIndexes: IndexSet){
        self.cards.remove(atOffsets: atIndexes)
        self.saveJSON()
    }
    
    
    public func update(card: Card){
        let index: Int = self.cards.firstIndex(where: { $0.id == card.id })!
        self.cards[index] = card
        self.saveJSON()
    }
    
    // function to write the json data into the file manager
    func saveJSON() {
        let filename = self.testMode ? self.testContainerName : self.mainContainerName
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let jsonURL = documentDirectory
            .appendingPathComponent(filename)
            .appendingPathExtension("json")
        let enc = JSONEncoder()
        enc.dateEncodingStrategy = .iso8601 // https://tapadoo.com/swift-json-date-formatting/
        try? enc.encode(cards).write(to: jsonURL, options: .atomic)
    }

}

// Function to load data
extension Bundle {
    static func load<T: Decodable>(containerFilename:String, initialFilename:String) -> T {
        
        log("Loading JSON from: \(containerFilename)")


        let initialURL = Bundle.main.url(forResource: initialFilename, withExtension: "json")! //Example json file in our bundle
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! // Initializing the url for the location where we store our data in filemanager

        let jsonURL = documentDirectory.appendingPathComponent(containerFilename).appendingPathExtension("json")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        // The following condition copies the example file in our bundle to the correct location if it isnt present
        if !FileManager.default.fileExists(atPath: jsonURL.path) {
            try? FileManager.default.copyItem(at: initialURL, to: jsonURL)
        }

        // returning the parsed data

        return try! decoder.decode(T.self, from: Data(contentsOf: jsonURL))
    }
}

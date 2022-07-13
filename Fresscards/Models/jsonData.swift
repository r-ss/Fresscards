//
//  jsonData.swift
//  Fresscards
//
//  Created by Alex Antipov on 08.07.2022.
//

import Foundation

// Our main data object
class jsonData: ObservableObject {
    @Published var cards : [Card] // The Published wrapper marks this value as a source of truth for the view
    
    init() {
        self.cards = Bundle.load("initial_cards") // Initailizing the array from a json file
    }
    
    public func add(card: Card){
        log("--- aaaa ddddddddd ----")
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
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let jsonURL = documentDirectory
            .appendingPathComponent("initial_cards")
            .appendingPathExtension("json")
        try? JSONEncoder().encode(cards).write(to: jsonURL, options: .atomic)
    }
}

// Function to load data
extension Bundle {
    static func load<T: Decodable>(_ filename: String) -> T {

        let readURL = Bundle.main.url(forResource: filename, withExtension: "json")! //Example json file in our bundle
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! // Initializing the url for the location where we store our data in filemanager
        
        let jsonURL = documentDirectory // appending the file name to the url
            .appendingPathComponent(filename)
            .appendingPathExtension("json")

        // The following condition copies the example file in our bundle to the correct location if it isnt present
        if !FileManager.default.fileExists(atPath: jsonURL.path) {
            try? FileManager.default.copyItem(at: readURL, to: jsonURL)
        }
        
        // returning the parsed data
        return try! JSONDecoder().decode(T.self, from: Data(contentsOf: jsonURL))
    }
}

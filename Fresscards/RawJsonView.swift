//
//  RawJsonView.swift
//  Fresscards
//
//  Created by Alex Antipov on 13.07.2022.
//

import SwiftUI

struct RawJsonView: View {
    
//    let readURL = Bundle.main.url(forResource: "initial_cards", withExtension: "json")! //Example json file in our bundle
//    private func loadJsonWithoutDecoding() -> String {
//        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! // Initializing the url for the location where we store our data in filemanager
//
//        let jsonURL = documentDirectory // appending the file name to the url
//            .appendingPathComponent("initial_cards")
//            .appendingPathExtension("json")
//
//        return try! String(contentsOf: jsonURL, encoding: .utf8)
//    }
//
    
    var content: String {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! // Initializing the url for the location where we store our data in filemanager
        
        let jsonURL = documentDirectory // appending the file name to the url
            .appendingPathComponent("initial_cards")
            .appendingPathExtension("json")
        
        return try! String(contentsOf: jsonURL, encoding: .utf8)
    }
    
    
    var body: some View {
        
        Text(content).font(.system(size: 12)).padding()
    }
}

//struct CardTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        CardTextField()
//    }
//}

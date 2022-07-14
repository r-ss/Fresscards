//
//  RawJsonView.swift
//  Fresscards
//
//  Created by Alex Antipov on 13.07.2022.
//

import SwiftUI

struct RawJsonView: View {
    
    var content: String {
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! // Initializing the url for the location where we store our data in filemanager
        
        let jsonURL = documentDirectory // appending the file name to the url
            .appendingPathComponent("db")
            .appendingPathExtension("json")
        
        return try! String(contentsOf: jsonURL, encoding: .utf8)
    }
    
    var body: some View {
        Text(content).font(.system(size: 11)).lineLimit(20)
    }
}

struct RawJsonView_Previews: PreviewProvider {
    static var previews: some View {
        Text(String.random(length: 1024)).font(.system(size: 12)).padding()
    }
}

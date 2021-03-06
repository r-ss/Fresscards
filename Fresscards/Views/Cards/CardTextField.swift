//
//  CardFields.swift
//  Fresscards
//
//  Created by Alex Antipov on 13.07.2022.
//

import SwiftUI

struct CardTextField: View {
    
    @Binding var content: String
    
    
    var body: some View {
        
        TextField("Enter text...", text: $content)
            .onReceive(content.publisher.collect()) {
                let s = String($0.prefix(Config.cardFieldCharacterLimit))
                if content != s {
                    content = s
                }
            }
            .disableAutocorrection(true)
        
    }
}

struct CardTextField_Previews: PreviewProvider {
    static var previews: some View {
        Text("Enter text...")
    }
}

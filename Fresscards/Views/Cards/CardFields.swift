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
//            .onSubmit {
//                self.textValue = content
//            }
            .disableAutocorrection(true)
        
    }
}

//struct CardTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        CardTextField()
//    }
//}

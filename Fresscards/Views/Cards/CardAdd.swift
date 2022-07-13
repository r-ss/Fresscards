//
//  CardAdd.swift
//  Fresscards
//
//  Created by Alex Antipov on 09.07.2022.
//

import SwiftUI

struct CardAdd: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var jsonData: jsonData
    
    @State var side_a: String = ""
    @State var side_b: String = ""
    
    @FocusState private var keyboardFocused: Bool
    
    private func createCardFromFields() {
        log("> createCardFromFields")
        let new:Card = Card(id:UUID(), a: self.side_a, b: self.side_b, added: Date())
//        self.card.side_b = text
        jsonData.add(card: new)
        self.presentationMode.wrappedValue.dismiss()
    }

    var body: some View {
        VStack {
            Text("Side A:")
            CardTextField(content: $side_a)
            Divider()
            Text("Side B:")
            CardTextField(content: $side_b)
            
            Button("Save", action: { self.createCardFromFields() })
        }.padding()
        }
}

struct CardAdd_Previews: PreviewProvider {
    static var previews: some View {
        CardAdd()
    }
}

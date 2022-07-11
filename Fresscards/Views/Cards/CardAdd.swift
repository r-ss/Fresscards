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
    
    private func createCardFromFields() {
        log("WOW")
        let new:Card = Card(id:UUID(), side_a: self.side_a, side_b: self.side_b)
//        self.card.side_b = text
        jsonData.add(card: new)
        self.presentationMode.wrappedValue.dismiss()
    }

    var body: some View {
        VStack {
            Text("Side A:")
            TextField("Enter text...", text: $side_a)
//            .onSubmit {
//                createCardFromFields()
//            }
            Divider()
            Text("Side B:")
            TextField("Enter text...", text: $side_b)
//            .onSubmit {
//                createCardFromFields()
//            }
            
            Button(
                        "Save",
                        action: { self.createCardFromFields() }
                    )
        }.padding()
        }
}

struct CardAdd_Previews: PreviewProvider {
    static var previews: some View {
        CardAdd()
    }
}

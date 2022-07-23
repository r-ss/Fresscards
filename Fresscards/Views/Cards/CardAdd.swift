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
    
    @State private var side_a: String = ""
    @State private var side_b: String = ""
    
    @FocusState private var focusedField: Field?
    
    private func createCardFromFields() {
        log("> createCardFromFields")
        let new:Card = Card(id:UUID(), a: self.side_a, b: self.side_b, added: Date(), origin: .user)
        jsonData.add(card: new)
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 15) {
                Text("Side A:")
                //            CardTextField(content: $side_a).focused($focusedField, equals: .side_a)
                TextField("Side A", text: $side_a)
                    .focused($focusedField, equals: .side_a)
                    .onSubmit {
                        focusNextField()
                    }
                    .submitLabel(.next)
                    .disableAutocorrection(true)
                
                //            Divider()
                
                Text("Side B:")
                TextField("Side B", text: $side_b)
                    .focused($focusedField, equals: .side_b)
                    .onSubmit {
                        createCardFromFields()
                    }
                    .submitLabel(.done)
                    .disableAutocorrection(true)
                
                Button("Save", action: { self.createCardFromFields() }).disabled(side_a.isEmpty || side_b.isEmpty)
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button(action: focusPreviousField) {
                        Image(systemName: "chevron.up")
                    }
                    .disabled(!canFocusPreviousField()) // remove this to loop through fields
                }
                ToolbarItem(placement: .keyboard) {
                    Button(action: focusNextField) {
                        Image(systemName: "chevron.down")
                    }
                    .disabled(!canFocusNextField()) // remove this to loop through fields
                }
            }
            .frame(width: geometry.size.width, alignment: .leading)
        }
    }
}

struct CardAdd_Previews: PreviewProvider {
    static var previews: some View {
        CardAdd()
    }
}

extension CardAdd {
    private enum Field: Int, CaseIterable {
        case side_a, side_b
    }
    
    private func focusPreviousField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue - 1) ?? .side_a
        }
    }
    
    private func focusNextField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue + 1) ?? .side_b
        }
    }
    
    private func canFocusPreviousField() -> Bool {
        guard let currentFocusedField = focusedField else {
            return false
        }
        return currentFocusedField.rawValue > 0
    }
    
    private func canFocusNextField() -> Bool {
        guard let currentFocusedField = focusedField else {
            return false
        }
        return currentFocusedField.rawValue < Field.allCases.count - 1
    }
}

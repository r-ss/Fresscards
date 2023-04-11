//
//  CardAdd.swift
//  Fresscards
//
//  Created by Alex Antipov on 09.04.2023.
//



import SwiftUI

struct CardAdd: View {
    
    @Environment(\.presentationMode) var presentationMode
    
//    @EnvironmentObject var jsonData: jsonData
    
    @ObservedObject var viewModel: CardEditorViewModel
    
    var createMode: Bool = false // create or edit.. if create - hide "Delete" button
    
//    @State private var side_a: String = ""
//    @State private var side_b: String = ""
    
    @FocusState private var focusedField: Field?
    
    var autoCap = false
    
    init(card: Card?, createMode: Bool = false, dataManager: DataManager = DataManager.shared) {
        self.viewModel = CardEditorViewModel(card: card, dataManager: dataManager)
        self.createMode = createMode
        
//        self.side_a = self.viewModel.editingCard.side_a
//        self.side_b = self.viewModel.editingCard.side_b
    }
    
    private func createCardFromFields() {
        log("> createCardFromFields")
//        let new = Card(id:UUID(), side_a: self.side_a, side_b: self.side_b, created_at: Date(), origin: .user)
        
//        print(new)
//        jsonData.add(card: new)
        
//        viewModel.editingCard.side_a = side_a
//        viewModel.editingCard.side_b = side_b
        viewModel.editingCard.origin = .user
        
        
        withAnimation {
            viewModel.saveCard()
        }
        
        
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 15) {
                Text("Side A:")
                //            CardTextField(content: $side_a).focused($focusedField, equals: .side_a)
                TextField("Side A", text: $viewModel.editingCard.side_a)
                    .focused($focusedField, equals: .side_a)
                    .onSubmit {
                        focusNextField()
                    }
                    .submitLabel(.next)
                    .disableAutocorrection(true)
                    .font(.biggerTextField)
                    .textFieldStyle(BottomLineTextFieldStyle())
                
                //            Divider()
                
                Text("Side B:")
                TextField("Side B", text: $viewModel.editingCard.side_b)
                    .focused($focusedField, equals: .side_b)
                    .onSubmit {
                        createCardFromFields()
                    }
                    .submitLabel(.done)
                    .disableAutocorrection(true)
                    .font(.biggerTextField)
                    .textFieldStyle(BottomLineTextFieldStyle())
                
                
                HStack(alignment: .lastTextBaseline, spacing:5){
                    
                    if !createMode {
                        Button(role: .destructive) {
                            presentationMode.wrappedValue.dismiss()
                            
                            //                            Notification.fire(name: .applianceWillBeRemoved, payload: String(describing: $viewModel.editingAppliance.wrappedValue.id))
                            //
                            withAnimation {
                                viewModel.delete(card: $viewModel.editingCard.wrappedValue)
                            }
                            //                        Notification.fire(name: .applianceRemoved)
                        } label: {
                            Label("Delete", systemImage:
                                    "trash").foregroundColor(.red)
//                                .font(.biggerTextField)
                        }
                        .frame(width: 120)
                    }
                    
                    Button("Save", action: { self.createCardFromFields() }).disabled(viewModel.editingCard.side_a.isEmpty || viewModel.editingCard.side_b.isEmpty)
                        .frame(width: 90)
                    //                    .background(.red)
//                        .font(.biggerTextField)
                    
                    
                }
                .frame(width: max(geometry.size.width - 34, 0))
//                .background(.teal)
                
                
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
        CardAdd(card: nil)
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


struct BottomLineTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        VStack() {
            configuration
            Rectangle()
                .frame(height: 1, alignment: .bottom)
                .foregroundColor(Color.secondary)
        }
    }
}


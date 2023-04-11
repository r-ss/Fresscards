//
//  CardEditorViewModel.swift
//  Fresscards
//
//  Created by Alex Antipov on 10.04.2023.
//


import Foundation
import Combine

@MainActor
final class CardEditorViewModel: ObservableObject {
    
    @Published var editingCard: Card
//    @Published var projectSearchText: String = ""
//    @Published var selectedProjectToEdit: Appliance? = nil
    
    @Published private var dataManager: DataManager
    
    var anyCancellable: AnyCancellable? = nil
    
    init(card: Card?, dataManager: DataManager = DataManager.shared) {
        if let card = card {
            self.editingCard = card
        } else {
            self.editingCard = Card(id: UUID(), side_a: "", side_b: "", created_at: Date())
        }
        self.dataManager = dataManager
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }
    
    
    func saveCard() {
        dataManager.updateAndSave(card: editingCard)
    }
    
    func delete(card: Card) {
        dataManager.delete(card: card)
    }
    
//    func addNewProject() {
//        projectSearchText = String(projectSearchText.trailingSpacesTrimmed)
//        if !projects.contains(where: {$0.title.localizedLowercase == projectSearchText.localizedLowercase}) {
//            var project = Project()
//            project.title = projectSearchText
//            dataManager.updateAndSave(project: project)
//            projectSearchText = ""
//        }
//    }
}

extension StringProtocol {

    @inline(__always)
    var trailingSpacesTrimmed: Self.SubSequence {
        var view = self[...]

        while view.last?.isWhitespace == true {
            view = view.dropLast()
        }

        return view
    }
}

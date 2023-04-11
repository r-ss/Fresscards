//
//  DataManager.swift
//  Fresscards
//
//  Created by Alex Antipov on 09.04.2023.
//

import Foundation
import CoreData
import OrderedCollections

enum DataManagerType {
    case normal, preview, testing
}

class DataManager: NSObject, ObservableObject {
    
    static let shared = DataManager(type: .normal)
    static let preview = DataManager(type: .preview)
    static let testing = DataManager(type: .testing)
    
//    @Published var cards: [Card]
    @Published var cards: OrderedDictionary<UUID, Card> = [:]
//    @Published var projects: OrderedDictionary<UUID, Project> = [:]
    
    var cardsArray: [Card] {
        Array(cards.values)
    }
    
    
    fileprivate var managedObjectContext: NSManagedObjectContext
    private let cardsFRC: NSFetchedResultsController<CardMO>
    
    private init(type: DataManagerType) {
        switch type {
        case .normal:
            let persistentStore = PersistentStore()
            self.managedObjectContext = persistentStore.context
        case .preview:
            let persistentStore = PersistentStore(inMemory: true)
            self.managedObjectContext = persistentStore.context
            for i in 0..<10 {
                let newCard = CardMO(context: managedObjectContext)
                newCard.side_a = "Card \(i)"
                newCard.side_b = "Side B \(i)"
                newCard.id = UUID()
                newCard.created_at = Date()
            }
//            for i in 0..<4 {
//                let newProject = ProjectMO(context: managedObjectContext)
//                newProject.title = "Project \(i)"
//                newProject.id = UUID()
//            }
            try? self.managedObjectContext.save()
        case .testing:
            let persistentStore = PersistentStore(inMemory: true)
            self.managedObjectContext = persistentStore.context
        }
        
        let cardFR: NSFetchRequest<CardMO> = CardMO.fetchRequest()
        cardFR.sortDescriptors = [NSSortDescriptor(key: "created_at", ascending: true)]
        cardsFRC = NSFetchedResultsController(fetchRequest: cardFR,
                                              managedObjectContext: managedObjectContext,
                                              sectionNameKeyPath: nil,
                                              cacheName: nil)
        
//        let projectFR: NSFetchRequest<ProjectMO> = ProjectMO.fetchRequest()
//        projectFR.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        projectsFRC = NSFetchedResultsController(fetchRequest: projectFR,
//                                                 managedObjectContext: managedObjectContext,
//                                                 sectionNameKeyPath: nil,
//                                                 cacheName: nil)
        
        super.init()
        
        // Initial fetch to populate cards array
        cardsFRC.delegate = self
        try? cardsFRC.performFetch()
        if let newCards = cardsFRC.fetchedObjects {
            
            //print(newCards)
            self.cards = OrderedDictionary(uniqueKeysWithValues: newCards.map({ ($0.id!, Card(cardMO: $0)) }))
            
        }
        
//        projectsFRC.delegate = self
//        try? projectsFRC.performFetch()
//        if let newProjects = projectsFRC.fetchedObjects {
//            self.projects = OrderedDictionary(uniqueKeysWithValues: newProjects.map({ ($0.id!, Project(projectMO: $0)) }))
//        }
    }
    
    func saveData() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                log("Unresolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }
}

extension DataManager: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let newCards = controller.fetchedObjects as? [CardMO] {
            self.cards = OrderedDictionary(uniqueKeysWithValues: newCards.map({ ($0.id!, Card(cardMO: $0)) }))
        }
//        else if let newProjects = controller.fetchedObjects as? [ProjectMO] {
//            print(newProjects)
//            self.projects = OrderedDictionary(uniqueKeysWithValues: newProjects.map({ ($0.id!, Project(projectMO: $0)) }))
//        }
    }
    
    private func fetchFirst<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate?) -> Result<T?, Error> {
        let request = objectType.fetchRequest()
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            let result = try managedObjectContext.fetch(request) as? [T]
            return .success(result?.first)
        } catch {
            return .failure(error)
        }
    }
    
    func fetchCards(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) {
        if let predicate = predicate {
            cardsFRC.fetchRequest.predicate = predicate
        }
        if let sortDescriptors = sortDescriptors {
            cardsFRC.fetchRequest.sortDescriptors = sortDescriptors
        }
        try? cardsFRC.performFetch()
        if let newCards = cardsFRC.fetchedObjects {
            
            
            if newCards.count == 0 {
//                print("Setup baked cards...")
//                let initial: [Card] = []
//                for card in initial {
//                    updateAndSave(card: card)
//                }
//                print("Saved \(initial.count) initial cards, fetching them...")
//                self.fetchCards(predicate: predicate, sortDescriptors: sortDescriptors)
                return
            } else {
                print("Got \(newCards.count) cards from CoreData")
            }
            
            
            self.cards = OrderedDictionary(uniqueKeysWithValues: newCards.map({ ($0.id!, Card(cardMO: $0)) }))
        } else {
            print("Cannot fetch cards")
        }
    }
    
    func resetFetch() {
        cardsFRC.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        cardsFRC.fetchRequest.predicate = nil
        try? cardsFRC.performFetch()
        if let newCards = cardsFRC.fetchedObjects {
            self.cards = OrderedDictionary(uniqueKeysWithValues: newCards.map({ ($0.id!, Card(cardMO: $0)) }))
        }
    }

}

//MARK: - Card Methods
extension Card {
    
    fileprivate init(cardMO: CardMO) {
        self.id = cardMO.id ?? UUID()
        self.side_a = cardMO.side_a ?? "no data"
        self.side_b = cardMO.side_b ?? "no data"
        self.created_at = cardMO.created_at ?? Date()
        
        self.lang_a = cardMO.lang_a
        self.lang_b = cardMO.lang_b
        self.theme = cardMO.theme
        
        
//        print(Int(cardMO.power),Int(cardMO.typical_duration))
        
//        if let projectMO = CardMO.projectMO {
//            self.projectID = projectMO.id
//        }
    }
}

extension DataManager {
    
    func updateAndSave(card: Card) {
        let predicate = NSPredicate(format: "id = %@", card.id as CVarArg)
        let result = fetchFirst(CardMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let CardMO = managedObject {
                update(cardMO: CardMO, from: card)
            } else {
                cardMO(from: card)
            }
        case .failure(_):
            print("Couldn't fetch CardMO to save")
        }
        
        saveData()
    }
    
    func delete(card: Card) {
        let predicate = NSPredicate(format: "id = %@", card.id as CVarArg)
        let result = fetchFirst(CardMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let cardMO = managedObject {
                managedObjectContext.delete(cardMO)
            }
        case .failure(_):
            print("Couldn't fetch CardMO to save")
        }
        saveData()
    }
    
    func getCard(with id: UUID) -> Card? {
        return cards[id]
    }
    
    private func cardMO(from card: Card) {
        let CardMO = CardMO(context: managedObjectContext)
        CardMO.id = card.id
        update(cardMO: CardMO, from: card)
    }
    
    private func update(cardMO: CardMO, from card: Card) {
        cardMO.side_a = card.side_a
        cardMO.side_b = card.side_b
        cardMO.created_at = card.created_at
        cardMO.lang_a = card.lang_a
        cardMO.lang_b = card.lang_b
        cardMO.theme = card.theme
//        cardMO.name = card.name
//        if let id = card.projectID, let project = getProject(with: id) {
//            CardMO.projectMO = getProjectMO(from: project)
//        } else {
//            CardMO.projectMO = nil
//        }
    }
    
    ///Get's the CardMO that corresponds to the card. If no CardMO is found, returns nil.
    private func getCardMO(from card: Card?) -> CardMO? {
        guard let card = card else { return nil }
        let predicate = NSPredicate(format: "id = %@", card.id as CVarArg)
        let result = fetchFirst(CardMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let CardMO = managedObject {
                return CardMO
            } else {
                return nil
            }
        case .failure(_):
            return nil
        }
        
    }
    
}


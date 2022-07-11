//
//  CardRealmViewModel.swift
//  Fresscards
//
//  Created by Alex Antipov on 08.07.2022.
//

// 1
import Foundation
import Combine
import RealmSwift

// 2
final class CardRealmViewModel: ObservableObject {
    // 3
    @Published var cards: [Card] = []
    // 4
    private var token: NotificationToken?

    init() {
        setupObserver()
    }

    deinit {
        token?.invalidate()
    }
    // 5
    private func setupObserver() {
        do {
            
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            Realm.Configuration.defaultConfiguration = config
            
            let realm = try Realm()
            let results = realm.objects(CardRealm.self)

            token = results.observe({ [weak self] changes in
                // 6
                self?.cards = results.map(Card.init)
//                    .sorted(by: { $0.completedAt > $1.completedAt })
//                    .sorted(by: { !$0.completed && $1.completed })
            })
        } catch let error {
            print(error.localizedDescription)
        }
    }
    // 7
    func add(card:Card) {
        let CardRealm = CardRealm(value: [
            "side_a": card.side_a,
            "side_b": card.side_b
        ])
        do {
            let realm = try Realm()
            if card.id == "ZZZ" {
                try realm.write {
                    realm.add(CardRealm)
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func remove(card:Card) {
        do {
            let realm = try Realm()
            let objectId = try ObjectId(string: card.id)
            if let card = realm.object(ofType: CardRealm.self, forPrimaryKey: objectId) {
                try realm.write {
                    realm.delete(card)
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func remove(at_indexes: IndexSet) {
        
        at_indexes.forEach { index in
//            print(index)
            
            let card_to_delete: Card = self.cards[index]
            do {
                let realm = try Realm()
                let objectId = try ObjectId(string: card_to_delete.id)
                if let card = realm.object(ofType: CardRealm.self, forPrimaryKey: objectId) {
                    try realm.write {
                        realm.delete(card)
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
        
        
    }

    func update(card:Card, new_a_text:String, new_b_text:String) {
        do {
            let realm = try Realm()
            let objectId = try ObjectId(string: card.id)
            let card = realm.object(ofType: CardRealm.self, forPrimaryKey: objectId)
            try realm.write {
                card?.side_a = new_a_text
                card?.side_b = new_b_text
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // 8
//    func markComplete(id: String, completed: Bool) {
//        do {
//            let realm = try Realm()
//            let objectId = try ObjectId(string: id)
//            let task = realm.object(ofType: CardRealm.self, forPrimaryKey: objectId)
//            try realm.write {
//                card?.completed = completed
//                task?.completedAt = Date()
//            }
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }
}

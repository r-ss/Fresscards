//
//  CardRealmObject.swift
//  Fresscards
//
//  Created by Alex Antipov on 08.07.2022.
//

import Foundation
import RealmSwift

class CardRealm: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var side_a: String
    @Persisted var side_b: String
}



//
//  AACard+CoreDataClass.swift
//  Fresscards
//
//  Created by Alex Antipov on 13.07.2022.
//
//

import Foundation
import CoreData

@objc(AACard)
public class AACard: NSManagedObject {

}

extension AACard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AACard> {
        return NSFetchRequest<AACard>(entityName: "AACard")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var a: String
    @NSManaged public var b: String

}

extension AACard : Identifiable {

}

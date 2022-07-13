//
//  PersistenceTests.swift
//  FresscardsTests
//
//  Created by Alex Antipov on 08.07.2022.
//


import XCTest
import SwiftUI
@testable import Fresscards

class PersistenceTests: XCTestCase {
    
    var data:jsonData = jsonData()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPersistenceOperations() throws {
        log("--- testPersistenceOperations ---")
        let initial_count: Int = data.cards.count
        log(String(initial_count))

        let new:Card = Card(id:UUID(), a: "new_a", b: "new_b")

        data.add(card: new)
        log(String(data.cards.count))
        
        var last:Card = data.cards.last!
        log("Last ID: \(last.id)")
        log("Last side_a: \(last.a)")
        XCTAssertEqual(last.a, "new_a", "last_a is wrong")
        
        last.b = "edited"
        data.update(card: last)
        
        let lasrReRead:Card = data.cards.last!
        XCTAssertEqual(lasrReRead.b, last.b, "card was not updated")
        
        
        data.removeCard(withId: last.id)
        
        
        log(String(data.cards.count))
        XCTAssertEqual(data.cards.count, initial_count, "cards count is wrong")
    }

}

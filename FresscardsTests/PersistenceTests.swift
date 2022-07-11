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
        let initial_count: Int = data.cards.count
        log(String(initial_count))

        let new:Card = Card(id:UUID(), side_a: "new_a", side_b: "new_b")

        data.add(card: new)
        log(String(data.cards.count))
        
        var last:Card = data.cards.last!
        log("Last ID: \(last.id)")
        log("Last side_a: \(last.side_a)")
        XCTAssertEqual(last.side_a, "new_a", "last_a is wrong")
        
        last.side_b = "edited"
        data.update(card: last)
        
        let lasrReRead:Card = data.cards.last!
        XCTAssertEqual(lasrReRead.side_b, last.side_b, "card was not updated")
        
        
        data.removeCard(withId: last.id)
        
        
        log(String(data.cards.count))
        XCTAssertEqual(data.cards.count, initial_count, "cards count is wrong")
    }

}

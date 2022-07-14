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
    
    var data:jsonData = jsonData(testMode: true)

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPersistenceTestModeIsOn() throws {
        XCTAssertEqual(data.testMode, true, "Test mode is not true")
    }
    
    func testPersistenceOperations() throws {
//        log("--- testPersistenceOperations ---")
        let initial_count: Int = data.cards.count
//        log(String(initial_count))
        
        XCTAssertEqual(data.cards.count, 3, "Number of initial cards is not 3")

        let new:Card = Card(id:UUID(), a: "new_a", b: "new_b")

        data.add(card: new)
//        log(String(data.cards.count))
        
        var last:Card = data.cards.last!
        
        XCTAssertNotEqual(last.id, nil, "item UUID is wrong")
        XCTAssertEqual(last.a, "new_a", "last_a is wrong")
        
        last.b = "edited"
        data.update(card: last)
        
        let lasrReRead:Card = data.cards.last!
        XCTAssertEqual(lasrReRead.b, last.b, "card was not updated")
        
        
        data.removeCard(withId: last.id)
        XCTAssertEqual(data.cards.count, initial_count, "cards count is wrong")
    }

}

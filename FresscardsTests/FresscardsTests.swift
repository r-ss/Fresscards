//
//  FresscardsTests.swift
//  FresscardsTests
//
//  Created by Alex Antipov on 30.06.2022.
//

import XCTest
@testable import Fresscards

class FresscardsTests: XCTestCase {
    
    var data:jsonData = jsonData(testMode: true)

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//
//        let cards: Cards = loadFromJson()!
//        XCTAssertEqual(cards.cards.count, 4, "Cards length is not 4")
//    }
    
    func testAnswers() throws {
        
        var card: Card = data.cards[0]
        
//        for i in 1...6 {
//            card.addReaction(easy: true, jsonEngine: self.data)
//        }
        
//        log("answers: \(card.answers)")
        
        XCTAssertEqual(card.difficulty, .none, "difficulty must be none (unset) here")
        
        card.addReaction(easy: false, jsonEngine: self.data)
        
        XCTAssertEqual(card.difficulty, .hard, "difficulty must be hard at this point")
        
        card.addReaction(easy: true, jsonEngine: self.data)
        
        XCTAssertEqual(card.difficulty, .medium, "difficulty must be medium at this point")
        
        card.addReaction(easy: true, jsonEngine: self.data)
        
        XCTAssertEqual(card.difficulty, .easy, "difficulty must be easy at this point")
        
        
        
//        if let ans = card.answers {
//            log("answers: \(ans.count)")
//        } else {
//            log("No answers")
//        }
        
        
        
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}

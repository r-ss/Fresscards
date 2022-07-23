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
        
        for i in 1...6 {
            
            log("FFFFF \(i)")
//            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)/20) {
                card.addReaction(easy: true, jsonEngine: self.data)
//            }
//            sleep(UInt32(Double(i)/4))
            
         
            
        }
        
        if let ans = card.answers {
            log("answers: \(ans.count)")
        } else {
            log("No answers")
        }
        
        
        
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}

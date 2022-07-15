//
//  MiscTests.swift
//  FresscardsTests
//
//  Created by Alex Antipov on 15.07.2022.
//

import XCTest
@testable import Fresscards

class MiscTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testStringCapitalization() throws {
        XCTAssertEqual("test caps".firstWordCapitalization(), "Test caps", "Capitalization fail")
        XCTAssertEqual("¡ven acá!".firstWordCapitalization(), "¡Ven acá!", "Capitalization fail")
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}

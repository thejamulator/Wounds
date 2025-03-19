//
// Copyright (c) 2025 and Confidential to Eric Ford Consulting All rights reserved.
//

import XCTest
@testable import Wounds

final class BattleTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_blueIsAI() throws {
        let battle = Battle.getBootCampLevel1()
        XCTAssertTrue(battle.blueIsAI)
    }

    func test_win() throws {
        
    }
    
    func test_lose() throws {
        
    }
    
    // Can there be a draw in Wounds?
    func test_draw() throws {
        
    }
}

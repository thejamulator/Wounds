//
// Copyright (c) 2024 and Confidential to Eric Ford Consulting All rights reserved.
//

import XCTest
@testable import Wounds

final class BoardTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_clone() throws {
        let board = Board(squaresWide: 10, squaresHigh: 8)
        let man = Man(piece: Piece.rook(), player: red)
        board.putMan(man: man, x: 2, y: 2)
        let cloned = board.clone()
        man.abilities.remove(at: 0)
        let moves = board.generateMoves(player: red)
        let cloneMoves = cloned.generateMoves(player: red)
        XCTAssertNotEqual(moves.count, cloneMoves.count)
    }

    func testBootCampMoves() throws {
        let boot = Battle.getBootCamp()
        let moves = boot.board.generateMoves(player: red)
        XCTAssertEqual(moves.count, 26)
    }
    
    func test_centralityFile() throws {
        let board = Board(squaresWide: 8, squaresHigh: 8)
        XCTAssertEqual(board.centrality(file: 0), 0)
        XCTAssertEqual(board.centrality(file: 1), 1)
        XCTAssertEqual(board.centrality(file: 2), 2)
        XCTAssertEqual(board.centrality(file: 3), 3)
        XCTAssertEqual(board.centrality(file: 4), 3)
        XCTAssertEqual(board.centrality(file: 5), 2)
        XCTAssertEqual(board.centrality(file: 6), 1)
        XCTAssertEqual(board.centrality(file: 7), 0)
    }
    
    func test_centralityRank() throws {
        let board = Board(squaresWide: 8, squaresHigh: 8)
        XCTAssertEqual(board.centrality(rank: 0), 0)
        XCTAssertEqual(board.centrality(rank: 1), 1)
        XCTAssertEqual(board.centrality(rank: 2), 2)
        XCTAssertEqual(board.centrality(rank: 3), 3)
        XCTAssertEqual(board.centrality(rank: 4), 3)
        XCTAssertEqual(board.centrality(rank: 5), 2)
        XCTAssertEqual(board.centrality(rank: 6), 1)
        XCTAssertEqual(board.centrality(rank: 7), 0)
    }
    
    func testCentrality() throws {
        let board = Board(squaresWide: 8, squaresHigh: 8)
        XCTAssertEqual(board.centrality(file: 0, rank: 0), 0)
        XCTAssertEqual(board.centrality(file: 1, rank: 7), 1)
        XCTAssertEqual(board.centrality(file: 3, rank: 3), 6)
        XCTAssertEqual(board.centrality(file: 4, rank: 4), 6)
        XCTAssertEqual(board.centrality(file: 4, rank: 5), 5)
        XCTAssertEqual(board.centrality(file: 3, rank: 3), 6)
        XCTAssertEqual(board.centrality(file: 7, rank: 7), 0)
    }
    
    func test_gravitationalCenter() throws {
        let battle = Battle.getBootCamp()
        let (gravX, gravY) = battle.board.gravitationalCenter(player: red)
        XCTAssertEqual(gravX, 3)
        XCTAssertEqual(gravY, 6)
    }
    
    func test_gravitationalDistance() throws {
        let battle = Battle.getBootCamp()
        XCTAssertEqual(battle.board.gravitationalDistance(gravX: 3, gravY: 6, file: 4, rank: 5), 2)
        XCTAssertEqual(battle.board.gravitationalDistance(gravX: 2, gravY: 7, file: 4, rank: 5), 4)
    }
}

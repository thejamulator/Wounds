//
// Copyright (c) 2024 and Confidential to Eric Ford Consulting All rights reserved.
//

import XCTest
@testable import Wounds

final class ManTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_defenseResultRemoved() throws {
        let board = Board(squaresWide: 8, squaresHigh: 8)
        let attacker = Man(piece: Piece.rook(), player: red)
        board.putMan(man: attacker, x: 2, y: 2)
        let defender = Man(piece: Piece.rook(), player: blue)
        board.putMan(man: defender, x: 5, y: 2)
        let attackingAbility = attacker.abilities.first(where: { $0.xOffset == 1 })!
        let move = Move(fromX: 2, fromY: 2, toX: 5, toY: 2, attackingMan: attacker, attackingAbility: attackingAbility)
        XCTAssertEqual(defender.defenseResult(move: move), .AbilityRemoved)
    }
    
    func test_defenseResultCaptured() throws {
        let board = Board(squaresWide: 8, squaresHigh: 8)
        let attacker = Man(piece: Piece.rook(), player: red)
        board.putMan(man: attacker, x: 2, y: 2)
        let defender = Man(piece: Piece.star(), player: blue)
        board.putMan(man: defender, x: 5, y: 2)
        let attackingAbility = attacker.abilities.first(where: { $0.xOffset == 1 })!
        let move = Move(fromX: 2, fromY: 2, toX: 5, toY: 2, attackingMan: attacker, attackingAbility: attackingAbility)
        XCTAssertEqual(defender.defenseResult(move: move), .PieceCaptured)
    }
    
    func test_defenseResultDemoted() throws {
        let board = Board(squaresWide: 8, squaresHigh: 8)
        let attacker = Man(piece: Piece.star(), player: red)
        board.putMan(man: attacker, x: 2, y: 2)
        let defender = Man(piece: Piece.rook(), player: blue)
        board.putMan(man: defender, x: 3, y: 2)
        let attackingAbility = attacker.abilities.first(where: { $0.xOffset == 1 && $0.yOffset == 0 })!
        let move = Move(fromX: 2, fromY: 2, toX: 3, toY: 2, attackingMan: attacker, attackingAbility: attackingAbility)
        XCTAssertEqual(defender.defenseResult(move: move), .AbilityDemoted)
    }
    
    func test_generateMoves() throws {
        let board = Board(squaresWide: 8, squaresHigh: 8)
        let man = Man(piece: Piece.rook(), player: red)
        board.putMan(man: man, x: 2, y: 2)
        let moves = man.generateMoves(board: board, x: 2, y: 2)
        XCTAssertEqual(moves.count, 14)
    }
    
    func test_generateMovesBiggerBoard() throws {
        let board = Board(squaresWide: 10, squaresHigh: 8)
        let man = Man(piece: Piece.rook(), player: red)
        board.putMan(man: man, x: 2, y: 2)
        let moves = man.generateMoves(board: board, x: 2, y: 2)
        XCTAssertEqual(moves.count, 16)
    }
    
    func test_clone() throws {
        let board = Board(squaresWide: 10, squaresHigh: 8)
        let man = Man(piece: Piece.rook(), player: red)
        board.putMan(man: man, x: 2, y: 2)
        let cloned = man.clone()
        man.abilities.remove(at: 0)
        XCTAssertNotEqual(man.abilities.count, cloned.abilities.count)
    }
    
    func test_valueChanges() throws {
        let board = Board(squaresWide: 8, squaresHigh: 8)
        let attacker = Man(piece: Piece.star(), player: red)
        board.putMan(man: attacker, x: 2, y: 2)
        let defender = Man(piece: Piece.rook(), player: blue)
        board.putMan(man: defender, x: 3, y: 2)
        let defenderValueBefore = defender.value
        let attackingAbility = attacker.abilities.first(where: { $0.xOffset == 1 && $0.yOffset == 0 })!
        let move = Move(fromX: 2, fromY: 2, toX: 3, toY: 2, attackingMan: attacker, attackingAbility: attackingAbility)
        XCTAssertEqual(defender.defenseResult(move: move), .AbilityDemoted)
        XCTAssertNotEqual(defenderValueBefore, defender.value)
    }
}

//
// Copyright (c) 2024 and Confidential to Eric Ford Consulting All rights reserved.
//

import XCTest
@testable import Wounds

final class AbilityTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEquals() throws {
        let ability1 = Ability(abilityType: .Step, xOffset: 1, yOffset: 0)
        let ability2 = Ability(abilityType: .Step, xOffset: 1, yOffset: 0)
        XCTAssertEqual(ability1, ability2)
    }
    
    func testNotEquals() throws {
        let ability1 = Ability(abilityType: .Step, xOffset: 1, yOffset: 0)
        let ability2 = Ability(abilityType: .Step, xOffset: -1, yOffset: 0)
        XCTAssertNotEqual(ability1, ability2)
    }
    
    func test_getOpposite() throws {
        let ability1 = Ability(abilityType: .Step, xOffset: 1, yOffset: 0)
        let ability2 = Ability(abilityType: .Step, xOffset: -1, yOffset: 0)
        XCTAssertEqual(ability1.getOpposite(), ability2)
    }
    
    func test_getOppositeFalse() throws {
        let ability1 = Ability(abilityType: .Step, xOffset: 1, yOffset: 0)
        let ability2 = Ability(abilityType: .Step, xOffset: 1, yOffset: 0)
        XCTAssertNotEqual(ability1.getOpposite(), ability2)
    }
    
    func test_getOppositeStepVSSlideFalse() throws {
        let ability1 = Ability(abilityType: .Step, xOffset: 1, yOffset: 0)
        let ability2 = Ability(abilityType: .Slide, xOffset: -1, yOffset: 0)
        XCTAssertNotEqual(ability1.getOpposite(), ability2)
    }
    
    func test_getDefenseResultRemovedStep() throws {
        let ability1 = Ability(abilityType: .Step, xOffset: 1, yOffset: 0)
        let ability2 = Ability(abilityType: .Step, xOffset: -1, yOffset: 0)
        XCTAssertEqual(ability1.getDefenseResult(attackingAbility: ability2), .AbilityRemoved)
    }
    
    func test_getDefenseResultRemovedSlide() throws {
        let ability1 = Ability(abilityType: .Slide, xOffset: 1, yOffset: 0)
        let ability2 = Ability(abilityType: .Slide, xOffset: -1, yOffset: 0)
        XCTAssertEqual(ability1.getDefenseResult(attackingAbility: ability2), .AbilityRemoved)
    }
    
    func test_getDefenseResultDemoted() throws {
        let ability1 = Ability(abilityType: .Slide, xOffset: 1, yOffset: 0)
        let ability2 = Ability(abilityType: .Step, xOffset: -1, yOffset: 0)
        XCTAssertEqual(ability1.getDefenseResult(attackingAbility: ability2), .AbilityDemoted)
    }
    
    func test_getDefenseResultDemotedFat() throws {
        let ability1 = Ability(abilityType: .Fat, xOffset: 1, yOffset: 0)
        let ability2 = Ability(abilityType: .Step, xOffset: -1, yOffset: 0)
        XCTAssertEqual(ability1.getDefenseResult(attackingAbility: ability2), .AbilityDemoted)
    }
    
    func test_getDefenseResultCaptured() throws {
        let ability1 = Ability(abilityType: .Step, xOffset: 1, yOffset: 0)
        let ability2 = Ability(abilityType: .Slide, xOffset: -1, yOffset: 0)
        XCTAssertEqual(ability1.getDefenseResult(attackingAbility: ability2), .PieceCaptured)
    }
    
    func test_getDefenseResultCapturedFat() throws {
        let ability1 = Ability(abilityType: .Step, xOffset: 1, yOffset: 0)
        let ability2 = Ability(abilityType: .Fat, xOffset: -1, yOffset: 0)
        XCTAssertEqual(ability1.getDefenseResult(attackingAbility: ability2), .PieceCaptured)
    }
    
    // the board has to have a man on the square to generate moves
    func test_generateMovesStep() throws {
        let board = Board(squaresWide: 8, squaresHigh: 8)
        let man = Man(piece: Piece.star(), player: red)
        board.putMan(man: man, x: 2, y: 2)
        let ability = man.abilities[0]
        let moves = ability.generateMoves(player: red, board: board, x: 2, y: 2)
        XCTAssertEqual(moves.count, 1)
    }
    
    func test_generateMovesSlide() throws {
        let board = Board(squaresWide: 8, squaresHigh: 8)
        let man = Man(piece: Piece.rook(), player: red)
        board.putMan(man: man, x: 2, y: 2)
        let ability = man.abilities[0]
        let moves = ability.generateMoves(player: red, board: board, x: 2, y: 2)
        XCTAssertEqual(moves.count, 5)
    }
    
    func test_generateMovesKnight() throws {
        let board = Board(squaresWide: 8, squaresHigh: 8)
        let man = Man(piece: Piece.knight(), player: red)
        board.putMan(man: man, x: 4, y: 4)
        let ability = man.abilities[0]
        let moves = ability.generateMoves(player: red, board: board, x: 4, y: 4)
        XCTAssertEqual(moves.count, 1)
    }
    
    func test_value() throws {
        let ability1 = Ability(abilityType: .Jump, xOffset: 1, yOffset: 2)
        XCTAssertEqual(ability1.value, AbilityType.Jump.rawValue)
        let ability2 = Ability(abilityType: .Step, xOffset: 1, yOffset: 2)
        XCTAssertEqual(ability2.value, AbilityType.Step.rawValue)
        let ability3 = Ability(abilityType: .Slide, xOffset: 1, yOffset: 2)
        XCTAssertEqual(ability3.value, AbilityType.Slide.rawValue)
        let ability4 = Ability(abilityType: .Fat, xOffset: 1, yOffset: 2)
        XCTAssertEqual(ability4.value, AbilityType.Fat.rawValue)
    }

    func test_valueOfDemotion() throws {
        let ability1 = Ability(abilityType: .Fat, xOffset: 1, yOffset: 0)
        let ability2 = Ability(abilityType: .Step, xOffset: -1, yOffset: 0)
        XCTAssertEqual(ability1.getDefenseResult(attackingAbility: ability2), .AbilityDemoted)
        XCTAssertEqual(ability1.value, AbilityType.Step.rawValue)
        let ability3 = Ability(abilityType: .Slide, xOffset: 1, yOffset: 0)
        let ability4 = Ability(abilityType: .Step, xOffset: -1, yOffset: 0)
        XCTAssertEqual(ability3.getDefenseResult(attackingAbility: ability4), .AbilityDemoted)
        XCTAssertEqual(ability3.value, AbilityType.Step.rawValue)
    }
}

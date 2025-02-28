//
// Copyright (c) 2025 and Confidential to Eric Ford Consulting All rights reserved.
//

import XCTest
@testable import Wounds

final class MoveTreeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    var moveIndex = 0
    func generateMoves(board: Board, whoseTurn: Player) -> [Move] {
        let blueMan = Man(piece: Piece.star(), player: blue)
        let redMan = Man(piece: Piece.star(), player: red)
        
        // local func
        func getMan(player: Player) -> Man {
            if player == red {
                return redMan
            }
            else {
                return blueMan
            }
        }
        
        defer {
            moveIndex += 1
        }
        let man = getMan(player: whoseTurn)
        print("moveIndex \(moveIndex)")
        switch moveIndex {
        case 0: return [Move(fromX: 0, fromY: 0, toX: 0, toY: 1, attackingMan: man, attackingAbility: man.abilities[0])]
        case 1: return [Move(fromX: 0, fromY: 0, toX: 1, toY: 1, attackingMan: man, attackingAbility: man.abilities[0])]
        case 2: return [Move(fromX: 0, fromY: 0, toX: 2, toY: 2, attackingMan: man, attackingAbility: man.abilities[0])]
        case 3: return [Move(fromX: 0, fromY: 0, toX: 3, toY: 3, attackingMan: man, attackingAbility: man.abilities[0])]
        case 4: return [Move(fromX: 0, fromY: 0, toX: 4, toY: 4, attackingMan: man, attackingAbility: man.abilities[0])]
        case 5: return [Move(fromX: 0, fromY: 0, toX: 5, toY: 5, attackingMan: man, attackingAbility: man.abilities[0])]
        case 6: return [Move(fromX: 0, fromY: 0, toX: 6, toY: 6, attackingMan: man, attackingAbility: man.abilities[0])]
        case 7: return [Move(fromX: 0, fromY: 0, toX: 7, toY: 7, attackingMan: man, attackingAbility: man.abilities[0])]
        default:
            return []
        }
    }
    
    var evaluationIndex = 0
    func evaluator(board: Board, player: Player, moveCount: Int) -> Int {
        let scores = [2, 3, 5, 9, 0, 1, 7, 5]
        let result = scores[evaluationIndex]
        print("evaluator.result \(result)")
        evaluationIndex += 1
        return result
    }
    
//    func test_alphaBetaPruneSTATIC() throws {
//        moveIndex = 0
//        evaluationIndex = 0
//        let board = Board(squaresWide: 8, squaresHigh: 8)
//        let attacker = Man(piece: Piece.star(), player: blue)
//        board.putMan(man: attacker, x: 3, y: 2)
//        let defender = Man(piece: Piece.star(), player: red)
//        board.putMan(man: defender, x: 2, y: 2)
//        let moveTree = MoveTree(players: [red, blue], ai: red, position: board, evaluator: evaluator, moveGenerator: generateMoves)
//        let best = moveTree.alphaBetaPrune(position: board, players: [red, blue], whoseTurn: blue, depth: 2, alpha: Int.min, beta: Int.max, isMaximizingPlayer: false)
//        print("best \(best)")
//        
//    }
    
    func boardEvaluate(board: Board, whoseTurn: Player, moveCount: Int) -> Int {
        var score = 0
        for rank in 0..<board.squaresHigh {
            for file in 0..<board.squaresWide {
                if let man = board.squares[file][rank].man {
                    if man.player == whoseTurn {
                        score += man.value
//                        print("\(man.player.name) \(score)")
                    }
                    else {
                        score -= man.value
//                        print("\(man.player.name) \(score)")
                    }
                }
            }
        }
        return score + moveCount
    }
    
    func boardGenerateMoves(board: Board, whoseTurn: Player) -> [Move] {
        return board.generateMoves(player: whoseTurn)
    }

    func comparableBoardSetup() -> (MoveTree, Board) {
        let board = Board(squaresWide: 8, squaresHigh: 8)
        let blueStar = Man(piece: Piece.star(), player: blue)
        board.putMan(man: blueStar, x: 0, y: 0)
        let attacker = Man(piece: Piece.rook(), player: blue)
        board.putMan(man: attacker, x: 3, y: 2)
        let defenderStar = Man(piece: Piece.star(), player: red)
        board.putMan(man: defenderStar, x: 2, y: 3)
//        let defenderBishop = Man(piece: Piece.star(), player: red)
//        board.putMan(man: defenderBishop, x: 5, y: 2)
        return (MoveTree(players: [red, blue], ai: blue, position: board, evaluator: boardEvaluate, moveGenerator: boardGenerateMoves), board)
    }
    
//    func test_alphaBetaPrune() throws {
//        let (moveTree, board) = comparableBoardSetup()
//        if let best = moveTree.alphaBetaPrune(position: board, players: [red, blue], whoseTurn: blue, depth: 2, alpha: Int.min, beta: Int.max, isMaximizingPlayer: true) {
//            print("best: \(best.fromX) \(best.fromY) -  \(best.toX) \(best.toY) score \(best.score)")
//        }
////        if let best = moveTree.alphaBetaPrune(position: board, players: [red, blue], whoseTurn: red, depth: 1, alpha: Int.min, beta: Int.max, isMaximizingPlayer: false) {
////            print("best: \(best.fromX) \(best.fromY) -  \(best.toX) \(best.toY) score \(best.score)")
////        }
//    }
    
    func test_minMax() throws {
        let (moveTree, board) = comparableBoardSetup()
        let bestNode = moveTree.miniMax(position: board, players: [red, blue], whoseTurn: red, depth: 2)
        if let best = bestNode.move {
            print("best: \(best.fromX) \(best.fromY) -  \(best.toX) \(best.toY) score \(best.score)")
        }
    }
    
//    func test_WORKSminiMax() throws {
//        let (moveTree, board) = comparableBoardSetup()
//        let best = moveTree.WORKSminiMax(position: board, players: [red, blue], whoseTurn: blue, depth: 2)
//        if let move = best.move {
//            print("best: \(move.fromX) \(move.fromY) -  \(move.toX) \(move.toY) score \(move.score)")
//        }
//        else {
//            print("no move")
//        }
//    }

//    func test_getBestMove() throws {
//        evaluationIndex = 0
//        let board = Board(squaresWide: 8, squaresHigh: 8)
//        let attacker = Man(piece: Piece.rook(), player: blue)
//        board.putMan(man: attacker, x: 3, y: 2)
//        let defenderStar = Man(piece: Piece.star(), player: red)
//        board.putMan(man: defenderStar, x: 1, y: 2)
//        let defenderBishop = Man(piece: Piece.star(), player: red)
//        board.putMan(man: defenderBishop, x: 5, y: 2)
//        let moveTree = MoveTree(players: [red, blue], ai: blue, position: board, evaluator: boardEvaluate, moveGenerator: boardGenerateMoves)
//
//        if let best = moveTree.getBestMove(position: board, depth: 2, players: [red, blue], whoseTurn: blue, isMaximizingPlayer: true) {
//            print("best: \(best.fromX) \(best.fromY) -  \(best.toX) \(best.toY)")
//        }
//    }
//    
//    func test_alphaBeta() throws {
//        let (moveTree, board) = comparableBoardSetup()
//        if let best = moveTree.alphaBeta(position: board, players: [red, blue], whoseTurn: blue, depth: 2, alpha: Int.min, beta: Int.max) {
//            print("best: \(best.fromX) \(best.fromY) -  \(best.toX) \(best.toY) score: \(best.score)")
//        }
//    }
    
    
    func test_negamax() throws {
        let (moveTree, board) = comparableBoardSetup()
        let (score, bestMove) = moveTree.negamax(position: board, players: [red, blue], whoseTurn: red, depth: 2, alpha: Int.min, beta: Int.max)
        if let best = bestMove {
            print("best: \(best.fromX) \(best.fromY) -  \(best.toX) \(best.toY) score: \(score)")
        }
    }
}

//
// Copyright (c) 2024 and Confidential to Eric Ford Consulting All rights reserved.
//

import WoundsEngine

class MoveTree {
    var players: [Player]
    var ai: Player
    var position: Board
    var headNode: MoveNode
    var score = 0
    var evaluator: (Board, Player) -> Int
    var moveGenerator: (Board, Player) -> [Move]

    init(players: [Player], ai: Player, position: Board, evaluator: @escaping (Board, Player) -> Int = MoveTree.materialScore, moveGenerator: @escaping (Board, Player) -> [Move]) {
        self.players = players
        self.ai = ai
        self.position = position
        headNode = MoveNode(position: position, player: ai)
        self.evaluator = evaluator
        self.moveGenerator = moveGenerator
    }
    
    static func materialScore(board: Board, whoseTurn: Player) -> Int {
        var score = 0
        for rank in 0..<board.squaresHigh {
            for file in 0..<board.squaresWide {
                if let man = board.squares[file][rank].man {
                    if man.player == whoseTurn {
                        score += man.value
                    }
                    else {
                        score -= man.value
                    }
                }
            }
        }
        return score
    }

    func nextPlayer(player: Player) -> Player {
        return player == players[0] ? players[1] : players[0]
    }
        
    func miniMax(position: Board, players: [Player], whoseTurn: Player, depth: Int) -> MoveNode {
        var bestMoveNode = MoveNode(position: position, player: whoseTurn)
        let moves = moveGenerator(position, whoseTurn)
        for move in moves {
            let clone = position.clone()
            clone.makeMove(move: move, depth: depth)
            let moveNode = MoveNode(position: clone, player: whoseTurn, move: move)
            if depth == 0 {
                moveNode.move!.score = evaluator(clone, whoseTurn)
            }
            else {
                let bestNode = miniMax(position: clone, players: players, whoseTurn: nextPlayer(player: whoseTurn), depth: depth - 1)
                if bestNode.move != nil {
                    moveNode.move!.score = -bestNode.move!.score
                }
                else {
                    moveNode.move!.score = Int.max
                }
            }
            
            if bestMoveNode.move == nil || moveNode.move!.score > bestMoveNode.move!.score {
                bestMoveNode = moveNode
            }
        }
        return bestMoveNode
    }

    // avoiding error where -Int.max (and maybe -Int.min) result in numeric overflow
    // this could be more efficient with constants like let infinity = Int.max - 10
    func negate(number: Int) -> Int {
        if number == Int.max { return Int.min }
        if number == Int.min { return Int.max }
        else { return -number }
    }

    func negateMaximum(_ a: Int, _ b:Int) -> Int {
        if a > b {
            return negate(number: a)
        }
        else { // if a == b we're returning b
            return negate(number: b)
        }
    }
    

    func miniMaxCoreWORKS(position: Board, players: [Player], whoseTurn: Player, depth: Int) -> Int {
        var bestValue = Int.min
        let moves = moveGenerator(position, whoseTurn)
        for move in moves {
            let clone = position.clone()
            clone.makeMove(move: move, depth: depth)
            if position.thereIsAWinner(players: players) != nil || (depth == 0) {
                move.score = evaluator(clone, whoseTurn)
            }
            else {
                let bestChildValue = miniMaxCoreWORKS(position: clone, players: players, whoseTurn: nextPlayer(player: whoseTurn), depth: depth - 1)
                move.score = bestChildValue
            }
            if move.score > bestValue {
                bestValue = move.score
            }
        }
        return negate(number: bestValue)
    }
    

    func miniMaxWORKS(position: Board, players: [Player], whoseTurn: Player, depth: Int) -> Move? {
        var bestMove: Move? = nil
        let moves = moveGenerator(position, whoseTurn)
        for move in moves {
            let clone = position.clone()
            clone.makeMove(move: move, depth: depth)
            if position.thereIsAWinner(players: players) != nil || (depth == 0) {
                move.score = evaluator(clone, whoseTurn)
            }
            else {
                let bestChildCore = miniMaxCoreWORKS(position: clone, players: players, whoseTurn: nextPlayer(player: whoseTurn), depth: depth - 1)
                move.score = bestChildCore
            }
            if bestMove == nil || move.score > bestMove!.score {
                bestMove = move
            }
        }
        return bestMove
    }
    
    func negamax(position: Board, players: [Player], whoseTurn: Player, depth: Int, alpha: Int = Int.min, beta: Int = Int.max) -> (Int, Move?) {
        let moves = moveGenerator(position, whoseTurn)
        if position.thereIsAWinner(players: players) != nil || (depth == 0) {
            return (evaluator(position, whoseTurn), nil)
        }
        var bestScore = Int.min
        var bestMove: Move?
        for move in moves {
            let clone = position.clone()
            clone.makeMove(move: move, depth: depth)
            let (recursedScore, _) = negamax(position: clone, players: players, whoseTurn: nextPlayer(player: whoseTurn), depth: depth - 1, alpha: -beta, beta: negateMaximum(alpha, bestScore))
            let currentScore = negate(number: recursedScore)
            if currentScore > bestScore {
                bestScore = currentScore
                bestMove = move
            }
            if bestScore >= beta {
                break
            }
//            if depth == 2 {
//                print("move \(move.fromX)  \(move.fromY) - \(move.toX) \(move.toY) : \(currentScore)")
//            }
        }
        return (bestScore, bestMove)
    }
}

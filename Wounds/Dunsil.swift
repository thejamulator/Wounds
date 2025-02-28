//
// Copyright (c) 2025 and Confidential to Eric Ford Consulting All rights reserved.
//

//func alphaBetaPruneCore(position: Board, players: [Player], whoseTurn: Player, depth: Int, alpha: Int, beta: Int, isMaximizingPlayer: Bool) -> Int {
//    var currentAlpha = alpha
//    var currentBeta = beta
//    let moves = position.generateMoves(player: whoseTurn)
//    if isMaximizingPlayer {
//        var maxEval: Int = Int.min
//        for move in moves {
//            let clone = position.clone()
//            clone.makeMove(move: move)
//            if depth == 0 {
//                return evaluator(clone, whoseTurn, moves.count) //clone.materialScore(whoseTurn: whoseTurn) + moves.count // for mobility
//            }
//            else {
//                let bestChildValue = alphaBetaPruneCore(position: clone, players: players, whoseTurn: nextPlayer(player: whoseTurn), depth: depth - 1, alpha: currentAlpha, beta: currentBeta, isMaximizingPlayer: !isMaximizingPlayer)
//                maxEval = max(maxEval, bestChildValue)
//                currentAlpha = max(currentAlpha, bestChildValue)
//                if currentBeta <= currentAlpha {
//                    print("isMaximizingPlayer alpha cutoff")
//                    break
//                }
//            }
//        }
//        return maxEval
//    }
//    else {
//        var minEval: Int = Int.max
//        for move in moves {
//            let clone = position.clone()
//            clone.makeMove(move: move)
//            if depth == 0 {
//                print("MIN evaluator \(evaluator(clone, whoseTurn, moves.count))")
//                return evaluator(clone, whoseTurn, moves.count) //clone.materialScore(whoseTurn: whoseTurn) + moves.count // for mobility
//            }
//            else {
//                let bestChildValue = alphaBetaPruneCore(position: clone, players: players, whoseTurn: nextPlayer(player: whoseTurn), depth: depth - 1, alpha: currentAlpha, beta: currentBeta, isMaximizingPlayer: !isMaximizingPlayer)
//                minEval = min(minEval, bestChildValue)
//                currentBeta = min(currentBeta, minEval)
//                if currentBeta <= currentAlpha {
//                    print("is NOT MaximizingPlayer beta cutoff")
//                    break
//                }
//            }
//        }
//        return minEval
//    }
//}
//
//func alphaBetaPrune(position: Board, players: [Player], whoseTurn: Player, depth: Int, alpha: Int, beta: Int, isMaximizingPlayer: Bool) -> Move? {
//    var bestMove: Move? = nil
//    let moves = position.generateMoves(player: whoseTurn)
//    for move in moves {
//        let clone = position.clone()
//        clone.makeMove(move: move)
//        if depth == 0 {
//            move.score = evaluator(clone, whoseTurn, moves.count) //clone.materialScore(whoseTurn: whoseTurn) + moves.count // for mobility
//        }
//        else {
//            let bestChildCore = alphaBetaPruneCore(position: clone, players: players, whoseTurn: nextPlayer(player: whoseTurn), depth: depth - 1, alpha: alpha, beta: beta, isMaximizingPlayer: isMaximizingPlayer)
//            move.score = bestChildCore
//            print("\(move.fromX) \(move.fromY) -  \(move.toX) \(move.toY) score \(move.score)")
//        }
//        if bestMove == nil || move.score > bestMove!.score {
//            bestMove = move
//        }
//    }
//    return bestMove
//}

//func miniMaxCore(position: Board, players: [Player], whoseTurn: Player, depth: Int, alpha: Int, beta: Int, isMaximizingPlayer: Bool) -> Int {
////        var bestValue = Int.min
//    var currentAlpha = alpha
//    var currentBeta = beta
//    let moves = position.generateMoves(player: whoseTurn)
//    if isMaximizingPlayer {
//        var maxEval: Int = Int.min
//        for move in moves {
//            let clone = position.clone()
//            clone.makeMove(move: move)
//            if depth == 0 {
//                move.score = evaluator(clone, whoseTurn, moves.count) //clone.materialScore(whoseTurn: whoseTurn) + moves.count // for mobility
//                print("MAXIMIZER: \(whoseTurn.name): \(move.fromX) \(move.fromY) -  \(move.toX) \(move.toY) score \(move.score)")
//            }
//            else {
////                    let bestChildValue = miniMaxCore(position: clone, players: players, whoseTurn: nextPlayer(player: whoseTurn), depth: depth - 1, alpha: currentAlpha, beta: currentBeta, isMaximizingPlayer: !isMaximizingPlayer)
//                let bestChildValue = miniMaxCoreWORKS(position: clone, players: players, whoseTurn: nextPlayer(player: whoseTurn), depth: depth - 1, isMaximizingPlayer: !isMaximizingPlayer)
//                maxEval = max(maxEval, bestChildValue)
//                move.score = maxEval
//                currentAlpha = max(currentAlpha, bestChildValue)
//                if currentBeta <= currentAlpha {
//                    print("isMaximizingPlayer alpha cutoff")
//                    break
//                }
//            }
////                if move.score > bestValue {
////                    bestValue = move.score
////                }
//        }
//        return maxEval
//    }
//    else {
//        var minEval: Int = Int.max
//        for move in moves {
//            let clone = position.clone()
//            clone.makeMove(move: move)
//            if depth == 0 {
//                move.score = evaluator(clone, whoseTurn, moves.count) //clone.materialScore(whoseTurn: whoseTurn) + moves.count // for mobility
//                print("MINIMIZER --- \(whoseTurn.name): \(move.fromX) \(move.fromY) -  \(move.toX) \(move.toY) score \(move.score)")
//            }
//            else {
//                let bestChildValue = miniMaxCoreWORKS(position: clone, players: players, whoseTurn: nextPlayer(player: whoseTurn), depth: depth - 1, isMaximizingPlayer: !isMaximizingPlayer)
////                    let bestChildValue = miniMaxCore(position: clone, players: players, whoseTurn: nextPlayer(player: whoseTurn), depth: depth - 1, alpha: currentAlpha, beta: currentBeta, isMaximizingPlayer: !isMaximizingPlayer)
//                minEval = min(minEval, bestChildValue)
//                move.score = minEval
//                currentBeta = min(currentBeta, minEval)
//                if currentBeta <= currentAlpha {
//                    print("is NOT MaximizingPlayer beta cutoff")
//                    break
//                }
//            }
////                if move.score > bestValue {
////                    bestValue = move.score
////                }
//        }
//        return minEval
//    }
////        return -bestValue
//}
//
//func miniMax(position: Board, players: [Player], whoseTurn: Player, depth: Int) -> Move? {
//    var bestMove: Move? = nil
//    let moves = position.generateMoves(player: whoseTurn)
//    for move in moves {
//        let clone = position.clone()
//        clone.makeMove(move: move)
//        if depth == 0 {
//            move.score = evaluator(clone, whoseTurn, moves.count) //clone.materialScore(whoseTurn: whoseTurn) + moves.count // for mobility
//        }
//        else {
//            let bestChildCore = miniMaxCore(position: clone, players: players, whoseTurn: nextPlayer(player: whoseTurn), depth: depth - 1, alpha: Int.min, beta: Int.max, isMaximizingPlayer: true)
//            move.score = bestChildCore
//        }
//        if bestMove == nil || move.score > bestMove!.score {
//            bestMove = move
//        }
//        print("\(move.fromX) \(move.fromY) -  \(move.toX) \(move.toY) score \(move.score)")
//    }
//    return bestMove
//}

//func getBestMove(position: Board, depth: Int, players: [Player], whoseTurn: Player, isMaximizingPlayer: Bool) -> Move? {
//    var bestMove: Move?
//    var bestValue: Int = isMaximizingPlayer ? Int.min : Int.max
//    let alpha: Int = Int.min
//    let beta: Int = Int.max
//    for move in moveGenerator(position, whoseTurn) {
//        let clone = position.clone()
//        clone.makeMove(move: move)
//        if let bestChild = miniMax(position: position, players: players, whoseTurn: players[1], depth: 2) {
//            if bestChild.score > bestValue {
//                bestMove = bestChild
//            }
//        }
////            let bestChild = WORKSminiMax(position: position, players: players, whoseTurn: players[1], depth: 2)
////            if bestChild.move!.score > bestValue {
////                bestMove = move
////            }
//
////            let moveValue = minimax(position: clone, depth: depth - 1, players: players, whoseTurn: nextPlayer(player: whoseTurn), isMaximizingPlayer: !isMaximizingPlayer, alpha: alpha, beta: beta)
////            let moveValue = alphaBetaPrune(position: position, players: players, whoseTurn: whoseTurn, depth: depth - 1, alpha: alpha, beta: beta, isMaximizingPlayer: isMaximizingPlayer)
////            if (isMaximizingPlayer && moveValue > bestValue) || (!isMaximizingPlayer && moveValue < bestValue) {
////                bestValue = moveValue
////            if bestChild > bestValue {
////                bestMove = move
////            }
//    }
//    return bestMove
//}
//func minimax(position: Board, depth: Int, players: [Player], whoseTurn: Player, isMaximizingPlayer: Bool, alpha: Int, beta: Int) -> Int {
//    let moves = position.generateMoves(player: whoseTurn)
//    if depth == 0 || position.thereIsAWinner(players: players) != nil {
//        return evaluator(position, whoseTurn, moves.count)
//    }
//
//    var alpha = alpha
//    var beta = beta
//
//    if isMaximizingPlayer {
//        var maxEval: Int = Int.min
//
//        for move in moveGenerator(position, whoseTurn) {
//            let clone = position.clone()
//            clone.makeMove(move: move)
//            let eval = minimax(position: position, depth: depth - 1, players: players, whoseTurn: nextPlayer(player: whoseTurn), isMaximizingPlayer: false, alpha: alpha, beta: beta)
//            maxEval = max(maxEval, eval)
//            alpha = max(alpha, eval)
//            if beta <= alpha {
//                print("isMaximizingPlayer alpha cutoff")
//                break
//            }
//        }
//        return maxEval
//    } else {
//        var minEval: Int = Int.max
//        for move in moveGenerator(position, whoseTurn) {
//            let clone = position.clone()
//            clone.makeMove(move: move)
//            let eval = minimax(position: position, depth: depth - 1, players: players, whoseTurn: nextPlayer(player: whoseTurn), isMaximizingPlayer: true, alpha: alpha, beta: beta)
//            minEval = min(minEval, eval)
//            beta = min(beta, minEval)
//            if beta <= alpha {
//                print("is NOT MaximizingPlayer beta cutoff")
//                break
//            }
//        }
//        return minEval
//    }
//}
//
//func alphaBeta(position: Board, players: [Player], whoseTurn: Player, depth: Int, alpha: Int, beta: Int) -> Move? {
//    var bestMove: Move? = nil
//    let moves = position.generateMoves(player: whoseTurn)
//    for move in moves {
//        let clone = position.clone()
//        clone.makeMove(move: move)
//        if depth == 0 {
//            move.score = evaluator(clone, whoseTurn, moves.count) //clone.materialScore(whoseTurn: whoseTurn) + moves.count // for mobility
//        }
//        else {
//            let bestChildCore = alphaBetaMax(position: clone, players: players, whoseTurn: nextPlayer(player: whoseTurn), depth: depth - 1, alpha: alpha, beta: beta)
//            move.score = bestChildCore
//            print("\(move.fromX) \(move.fromY) -  \(move.toX) \(move.toY) score \(move.score)")
//        }
//        if bestMove == nil || move.score > bestMove!.score {
//            bestMove = move
//        }
//    }
//    return bestMove
//}
//
//
//func alphaBetaMax(position: Board, players: [Player], whoseTurn: Player, depth: Int, alpha: Int, beta: Int) -> Int {
//    var alpha = alpha
////        var beta = beta
//    let moves = moveGenerator(position, whoseTurn)
//    if depth == 0 { return evaluator(position, whoseTurn, moves.count) }
//    var bestValue = Int.min
//    for move in moves {
//        let clone = position.clone()
//        clone.makeMove(move: move)
//        let score = alphaBetaMin(position: clone, players: players, whoseTurn: nextPlayer(player: whoseTurn), depth: depth - 1, alpha: alpha, beta: beta)
//        if score > bestValue {
//            bestValue = alpha
//            if score > alpha {
//                alpha = score // alpha acts like max in MiniMax
//            }
//        }
//        if score >= beta {
//            print("fail soft beta-cutoff")
//            return score   // fail soft beta-cutoff
//        }
//   }
//   return bestValue
//}
//
//func alphaBetaMin(position: Board, players: [Player], whoseTurn: Player, depth: Int, alpha: Int, beta: Int) -> Int {
////        var alpha = alpha
//    var beta = beta
//    let moves = moveGenerator(position, whoseTurn)
//    if depth == 0 { return -evaluator(position, whoseTurn, moves.count) }
//    var bestValue = Int.max
//    for move in moves {
//        let clone = position.clone()
//        clone.makeMove(move: move)
//        let score = alphaBetaMax(position: clone, players: players, whoseTurn: nextPlayer(player: whoseTurn), depth: depth - 1, alpha: alpha, beta: beta)
//        if score < bestValue {
//            bestValue = score
//            if score < beta {
//                beta = score; // beta acts like min in MiniMax
//            }
//        }
//        if score <= alpha {
//            print("fail soft alpha-cutoff")
//            return score // fail soft alpha-cutoff, break can also be used here
//        }
//   }
//   return bestValue
//}

//func miniMaxCoreWORKS(position: Board, players: [Player], whoseTurn: Player, depth: Int, isMaximizingPlayer: Bool) -> Int {
//    var bestValue = Int.min
//    let moves = position.generateMoves(player: whoseTurn)
//    for move in moves {
//        let clone = position.clone()
//        clone.makeMove(move: move)
//        if depth == 0 {
//            move.score = evaluator(clone, whoseTurn, moves.count) //clone.materialScore(whoseTurn: whoseTurn) + moves.count // for mobility
//        }
//        else {
//            let bestChildValue = miniMaxCoreWORKS(position: clone, players: players, whoseTurn: nextPlayer(player: whoseTurn), depth: depth - 1, isMaximizingPlayer: !isMaximizingPlayer)
//            move.score = bestChildValue
//        }
//        if move.score > bestValue {
//            bestValue = move.score
//        }
//    }
//    return -bestValue
//}
//    


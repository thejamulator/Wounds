////
//// Copyright (c) 2024 and Confidential to Eric Ford Consulting All rights reserved.
////
//
//import SwiftUI
//
//class Board : ObservableObject
//{
//    var squaresWide: Int
//    var squaresHigh: Int
//    var squares = [[Square]]()
////    var men = [Man]() // could speed up move generation
//    
//    // for hilighting
//    var showHilightsAtStart = false
//    var fromX: Int?, fromY: Int?, toX: Int?, toY: Int?
//    var player: Player?
//    
//    init(squaresWide: Int, squaresHigh: Int)
//    {
//        self.squaresWide = squaresWide
//        self.squaresHigh = squaresHigh
//        for file in 0..<squaresWide
//        {
//            self.squares.append([Square]())
//            for _ in 0..<squaresHigh
//            {
//                self.squares[file].append(Square(squareType: .Normal))
//            }
//        }
//    }
//    
//    func clone() -> Board {
//        let clonedBoard = Board(squaresWide: squaresWide, squaresHigh: squaresHigh)
//        for file in 0..<squaresWide
//        {
//            for rank in 0..<squaresHigh
//            {
//                if let man = squares[file][rank].man {
//                    clonedBoard.squares[file][rank].man = man.clone()
//                }
//            }
//        }
//        return clonedBoard
//    }
//    
//    // in the initial game, Annihilation, there are no draws
//    // TODO: this will only work corectly for 2 player games
//    func thereIsAWinner(players: [Player]) -> Player? {
//        var winner: Player? = nil
//        var playersThatHaveMenLeft = [Player]()
//        
//        // local func
//        func nobodyDead() -> Bool {
//            return playersThatHaveMenLeft.count == players.count
//        }
//        
//        for rank in 0..<squaresHigh {
//            for file in 0..<squaresWide {
//                if let man = squares[file][rank].man {
//                    if !playersThatHaveMenLeft.contains(man.player) {
//                        playersThatHaveMenLeft.append(man.player)
//                        if nobodyDead() {
//                            return winner
//                        }
//                    }
//                }
//            }
//        }
//        if !nobodyDead() {
//            winner = playersThatHaveMenLeft[0]
//        }
//        return winner
//    }
//    
//    func centrality(file: Int) -> Int {
//        if file > (squaresWide / 2) - 1 {
//            return abs(squaresWide - file) - 1
//        }
//        else {
//            return file
//        }
//    }
//    
//    func centrality(rank: Int) -> Int {
//        if rank > (squaresHigh / 2) - 1 {
//            return abs(squaresWide - 1 - rank)
//        }
//        else {
//            return rank
//        }
//    }
//    
//    func centrality(file: Int, rank: Int) -> Int {
//        var result = 0
//        result += centrality(file: file)
//        result += centrality(rank: rank)
//        return result
//    }
//    
//    // TODO: rounding off to Int here will be inaccurate
//    func gravitationalCenter(player: Player) -> (Int, Int) {
//        var numberOfMen = 0
//        var accumulateX = 0
//        var accumulateY = 0
//        for rank in 0..<squaresHigh {
//            for file in 0..<squaresWide {
//                if let man = squares[file][rank].man {
//                    if man.player == player {
////                        print("man at \(file) \(rank)")
//                        accumulateX += file
//                        accumulateY += rank
//                        numberOfMen += 1
//                    }
//                }
//            }
//        }
//        if numberOfMen > 0 {
////            print("accumulateX \(accumulateX) accumulateY \(accumulateY) numberOfMen \(numberOfMen) averageX \(accumulateX / numberOfMen) averageY \(accumulateY / numberOfMen)")
//            return (accumulateX / numberOfMen, accumulateY / numberOfMen)
//        }
//        else {
//            return (4, 4) // meaningless if there are no men left on the team
//        }
//    }
//    
//    func gravitationalDistance(gravX: Int, gravY: Int, file: Int, rank: Int) -> Int {
//        let distanceX = abs(gravX - file)
//        let distanceY = abs(gravY - rank)
//        return distanceX + distanceY
//    }
//    
//    func dump() {
//        for rank in 0..<squaresHigh {
//            var accumulate = ""
//            for file in 0..<squaresWide {
//                if squares[file][rank].man == nil {
//                    accumulate +=  "-"
//                }
//                else {
//                    if squares[file][rank].man?.player.name == "Red" {
//                        accumulate +=  "R"
//                    }
//                    else {
//                        accumulate +=  "B"
//                    }
//                }
//            }
//            print(accumulate)
//        }
//    }
//    
//    func putMan(man: Man, x: Int, y: Int)
//    {
//        self.squares[x][y].man = man
//    }
//    
//    func makeMove(move: Move, depth: Int)
//    {
//        if move.attackingAbility?.abilityType == .RotateLeft {
//            move.attackingMan.rotateLeft()
//            if depth != 0 { // stop the horizon effect where you keep rotating and getting wounded again
//                move.attackingMan.value = move.attackingMan.calculateValue()
//            }
//        }
//        else if move.attackingAbility?.abilityType == .RotateRight {
//            move.attackingMan.rotateRight()
//            if depth != 0 { // see above
//                move.attackingMan.value = move.attackingMan.calculateValue()
//            }
//        }
//        else {
//            let destination = squares[move.toX][move.toY]
//            if destination.man != nil {
//                move.defendingMan = destination.man!
//                let defenseResult = destination.man!.defenseResult(move: move)
//                if defenseResult != DefenseResult.PieceCaptured {
//                    destination.man?.wounded = true
//                    return // it's a wound, no need to move attacker
//                }
//            }
//            squares[move.toX][move.toY].man = move.attackingMan
//            squares[move.toX][move.toY].man?.player = move.attackingMan.player // necessary?
//            squares[move.fromX][move.fromY].man = nil
//        }
////        dump()
//    }
//    
//    func generateMoves(player: Player) -> [Move]
//    {
//        var moves = [Move]()
//        for rank in 0..<squaresHigh {
//            for file in 0..<squaresWide {
//                if let man = squares[file][rank].man {
//                    if man.player == player {
//                        moves += (man.generateMoves(board: self, x:  file, y: rank))
//                    }
//                }
//            }
//        }
//        return moves
//    }
//}

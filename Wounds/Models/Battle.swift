//
// Copyright (c) 2024 and Confidential to Eric Ford Consulting All rights reserved.
//

import Foundation

// A Battle corresponds to a level in an arcade game
class Battle
{
    var board: Board
    var players = [Player]()
    var whoseTurn: Player
    var blueIsAI = true {
        didSet {
            if blueIsAI {
                players = [red, blueAI]
            }
            else {
                players = [red, blue]
            }
            whoseTurn = players[0]
        }
    }

    init(board: Board)
    {
        self.board = board
        if blueIsAI {
            players = [red, blueAI]
        }
        else {
            players = [red, blue]
        }
        whoseTurn = players[0]
    }
    
    func nextPlayer() -> Player {
        if whoseTurn == players[0] {
            return players[1]
        }
        else {
            return players[0]
        }
    }
    
    func thereIsAWinner() -> Player? {
        return board.thereIsAWinner(players: players)
    }
    
    static func getMinimal() -> Battle {
        let board = Board(squaresWide: 8, squaresHigh: 8)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 0, y: 7)
        board.putMan(man: Man(piece: Piece.rook(), player: blue), x: 0, y: 1)
        return Battle(board: board)
    }
    
    static func getStar() -> Battle {
        let board = Board(squaresWide: 6, squaresHigh: 6)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 2, y: 2)
        return Battle(board: board)
    }
    
    static func getRook() -> Battle {
        let board = Board(squaresWide: 6, squaresHigh: 6)
        board.putMan(man: Man(piece: Piece.rook(), player: red), x: 2, y: 2)
        return Battle(board: board)
    }
    
    static func getRookWithBlocks() -> Battle {
        let board = Board(squaresWide: 6, squaresHigh: 6)
        board.putMan(man: Man(piece: Piece.rook(), player: red), x: 2, y: 2)
        board.putMan(man: Man(piece: Piece.rook(), player: blue), x: 2, y: 4)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 4, y: 2)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 2, y: 1)
        return Battle(board: board)
    }
    
    static func getKnight() -> Battle {
        let board = Board(squaresWide: 6, squaresHigh: 6)
        board.putMan(man: Man(piece: Piece.knight(), player: red), x: 2, y: 2)
        return Battle(board: board)
    }
    
    static func getKnightCanJump() -> Battle {
        let board = Board(squaresWide: 6, squaresHigh: 6)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 1, y: 1)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 2, y: 1)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 3, y: 1)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 1, y: 2)
        board.putMan(man: Man(piece: Piece.knight(), player: red), x: 2, y: 2)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 3, y: 2)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 1, y: 3)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 2, y: 3)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 3, y: 3)
        return Battle(board: board)
    }
    
    static func getKing() -> Battle {
        let board = Board(squaresWide: 6, squaresHigh: 6)
        board.putMan(man: Man(piece: Piece.king(), player: red), x: 2, y: 2)
        return Battle(board: board)
    }
    
    static func getBishopAndStar() -> Battle {
        let board = Board(squaresWide: 6, squaresHigh: 6)
        let star = Man(piece: Piece.star(), player: red)
        board.putMan(man: star, x: 2, y: 2)
        let bishop = Man(piece: Piece.bishop(), player: blue)
        board.putMan(man: bishop, x: 3, y: 2)
        return Battle(board: board)
    }
    
    static func getBishopCapturesStar() -> Battle {
        let board = Board(squaresWide: 6, squaresHigh: 6)
        let star = Man(piece: Piece.star(), player: blue)
        board.putMan(man: star, x: 2, y: 2)
        let bishop = Man(piece: Piece.bishop(), player: red)
        board.putMan(man: bishop, x: 3, y: 3)
        return Battle(board: board)
    }
    
    static func getBishopCanWoundBishop() -> Battle {
        let board = Board(squaresWide: 6, squaresHigh: 6)
        let star = Man(piece: Piece.bishop(), player: blue)
        board.putMan(man: star, x: 2, y: 3)
        let bishop = Man(piece: Piece.bishop(), player: red)
        board.putMan(man: bishop, x: 3, y: 4)
        return Battle(board: board)
    }
    
    static func getBishopWoundsBishop() -> Battle {
        let board = Board(squaresWide: 6, squaresHigh: 6)
        let star = Man(piece: Piece.bishop(), player: blue)
        board.putMan(man: star, x: 2, y: 3)
        let bishop = Man(piece: Piece.bishop(), player: red)
        board.putMan(man: bishop, x: 3, y: 4)
        let moves = bishop.generateMoves(board: board, x: 3, y: 4)
        if let move = moves.first(where: { $0.toX == 2 && $0.toY == 3 }) {
            board.makeMove(move: move, depth: 0)
            board.showHilightsAtStart = true
            board.fromX = 3
            board.fromY = 4
            board.toX = 2
            board.toY = 3
            board.player = red
        }
        return Battle(board: board)
    }
    
    static func getStarCanWoundBishop() -> Battle {
        let board = Board(squaresWide: 6, squaresHigh: 6)
        let star = Man(piece: Piece.bishop(), player: blue)
        board.putMan(man: star, x: 2, y: 3)
        let bishop = Man(piece: Piece.star(), player: red)
        board.putMan(man: bishop, x: 3, y: 4)
        return Battle(board: board)
    }
    
    static func getStarWoundsBishop() -> Battle {
        let board = Board(squaresWide: 6, squaresHigh: 6)
        let star = Man(piece: Piece.bishop(), player: blue)
        board.putMan(man: star, x: 2, y: 3)
        let bishop = Man(piece: Piece.star(), player: red)
        board.putMan(man: bishop, x: 3, y: 4)
        let moves = bishop.generateMoves(board: board, x: 3, y: 4)
        if let move = moves.first(where: { $0.toX == 2 && $0.toY == 3 }) {
            board.makeMove(move: move, depth: 0)
            board.showHilightsAtStart = true
            board.fromX = 3
            board.fromY = 4
            board.toX = 2
            board.toY = 3
            board.player = red
        }
        return Battle(board: board)
    }
    
    static func getPruneTest() -> Battle {
        let board = Board(squaresWide: 8, squaresHigh: 8)
        let blueStar = Man(piece: Piece.star(), player: blue)
        board.putMan(man: blueStar, x: 0, y: 0)
        let attacker = Man(piece: Piece.rook(), player: blue)
        board.putMan(man: attacker, x: 3, y: 2)
        let defenderStar = Man(piece: Piece.star(), player: red)
        board.putMan(man: defenderStar, x: 2, y: 3)
        let defenderBishop = Man(piece: Piece.star(), player: red)
        board.putMan(man: defenderBishop, x: 5, y: 2)
        return Battle(board: board)
    }
    
    static func getLastWoundTest() -> Battle {
        let board = Board(squaresWide: 8, squaresHigh: 8)
        board.putMan(man: Man(piece: Piece.queen(), player: red), x: 0, y: 7)
        board.putMan(man: Man(piece: Piece.queen(), player: red), x: 1, y: 7)
        board.putMan(man: Man(piece: Piece.queen(), player: red), x: 2, y: 7)
        board.putMan(man: Man(piece: Piece.queen(), player: red), x: 3, y: 7)
        board.putMan(man: Man(piece: Piece.queen(), player: red), x: 4, y: 7)
        board.putMan(man: Man(piece: Piece.queen(), player: red), x: 5, y: 7)
        board.putMan(man: Man(piece: Piece.queen(), player: red), x: 6, y: 7)
        board.putMan(man: Man(piece: Piece.queen(), player: red), x: 7, y: 7)
        board.putMan(man: Man(piece: Piece.queen(), player: red), x: 0, y: 0)
        board.putMan(man: Man(piece: Piece.queen(), player: red), x: 1, y: 0)
        board.putMan(man: Man(piece: Piece.queen(), player: red), x: 2, y: 0)
        board.putMan(man: Man(piece: Piece.queen(), player: red), x: 3, y: 0)
        board.putMan(man: Man(piece: Piece.queen(), player: red), x: 4, y: 0)
        board.putMan(man: Man(piece: Piece.queen(), player: red), x: 5, y: 0)
        board.putMan(man: Man(piece: Piece.queen(), player: red), x: 6, y: 0)
        board.putMan(man: Man(piece: Piece.queen(), player: red), x: 7, y: 0)
        board.putMan(man: Man(piece: Piece.king(), player: blue), x: 4, y: 4)

        return Battle(board: board)
    }
   
    static func getBootCampLevel1() -> Battle {
        let board = Board(squaresWide: 6, squaresHigh: 6)
        board.putMan(man: Man(piece: Piece.queen(), player: red), x: 0, y: 5)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 3, y: 0)
        board.putMan(man: Man(piece: Piece.queen(), player: red), x: 5, y: 5)
        return Battle(board: board)
    }
    
    static func getBootCampLevel2() -> Battle {
        let board = Board(squaresWide: 6, squaresHigh: 6)
        board.putMan(man: Man(piece: Piece.rook(), player: red), x: 0, y: 5)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 3, y: 0)
        board.putMan(man: Man(piece: Piece.rook(), player: red), x: 5, y: 5)
        return Battle(board: board)
    }
    
    static func getBootCampLevel3() -> Battle {
        let board = Board(squaresWide: 6, squaresHigh: 6)
        board.putMan(man: Man(piece: Piece.bishop(), player: red), x: 0, y: 5)
        board.putMan(man: Man(piece: Piece.king(), player: red), x: 3, y: 5)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 3, y: 0)
        board.putMan(man: Man(piece: Piece.bishop(), player: red), x: 5, y: 5)
        return Battle(board: board)
    }
    
    static func getBootCampLevel4() -> Battle {
        let board = Board(squaresWide: 6, squaresHigh: 6)
        board.putMan(man: Man(piece: Piece.knight(), player: red), x: 0, y: 5)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 3, y: 0)
        board.putMan(man: Man(piece: Piece.king(), player: red), x: 3, y: 5)
        board.putMan(man: Man(piece: Piece.knight(), player: red), x: 5, y: 5)
        return Battle(board: board)
    }
    
    static func getBootCampLevel5() -> Battle {
        let board = Board(squaresWide: 6, squaresHigh: 6)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 3, y: 0)
        board.putMan(man: Man(piece: Piece.king(), player: red), x: 3, y: 5)
        return Battle(board: board)
    }
    
    static func getBootCampLevel6() -> Battle {
        let board = Board(squaresWide: 6, squaresHigh: 6)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 0, y: 0)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 1, y: 0)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 2, y: 0)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 3, y: 0)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 4, y: 0)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 5, y: 0)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 0, y: 5)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 1, y: 5)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 2, y: 5)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 3, y: 5)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 4, y: 5)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 5, y: 5)
        board.putMan(man: Man(piece: Piece.king(), player: red), x: 3, y: 4)
        return Battle(board: board)
    }
    
    static func getAnnihiliation() -> Battle {
        let board = Board(squaresWide: 8, squaresHigh: 8)
        board.putMan(man: Man(piece: Piece.rook(), player: red), x: 0, y: 7)
        board.putMan(man: Man(piece: Piece.knight(), player: red), x: 1, y: 7)
        board.putMan(man: Man(piece: Piece.bishop(), player: red), x: 2, y: 7)
        board.putMan(man: Man(piece: Piece.queen(), player: red), x: 3, y: 7)
        board.putMan(man: Man(piece: Piece.king(), player: red), x: 4, y: 7)
        board.putMan(man: Man(piece: Piece.bishop(), player: red), x: 5, y: 7)
        board.putMan(man: Man(piece: Piece.knight(), player: red), x: 6, y: 7)
        board.putMan(man: Man(piece: Piece.rook(), player: red), x: 7, y: 7)

        board.putMan(man: Man(piece: Piece.star(), player: red), x: 0, y: 6)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 1, y: 6)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 2, y: 6)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 3, y: 6)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 4, y: 6)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 5, y: 6)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 6, y: 6)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 7, y: 6)

        board.putMan(man: Man(piece: Piece.rook(), player: blue), x: 0, y: 0)
        board.putMan(man: Man(piece: Piece.knight(), player: blue), x: 1, y: 0)
        board.putMan(man: Man(piece: Piece.bishop(), player: blue), x: 2, y: 0)
        board.putMan(man: Man(piece: Piece.queen(), player: blue), x: 3, y: 0)
        board.putMan(man: Man(piece: Piece.king(), player: blue), x: 4, y: 0)
        board.putMan(man: Man(piece: Piece.bishop(), player: blue), x: 5, y: 0)
        board.putMan(man: Man(piece: Piece.knight(), player: blue), x: 6, y: 0)
        board.putMan(man: Man(piece: Piece.rook(), player: blue), x: 7, y: 0)

        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 0, y: 1)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 1, y: 1)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 2, y: 1)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 3, y: 1)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 4, y: 1)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 5, y: 1)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 6, y: 1)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 7, y: 1)

        return Battle(board: board)
    }
    
    static func getTenByTen() -> Battle {
        let board = Board(squaresWide: 10, squaresHigh: 10)
        board.putMan(man: Man(piece: Piece.rook(), player: red), x: 0, y: 9)
        board.putMan(man: Man(piece: Piece.knight(), player: red), x: 1, y: 9)
        board.putMan(man: Man(piece: Piece.bishop(), player: red), x: 2, y: 9)
        board.putMan(man: Man(piece: Piece.wildebeest(), player: red), x: 3, y: 9)
        board.putMan(man: Man(piece: Piece.queen(), player: red), x: 4, y: 9)
        board.putMan(man: Man(piece: Piece.king(), player: red), x: 5, y: 9)
        board.putMan(man: Man(piece: Piece.wildebeest(), player: red), x: 6, y: 9)
        board.putMan(man: Man(piece: Piece.bishop(), player: red), x: 7, y: 9)
        board.putMan(man: Man(piece: Piece.knight(), player: red), x: 8, y: 9)
        board.putMan(man: Man(piece: Piece.rook(), player: red), x: 9, y: 9)

        board.putMan(man: Man(piece: Piece.star(), player: red), x: 0, y: 8)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 1, y: 8)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 2, y: 8)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 3, y: 8)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 4, y: 8)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 5, y: 8)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 6, y: 8)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 7, y: 8)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 8, y: 8)
        board.putMan(man: Man(piece: Piece.star(), player: red), x: 9, y: 8)

        board.putMan(man: Man(piece: Piece.rook(), player: blue), x: 0, y: 0)
        board.putMan(man: Man(piece: Piece.knight(), player: blue), x: 1, y: 0)
        board.putMan(man: Man(piece: Piece.bishop(), player: blue), x: 2, y: 0)
        board.putMan(man: Man(piece: Piece.wildebeest(), player: blue), x: 3, y: 0)
        board.putMan(man: Man(piece: Piece.queen(), player: blue), x: 4, y: 0)
        board.putMan(man: Man(piece: Piece.king(), player: blue), x: 5, y: 0)
        board.putMan(man: Man(piece: Piece.wildebeest(), player: blue), x: 6, y: 0)
        board.putMan(man: Man(piece: Piece.bishop(), player: blue), x: 7, y: 0)
        board.putMan(man: Man(piece: Piece.knight(), player: blue), x: 8, y: 0)
        board.putMan(man: Man(piece: Piece.rook(), player: blue), x: 9, y: 0)

        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 0, y: 1)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 1, y: 1)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 2, y: 1)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 3, y: 1)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 4, y: 1)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 5, y: 1)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 6, y: 1)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 7, y: 1)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 8, y: 1)
        board.putMan(man: Man(piece: Piece.star(), player: blue), x: 9, y: 1)

        return Battle(board: board)
    }
}

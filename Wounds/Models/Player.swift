////
//// Copyright (c) 2024 and Confidential to Eric Ford Consulting All rights reserved.
////
//
//import SwiftUI
//
///*
//    One color of pieces. Could be called a team, but that is reserved for players
//    who have different colored pieces, but are allies.
//    Direction is for pawn type pieces, and possibly other pieces that have a direction
//*/
//
//enum Direction
//{
//    case North
//    case South
//    case East
//    case West
//}
//
//struct Player : Equatable
//{
//    enum PlayerType {
//        case human, AI
//    }
//    
//    var direction: Direction
//    var name: String
//    var playerType: PlayerType
//    var darkSquareHiliteColor: Color
//    var lightSquareHiliteColor: Color
//    
//    init(direction: Direction, name: String, darkSquareHiliteColor: Color, lightSquareHiliteColor: Color, playerType: PlayerType = .human)
//    {
//        self.direction = direction
//        self.name = name
//        self.darkSquareHiliteColor = darkSquareHiliteColor
//        self.lightSquareHiliteColor = lightSquareHiliteColor
//        self.playerType = playerType
//    }
//    
//    // Equatable
//    static func ==(lhs: Player, rhs: Player) -> Bool {
//        return lhs.name == rhs.name
//    }
//}

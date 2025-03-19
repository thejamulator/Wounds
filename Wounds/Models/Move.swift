////
//// Copyright (c) 2024 and Confidential to Eric Ford Consulting All rights reserved.
////
//
//import Foundation
//
//class Move
//{
//    var fromX: Int
//    var fromY: Int
//    var toX: Int
//    var toY: Int
//    var score = 0
//    var attackingMan: Man
//    var defendingMan: Man?
//    var attackingAbility: Ability?
//    var defendingAbility: Ability?
//    var isStrongAttack = false
//
//    init(fromX: Int, fromY: Int, toX: Int, toY: Int, attackingMan: Man, attackingAbility: Ability)
//    {
//        self.fromX = fromX
//        self.fromY = fromY
//        self.toX = toX
//        self.toY = toY
//        self.attackingMan = attackingMan
//        self.attackingAbility = attackingAbility
//    }
//}
//
//extension Move: Equatable {
//    static func ==(lhs: Move, rhs: Move) -> Bool {
//        return lhs.score == rhs.score
//    }
//}
//
//extension Move: Comparable {
//    static func <(lhs: Move, rhs: Move) -> Bool {
//        return lhs.score < rhs.score
//    }
//}

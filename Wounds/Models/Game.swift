//
// Copyright (c) 2024 and Confidential to Eric Ford Consulting All rights reserved.
//

import Foundation

// A Game is a series of Battles, which are basically levels
class Game
{
    enum AIType: String, CaseIterable, Identifiable {
        case random, kamikaze, minimax, pruner
        var id: Self { self }
    }
    
    var evaluateMaterial: Bool = true
    var evaluateMobility: Bool = false
    var evaluateCenter: Bool = false
    var evaluateEnemy: Bool = false

//    struct EvaluationMethod: Identifiable {
//        let id = UUID()
//        let name: String
//    }
//    
//    let evaluationMethods = [
//        EvaluationMethod(name: "Material"),
//        EvaluationMethod(name: "Mobility"),
//        EvaluationMethod(name: "Center"),
//        EvaluationMethod(name: "Enemy")
//    ]
    
    var levels = [Level]()
    var currentLevel = 0
    var defaultAIType: AIType = .pruner
    var aiType: AIType
    
    init(levels: [Level]) {
        self.levels = levels
        self.aiType = defaultAIType
    }
    
    // returns false if there are no more levels
    func advanceLevel() -> Bool {
        currentLevel += 1
        return currentLevel < levels.count
    }
    
    func level() -> Level {
        return levels[currentLevel]
    }
    
    // ? not sure we need this
    func isMultiLevel() -> Bool {
        return levels.count > 1
    }
    
    func battleEnded(winner: Player, computerWon: () -> Void, humanWon: () -> Void, nextLevel: () -> Void) {
        if !advanceLevel() {
            currentLevel = 0
            if winner.playerType == .AI {
                computerWon()
            }
            else {
                humanWon()
            }
        }
        else {
            nextLevel()
        }
    }
}

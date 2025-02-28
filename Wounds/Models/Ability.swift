//
// Copyright (c) 2024 and Confidential to Eric Ford Consulting All rights reserved.
//

import Foundation

enum AbilityType: Int
{
    case Step = 10      // one square at a time
    case Slide = 100    // 'till you hit something
    case Jump = 20      // like a knight
    case Fat = 30       // a Step with extra defense
    case RotateLeft = 1 // if you're wounded, you can rotate left or right
    case RotateRight = 2
}

enum DefenseResult
{
    case AbilityRemoved
    case AbilityDemoted
    case PieceCaptured
}

class Ability : Equatable, Identifiable
{
    let id = UUID()
    var abilityType: AbilityType
    var xOffset: Int
    var yOffset: Int
    var demoted: Bool = false { // fat and slide AbilityTypes can be demoted to step AbilityType
        didSet {
            if demoted {
                value = AbilityType.Step.rawValue
            }
        }
    }
    var value: Int
    
    init(abilityType: AbilityType, xOffset: Int, yOffset: Int)
    {
        self.abilityType = abilityType
        self.xOffset = xOffset
        self.yOffset = yOffset
        value = abilityType.rawValue
    }
    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
    
    static func ==(compare1: Ability, compare2: Ability) -> Bool
    {
        return compare1.abilityType == compare2.abilityType && compare1.xOffset == compare2.xOffset && compare1.yOffset == compare2.yOffset
    }
    
    func getOpposite() -> Ability
    {
        return Ability(abilityType: self.abilityType, xOffset: -self.xOffset, yOffset: -self.yOffset)
    }

    func getDefenseResult(attackingAbility: Ability) -> DefenseResult
    {
        var result: DefenseResult
        
        var attackStrength: Int = 1
        var defenseStrength: Int = 1
        if (attackingAbility.abilityType == .Slide || attackingAbility.abilityType == .Fat) && !attackingAbility.demoted
        {
            attackStrength = 2
        }
        if (self.abilityType == .Slide || self.abilityType == .Fat) && !self.demoted
        {
            defenseStrength = 2
        }
        let attackDelta = attackStrength - defenseStrength
        switch attackDelta
        {
        case -1:
            self.demoted = true
            result = DefenseResult.AbilityDemoted
        case 0:
            result = DefenseResult.AbilityRemoved
        default: // case 1:
            result = DefenseResult.PieceCaptured
        }
        
        return result
    }
    
    func undoWound() // just to remind myself how this is supposed to work
    {
        self.demoted = false
    }
    
    func generateMoves(player: Player, board: Board, x: Int, y:Int) -> [Move]
    {
        // local function
        func isFriendlyPieceAtDestination(x: Int, y: Int, player: Player) -> Bool {
            if let man = board.squares[x][y].man {
                return man.player == player
            }
            else {
                return false
            }
        }
        
        // local function
        func isEnemyPieceAtDestination(x: Int, y: Int, player: Player) -> Bool {
            if let man = board.squares[x][y].man {
                return man.player != player
            }
            else {
                return false
            }
        }
        
        var moves = [Move]()
        if self.abilityType != .Slide || self.demoted
        {
            if (0..<board.squaresWide).contains(x + xOffset) && (0..<board.squaresHigh).contains(y + yOffset)
            {
                let targetSquare = board.squares[x + xOffset][y + yOffset]
                if targetSquare.man == nil {
                    moves.append(Move(fromX: x, fromY: y, toX: x + xOffset, toY: y + yOffset, attackingMan: board.squares[x][y].man!, attackingAbility: self))
//                    print("empty")
                }
                if let targetMan = targetSquare.man, targetMan.player != player
                {
                    moves.append(Move(fromX: x, fromY: y, toX: x + xOffset, toY: y + yOffset, attackingMan: board.squares[x][y].man!, attackingAbility: self))
//                    print("enemy")
                }
            }
        }
        else
        {
            var ranIntoAnEnemy = false
            var destinationX = x + xOffset
            var destinationY = y + yOffset
            while (0..<board.squaresWide).contains(destinationX) && (0..<board.squaresHigh).contains(destinationY) && !ranIntoAnEnemy && !isFriendlyPieceAtDestination(x: destinationX, y: destinationY, player: player)
                
            {
                let move = Move(fromX: x, fromY: y, toX: destinationX, toY: destinationY, attackingMan: board.squares[x][y].man!, attackingAbility: self)
                if isEnemyPieceAtDestination(x: destinationX, y: destinationY, player: player)
                {
                    ranIntoAnEnemy = true
                    move.isStrongAttack = true
                    move.defendingMan = board.squares[destinationX][destinationY].man!;
                }
                moves.append(move)
                destinationX += xOffset
                destinationY += yOffset
            }
        }

        return moves
    }
}

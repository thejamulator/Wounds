////
//// Copyright (c) 2024 and Confidential to Eric Ford Consulting All rights reserved.
////
//
//import Foundation
//
//class Man
//{
//    var tools: [Tool] = []
//    var abilities: [Ability] = []
//    var piece: Piece
//    var player: Player
//    var wounded = false
//    var woundedLastMove = false
//    var value: Int = 0
//
//    init(piece: Piece, player: Player, manToClone: Man? = nil)
//    {
//        self.piece = piece
//        self.player = player
//        if manToClone == nil {
//            // we need clones of the abilities so they are mutable without changing the template in the piece
//            self.abilities = copyAbilities(abilities: piece.abilities)
//        }
//        else {
//            self.abilities = copyAbilities(abilities: manToClone!.abilities)
//        }
//        value = calculateValue()
//    }
//    
//    func calculateValue() -> Int {
//        var value = 0
//        for ability in self.abilities {
//            var abilityValue = ability.abilityType.rawValue
//            if ability.demoted {
//                abilityValue = ability.abilityType.rawValue / 2
//            }
//            switch ability.yOffset {
//            case 1, 2:
//                if player.direction == .North {
//                    value += (abilityValue * 3) / 2
//                }
//                else if player.direction == .South {
//                    value += abilityValue / 2
//                }
//            case -1, -2:
//                if player.direction == .North {
//                    value += abilityValue / 2
//                }
//                else if player.direction == .South {
//                    value += (abilityValue * 3) / 2
//                }
//
//            default:
//                value += abilityValue
//            }
//        }
//        return value
//    }
//    
//    func copyAbilities(abilities: [Ability]) -> [Ability] {
//        return abilities.map({ability in Ability(abilityType: ability.abilityType, xOffset: ability.xOffset, yOffset: ability.yOffset)})
//    }
//    
//    func clone() -> Man {
//        return Man(piece: piece, player: player, manToClone: self)
//    }
//    
//    func directionalMatch(attackingAbility: Ability) -> Ability? {
//        self.abilities.first(where: {$0.xOffset == attackingAbility.xOffset && $0.yOffset == attackingAbility.yOffset})
//    }
//    
//    func defenseResult(move: Move) -> DefenseResult {
//        var result = DefenseResult.PieceCaptured
//        if let defense = directionalMatch(attackingAbility: move.attackingAbility!.getOpposite()) {
//            result = defense.getDefenseResult(attackingAbility: move.attackingAbility!)
//            if result == DefenseResult.AbilityRemoved {
//                self.abilities.remove(at: self.abilities.firstIndex(of: defense)!)
//                if stillAbleToMove() {
//                    move.defendingAbility = defense
//                    value = calculateValue()
//                }
//                else {
//                    result = DefenseResult.PieceCaptured
//                }
//            }
//            else if result == DefenseResult.AbilityDemoted {
//                // TODO: this can be optimized
//                value = calculateValue()
//            }
//        }
//        return result
//    }
//    
//    func stillAbleToMove() -> Bool {
//        if abilities.count > 2 {
//            return true
//        }
//        if abilities.count == 0 { // abilities.count == 0 probably can't happen because there will be rotation, but future pieces might only have 1 ability
//            return false
//        }
//        else {
//            for ability in abilities {
//                if !(ability.abilityType == .RotateLeft || ability.abilityType == .RotateRight) {
//                    return true
//                }
//            }
//            return false
//        }
//    }
//    
//    func generateMoves(board: Board, x: Int, y:Int) -> [Move]
//    {
//        var moves = [Move]()
//        for ability in self.abilities
//        {
//            moves += ability.generateMoves(player: player, board: board, x: x, y: y)
//        }
//        if wounded {
//            moves.append(Move(fromX: x, fromY: y, toX: x, toY: y, attackingMan: self, attackingAbility: Ability(abilityType: .RotateLeft, xOffset: 0, yOffset: 0)))
//            moves.append(Move(fromX: x, fromY: y, toX: x, toY: y, attackingMan: self, attackingAbility: Ability(abilityType: .RotateRight, xOffset: 0, yOffset: 0)))
//        }
//        return moves
//    }
//    
//    func dumpAbilities() {
//        for ability in self.abilities
//        {
//            print("ability: \(ability.abilityType) \(ability.value)")
//        }
//    }
//    
//    let north = (0, -1)
//    let northWest = (-1, -1)
//    let west = (-1, 0)
//    let southWest = (-1, 1)
//    let south = (0, 1)
//    let southEast = (1, 1)
//    let east = (1, 0)
//    let northEast = (1, -1)
//    let eastSouthEast = (2, 1)
//    let southSouthEast = (1, 2)
//    let southSouthWest = (-1, 2)
//    let westSouthWest = (-2, 1)
//    let westNorthWest = (-2, -1)
//    let northNorthWest = (-1, -2)
//    let northNorthEast = (1, -2)
//    let eastNorthEast = (2, -1)
//    
//    func rotateLeft() {
//        for ability in abilities {
//            switch ability.xOffset {
//            case -1:
//                switch ability.yOffset {
//                case -1:
//                    ability.xOffset = west.0
//                    ability.yOffset = west.1
//                case 0:
//                    ability.xOffset = southWest.0
//                    ability.yOffset = southWest.1
//                case 1:
//                    ability.xOffset = south.0
//                    ability.yOffset = south.1
//                case 2:
//                    ability.xOffset = southSouthEast.0
//                    ability.yOffset = southSouthEast.1
//                case -2:
//                    ability.xOffset = westNorthWest.0
//                    ability.yOffset = westNorthWest.1
//                default:
//                    break
//                }
//            case 0:
//                switch ability.yOffset {
//                case 1:
//                    ability.xOffset = southEast.0
//                    ability.yOffset = southEast.1
//                case -1:
//                    ability.xOffset = northWest.0
//                    ability.yOffset = northWest.1
//                default:
//                    break
//                }
//            case 1:
//                switch ability.yOffset {
//                case -1:
//                    ability.xOffset = north.0
//                    ability.yOffset = north.1
//                case 0:
//                    ability.xOffset = northEast.0
//                    ability.yOffset = northEast.1
//                case 1:
//                    ability.xOffset = east.0
//                    ability.yOffset = east.1
//                case 2:
//                    ability.xOffset = eastSouthEast.0
//                    ability.yOffset = eastSouthEast.1
//                case -2:
//                    ability.xOffset = northNorthWest.0
//                    ability.yOffset = northNorthWest.1
//                default:
//                    break
//                }
//            case 2:
//                switch ability.yOffset {
//                case -1:
//                    ability.xOffset = northNorthEast.0
//                    ability.yOffset = northNorthEast.1
//                case 1:
//                    ability.xOffset = eastNorthEast.0
//                    ability.yOffset = eastNorthEast.1
//                default:
//                    break
//                }
//            case -2:
//                switch ability.yOffset {
//                case -1:
//                    ability.xOffset = westSouthWest.0
//                    ability.yOffset = westSouthWest.1
//                case 1:
//                    ability.xOffset = southSouthWest.0
//                    ability.yOffset = southSouthWest.1
//                default:
//                    break
//                }
//            default:
//                break
//            }
//        }
//    }
//    
//    func rotateRight() {
//        for ability in abilities {
//            switch ability.xOffset {
//            case -1:
//                switch ability.yOffset {
//                case -1:
//                    ability.xOffset = north.0
//                    ability.yOffset = north.1
//                case 0:
//                    ability.xOffset = northWest.0
//                    ability.yOffset = northWest.1
//                case 1:
//                    ability.xOffset = west.0
//                    ability.yOffset = west.1
//                case 2:
//                    ability.xOffset = westSouthWest.0
//                    ability.yOffset = westSouthWest.1
//                case -2:
//                    ability.xOffset = northNorthEast.0
//                    ability.yOffset = northNorthEast.1
//                default:
//                    break
//                }
//            case 0:
//                switch ability.yOffset {
//                case 1:
//                    ability.xOffset = southWest.0
//                    ability.yOffset = southWest.1
//                case -1:
//                    ability.xOffset = northEast.0
//                    ability.yOffset = northEast.1
//                default:
//                    break
//                }
//            case 1:
//                switch ability.yOffset {
//                case -1:
//                    ability.xOffset = east.0
//                    ability.yOffset = east.1
//                case 0:
//                    ability.xOffset = southEast.0
//                    ability.yOffset = southEast.1
//                case 1:
//                    ability.xOffset = south.0
//                    ability.yOffset = south.1
//                case 2:
//                    ability.xOffset = southSouthWest.0
//                    ability.yOffset = southSouthWest.1
//                case -2:
//                    ability.xOffset = eastNorthEast.0
//                    ability.yOffset = eastNorthEast.1
//                default:
//                    break
//                }
//            case 2:
//                switch ability.yOffset {
//                case -1:
//                    ability.xOffset = eastSouthEast.0
//                    ability.yOffset = eastSouthEast.1
//                case 1:
//                    ability.xOffset = southSouthEast.0
//                    ability.yOffset = southSouthEast.1
//                default:
//                    break
//                }
//            case -2:
//                switch ability.yOffset {
//                case -1:
//                    ability.xOffset = northNorthWest.0
//                    ability.yOffset = northNorthWest.1
//                case 1:
//                    ability.xOffset = westNorthWest.0
//                    ability.yOffset = westNorthWest.1
//                default:
//                    break
//                }
//            default:
//                break
//            }
//        }
//    }
//}

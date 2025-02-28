//
// Copyright (c) 2024 and Confidential to Eric Ford Consulting All rights reserved.
//

import Foundation

/*
    A Piece is an abstract set of abilities used to create a Man.
    A Man is a Piece that belongs to a Player
*/

class Piece
{
    var name: String
    var abilities: [Ability] = []
    
    init(name: String)
    {
        self.name = name
    }
    
    static func bishop() -> Piece {
        let piece = Piece(name: "Bishop")
        piece.abilities.append(Ability(abilityType: AbilityType.Slide, xOffset: 1, yOffset: 1))   // south east
        piece.abilities.append(Ability(abilityType: AbilityType.Slide, xOffset: -1, yOffset: 1))  // south west
        piece.abilities.append(Ability(abilityType: AbilityType.Slide, xOffset: -1, yOffset: -1)) // north west
        piece.abilities.append(Ability(abilityType: AbilityType.Slide, xOffset: 1, yOffset: -1))  // north east
        return piece
    }
    
    static func king() -> Piece {
        let piece = Piece(name: "King")
        piece.abilities.append(Ability(abilityType: AbilityType.Fat, xOffset: 1, yOffset: 0))   // east
        piece.abilities.append(Ability(abilityType: AbilityType.Fat, xOffset: 1, yOffset: 1))   // south east
        piece.abilities.append(Ability(abilityType: AbilityType.Fat, xOffset: 0, yOffset: 1))   // south
        piece.abilities.append(Ability(abilityType: AbilityType.Fat, xOffset: -1, yOffset: 1))  // south west
        piece.abilities.append(Ability(abilityType: AbilityType.Fat, xOffset: -1, yOffset: 0))  // west
        piece.abilities.append(Ability(abilityType: AbilityType.Fat, xOffset: -1, yOffset: -1)) // north west
        piece.abilities.append(Ability(abilityType: AbilityType.Fat, xOffset: 0, yOffset: -1))  // north
        piece.abilities.append(Ability(abilityType: AbilityType.Fat, xOffset: 1, yOffset: -1))  // north east
        return piece
    }
    
    static func knight() -> Piece {
        let piece = Piece(name: "Knight")
        piece.abilities.append(Ability(abilityType: AbilityType.Jump, xOffset: 2, yOffset: 1))   // east south east
        piece.abilities.append(Ability(abilityType: AbilityType.Jump, xOffset: 1, yOffset: 2))   // south south east
        piece.abilities.append(Ability(abilityType: AbilityType.Jump, xOffset: -1, yOffset: 2))   // south south west
        piece.abilities.append(Ability(abilityType: AbilityType.Jump, xOffset: -2, yOffset: 1))  // west south west
        piece.abilities.append(Ability(abilityType: AbilityType.Jump, xOffset: -2, yOffset: -1))  // west north west
        piece.abilities.append(Ability(abilityType: AbilityType.Jump, xOffset: -1, yOffset: -2)) // north north west
        piece.abilities.append(Ability(abilityType: AbilityType.Jump, xOffset: 1, yOffset: -2))  // north north east
        piece.abilities.append(Ability(abilityType: AbilityType.Jump, xOffset: 2, yOffset: -1))  // east north east
        return piece
    }
    
    static func queen() -> Piece {
        let piece = Piece(name: "Queen")
        piece.abilities.append(Ability(abilityType: AbilityType.Slide, xOffset: 1, yOffset: 0))   // east
        piece.abilities.append(Ability(abilityType: AbilityType.Slide, xOffset: 1, yOffset: 1))   // south east
        piece.abilities.append(Ability(abilityType: AbilityType.Slide, xOffset: 0, yOffset: 1))   // south
        piece.abilities.append(Ability(abilityType: AbilityType.Slide, xOffset: -1, yOffset: 1))  // south west
        piece.abilities.append(Ability(abilityType: AbilityType.Slide, xOffset: -1, yOffset: 0))  // west
        piece.abilities.append(Ability(abilityType: AbilityType.Slide, xOffset: -1, yOffset: -1)) // north west
        piece.abilities.append(Ability(abilityType: AbilityType.Slide, xOffset: 0, yOffset: -1))  // north
        piece.abilities.append(Ability(abilityType: AbilityType.Slide, xOffset: 1, yOffset: -1))  // north east
        return piece
    }
    
    static func rook() -> Piece {
        let piece = Piece(name: "Rook")
        piece.abilities.append(Ability(abilityType: AbilityType.Slide, xOffset: 1, yOffset: 0))   // east
        piece.abilities.append(Ability(abilityType: AbilityType.Slide, xOffset: 0, yOffset: 1))   // south
        piece.abilities.append(Ability(abilityType: AbilityType.Slide, xOffset: -1, yOffset: 0))  // west
        piece.abilities.append(Ability(abilityType: AbilityType.Slide, xOffset: 0, yOffset: -1))  // north
        return piece
    }
    
    static func star() -> Piece {
        let piece = Piece(name: "Star")
        piece.abilities.append(Ability(abilityType: AbilityType.Step, xOffset: 1, yOffset: 0))   // east
        piece.abilities.append(Ability(abilityType: AbilityType.Step, xOffset: 1, yOffset: 1))   // south east
        piece.abilities.append(Ability(abilityType: AbilityType.Step, xOffset: 0, yOffset: 1))   // south
        piece.abilities.append(Ability(abilityType: AbilityType.Step, xOffset: -1, yOffset: 1))  // south west
        piece.abilities.append(Ability(abilityType: AbilityType.Step, xOffset: -1, yOffset: 0))  // west
        piece.abilities.append(Ability(abilityType: AbilityType.Step, xOffset: -1, yOffset: -1)) // north west
        piece.abilities.append(Ability(abilityType: AbilityType.Step, xOffset: 0, yOffset: -1))  // north
        piece.abilities.append(Ability(abilityType: AbilityType.Step, xOffset: 1, yOffset: -1))  // north east
        return piece
    }

    static func wildebeest() -> Piece {
        let piece = Piece(name: "Wildebeest")
        piece.abilities.append(Ability(abilityType: AbilityType.Jump, xOffset: 2, yOffset: 1))   // east south east
        piece.abilities.append(Ability(abilityType: AbilityType.Jump, xOffset: 3, yOffset: 1))

        piece.abilities.append(Ability(abilityType: AbilityType.Jump, xOffset: 1, yOffset: 2))   // south south east
        piece.abilities.append(Ability(abilityType: AbilityType.Jump, xOffset: 1, yOffset: 3))

        piece.abilities.append(Ability(abilityType: AbilityType.Jump, xOffset: -1, yOffset: 2))   // south south west
        piece.abilities.append(Ability(abilityType: AbilityType.Jump, xOffset: -1, yOffset: 3))

        piece.abilities.append(Ability(abilityType: AbilityType.Jump, xOffset: -2, yOffset: 1))  // west south west
        piece.abilities.append(Ability(abilityType: AbilityType.Jump, xOffset: -3, yOffset: 1))

        piece.abilities.append(Ability(abilityType: AbilityType.Jump, xOffset: -2, yOffset: -1))  // west north west
        piece.abilities.append(Ability(abilityType: AbilityType.Jump, xOffset: -3, yOffset: -1))

        piece.abilities.append(Ability(abilityType: AbilityType.Jump, xOffset: -1, yOffset: -2)) // north north west
        piece.abilities.append(Ability(abilityType: AbilityType.Jump, xOffset: -1, yOffset: -3))

        piece.abilities.append(Ability(abilityType: AbilityType.Jump, xOffset: 1, yOffset: -2))  // north north east
        piece.abilities.append(Ability(abilityType: AbilityType.Jump, xOffset: 1, yOffset: -3))

        piece.abilities.append(Ability(abilityType: AbilityType.Jump, xOffset: 2, yOffset: -1))  // east north east
        piece.abilities.append(Ability(abilityType: AbilityType.Jump, xOffset: 3, yOffset: -1))  

        return piece
    }
}

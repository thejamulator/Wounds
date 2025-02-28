//
// Copyright (c) 2024 and Confidential to Eric Ford Consulting All rights reserved.
//

import Foundation

enum Tool : Codable
{
    case NoTool, Explosive, ForceField, Shovel, Bulldozer, Projectile, Launcher, Candle, Lamp
}

class Square
{
    enum SquareType
    {
        case Normal, OffLimits, RedExit, BlueExit
    }
    var squareType: SquareType
    var man: Man?
    var tool: Tool?
    
    init(squareType: SquareType, man: Man? = nil)
    {
        self.squareType = squareType
        self.man = man
    }
}

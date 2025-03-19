//
// Copyright (c) 2024 and Confidential to Eric Ford Consulting All rights reserved.
//

import SwiftUI
import WoundsEngine

let lightGreen = Color(red: 0.8, green: 1.0, blue: 0.8)
let darkGreen = Color(red: 0.5, green: 0.7, blue: 0.5)
let reddishLightGreen = Color(red: 0.9, green: 0.7, blue: 0.7)
let reddishDarkGreen = Color(red: 0.5, green: 0.3, blue: 0.3)
let blueishLightGreen = Color(red: 0.5, green: 0.7, blue: 0.9)
let blueishDarkGreen = Color(red: 0.3, green: 0.3, blue: 0.7)
let red = Player(direction: Direction.North, name: "Red", darkSquareHiliteColor: reddishDarkGreen, lightSquareHiliteColor: reddishLightGreen)
let blue = Player(direction: Direction.South, name: "Blue", darkSquareHiliteColor: blueishDarkGreen, lightSquareHiliteColor: blueishLightGreen)
let blueAI = Player(direction: Direction.South, name: "Blue", darkSquareHiliteColor: blueishDarkGreen, lightSquareHiliteColor: blueishLightGreen, playerType: .AI)



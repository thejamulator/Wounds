//
// Copyright (c) 2024 and Confidential to Eric Ford Consulting All rights reserved.
//

import SwiftUI
import WoundsEngine

struct SquareView: View {
    let square: Square
    let file: Int
    let rank: Int

    func getBackgroundColor() -> Color {
        return (rank + file) % 2 == 0 ? lightGreen : darkGreen
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(getBackgroundColor())
        }
    }
}

#Preview {
    let square = Square(squareType: .Normal, man: Man(piece: Piece.rook(), player: Player(direction: Direction.North, name: "Red", darkSquareHiliteColor: reddishDarkGreen, lightSquareHiliteColor: reddishLightGreen)))
    VStack {
        SquareView(square: square, file: 0, rank: 0)
            .frame(width: 100, height: 100)
        Spacer()
    }
}

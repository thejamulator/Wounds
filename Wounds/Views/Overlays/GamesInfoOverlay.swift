//
// Copyright (c) 2025 and Confidential to Eric Ford Consulting All rights reserved.
//

import SwiftUI

extension BattleView {
    @ViewBuilder
    var gamesInfoOverlay: some View {
        if viewModel.showGamesInfo {
            ZStack {
                Color(.white)
                VStack {
                    HStack {
                        Spacer()
                        Button(
                            action: { viewModel.showGamesInfo = false },
                            label: { Image(systemName: "x.circle") }
                        )
                    }.padding()
                    ScrollView {
                        VStack {
                            Text("Game Info")
                                .font(.system(size: 36))
                                .fontWeight(.heavy)
                                .padding(.bottom, 10)
                            Text("To play a new type of game, select it from the list, then tap the New Game button.")
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 10)
                                .padding([.leading, .trailing], 20)
                            Text("Boot Camp")
                                .font(.system(size: 24))
                                .fontWeight(.heavy)
                                .padding(.bottom, 10)
                            Text("Simplified training exercises. This game has many levels. If you want a bit more challenge, go to the AI Type tab and select Pruner.")
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 10)
                                .padding([.leading, .trailing], 20)
                            Text("Annihilation")
                                .font(.system(size: 24))
                                .fontWeight(.heavy)
                                .padding(.bottom, 10)
                            Text("This is a single level game. Eliminate all enemy pieces to win. There are no special moves such as those in chess (check, checkmate, stalemate, castling, en passant)")
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 10)
                                .padding([.leading, .trailing], 20)
                            Text("Ten by Ten")
                                .font(.system(size: 24))
                                .fontWeight(.heavy)
                                .padding(.bottom, 10)
                            Text("This is a single level game. The AI will take significantly more time to find moves. Note the new piece that is similar to a knight, but can also make an elongated knight move. In chess variants, this piece is known as a wildebeest.")
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 10)
                                .padding([.leading, .trailing], 20)
                        }
                    }
                }
            }
        }
    }
}

//
// Copyright (c) 2025 and Confidential to Eric Ford Consulting All rights reserved.
//

import SwiftUI

extension BattleView {
    @ViewBuilder
    var evaluationHeuristicsInfoOverlay: some View {
        if viewModel.showEvaluationHeuristicsInfo {
            ZStack {
                Color(.white)
                VStack {
                    HStack {
                        Spacer()
                        Button(
                            action: { viewModel.showEvaluationHeuristicsInfo = false },
                            label: { Image(systemName: "x.circle") }
                        )
                    }.padding()
                    ScrollView {
                        VStack {
                            Text("Material")
                                .font(.system(size: 24))
                                .fontWeight(.heavy)
                                .padding(.bottom, 10)
                            Text("Calculates the value of each team's pieces, taking wounding into account. Friendly pieces have a positive value, and enemy pieces have a negative value.")
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 10)
                                .padding([.leading, .trailing], 20)
                            Text("Mobility")
                                .font(.system(size: 24))
                                .fontWeight(.heavy)
                                .padding(.bottom, 10)
                            Text("Calculates the number of moves each team can make. Friendly moves have a positive value, and enemy moves have a negative value.")
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 10)
                                .padding([.leading, .trailing], 20)
                            Text("Center")
                                .font(.system(size: 24))
                                .fontWeight(.heavy)
                                .padding(.bottom, 10)
                            Text("Values occupying squares closer to the center of the board more than those that are nerer to the edges.")
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 10)
                                .padding([.leading, .trailing], 20)
                            Text("Enemy")
                                .font(.system(size: 24))
                                .fontWeight(.heavy)
                                .padding(.bottom, 10)
                            Text("Calculates a 'center of gravity' for the enemy pieces; a square that is roughly the middle of the enemy army. This is very approximate. Values occupying squares closer to the center of gravity more than those that are farther away.")
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

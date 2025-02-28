//
// Copyright (c) 2025 and Confidential to Eric Ford Consulting All rights reserved.
//

import SwiftUI

extension BattleView {
    @ViewBuilder
    var aiTypeInfoOverlay: some View {
        if viewModel.showAITypeInfo {
            ZStack {
                Color(.white)
                VStack {
                    HStack {
                        Spacer()
                        Button(
                            action: { viewModel.showAITypeInfo = false },
                            label: { Image(systemName: "x.circle") }
                        )
                    }.padding()
                    ScrollView {
                        VStack {
                            Text("Random")
                                .font(.system(size: 24))
                                .fontWeight(.heavy)
                                .padding(.bottom, 10)
                            Text("AI moves are chosen at random from legal moves. This is the weakest AI. Search depth is zero.")
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 10)
                                .padding([.leading, .trailing], 20)
                            Text("Kamikaze")
                                .font(.system(size: 24))
                                .fontWeight(.heavy)
                                .padding(.bottom, 10)
                            Text("This AI picks the move that captures or wounds the enemy the most, with no thought to the moves after that, or to the consequences of those moves. Search depth is zero.")
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 10)
                                .padding([.leading, .trailing], 20)
                            Text("Minimax")
                                .font(.system(size: 24))
                                .fontWeight(.heavy)
                                .padding(.bottom, 10)
                            Text("Minimax is a common name for this brute force recursive tree search. I call it brute force because it doesn't take advantage of pruning the search tree. Because of this it is very slow. It's included here just so you can compare it to the next AI, Pruner.")
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 10)
                                .padding([.leading, .trailing], 20)
                            Text("Pruner")
                                .font(.system(size: 24))
                                .fontWeight(.heavy)
                                .padding(.bottom, 10)
                            Text("A short name for Alpha/Beta Pruning. It uses logic to stop searching a series of moves when it knows that series will not be agreed to by the opponent. For example if the opponent would lose a queen after making a certain move they will choose a better move, so what point is there in fleshing out all the different positions that could arise from this very bad move? A surprising amount of time was saved by implementing this. Minimax, which does flesh out all of the useless branches of the search tree that will never happen, evaluated over 32,000 positions on its first move which took more than 15 seconds. Pruner only evaluated 2,000 positions in less than 2 seconds.")
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 10)
                                .padding([.leading, .trailing], 20)
                            Text("COMING SOON: Monte Carlo Tree Search")
                                .font(.system(size: 24))
                                .fontWeight(.heavy)
                                .padding(.bottom, 10)
                            Text("Even though chess engines have been referred to as AI for decades, none of the above algorithms really count as AI in my opinion. Monte Carlo Tree Search does however. It fleshes out the tree of possible moves gradually, based on a time limit for each turn. It balances random exploration with in depth analysis of the best looking moves. It uses somewhat fuzzy logic such as upper confidence bounds. It is apparently quite memory and CPU intensive, so it will be quite an experiment to see how it performs on iOS and MacOS.")
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

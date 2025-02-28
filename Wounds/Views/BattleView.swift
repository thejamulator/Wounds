//
// Copyright (c) 2024 and Confidential to Eric Ford Consulting All rights reserved.
//

import SwiftUI

struct BattleView: View {
    @ObservedObject var viewModel = ViewModel()
    
    class ViewModel: ObservableObject {
        @Published var appState: AppState
        @Published var battle: Battle
        var moves = [Move]()
        @Published var hiliteSquares = [[Player?]]()
        @Published var timeElapsed = ""
        @Published var leavesEvaluated = ""
        @Published var branchesPruned = ""
        @Published var battleOver: Player?
        var moveStart: (Int, Int)?
        var positionsEvaluated = 0
        var prunes = 0
        @Published var gameType: GameType = .bootCamp {
            didSet {
                print("gameType \(gameType)")
                appState.setGameFromGameType(gameType: gameType)
            }
        }
        var searchDepth = 2
//        @Published var evaluationSelections = Set<UUID>()
        @Published var rotatablePieceSelected = false
        @Published var redraw = false
        var gravX = 0 // dummy values
        var gravY = 7
        
        @Published var showHowToPlay: Bool = false
        @Published var showGamesInfo: Bool = false
        @Published var showAITypeInfo: Bool = false
        @Published var showEvaluationHeuristicsInfo: Bool = false

        @Published var material = true {
            didSet {
                appState.game.evaluateMaterial = material
            }
        }
        
        @Published var mobility = true {
            didSet {
                appState.game.evaluateMobility = mobility
            }
        }
        
        @Published var center = true {
            didSet {
                appState.game.evaluateCenter = center
            }
        }
        
        @Published var enemy = true {
            didSet {
                appState.game.evaluateEnemy = enemy
            }
        }
        
        init(appState: AppState = AppState.shared) {
            self.appState = appState
            self.battle = appState.game.level().battle
            hiliteSquares = Array(repeating: Array(repeating: nil, count: battle.board.squaresHigh), count: battle.board.squaresWide)
//            evaluationSelections.insert(appState.game.evaluationMethods[0].id)
            if battle.board.showHilightsAtStart {
                moveStart = (battle.board.fromX!, battle.board.fromY!)
                hiliteSquares[battle.board.toX!][battle.board.toY!] = battle.board.player
            }
        }
        
//        func evaluationEnabled(name: String) -> Bool {
//            var result = false
//            if let method = appState.game.evaluationMethods.first(where: { $0.name == name }) {
//                if evaluationSelections.contains(where: { $0 == method.id }) {
//                    result = true
//                }
//            }
//            return result
//        }
        
        func newGame(battle: Battle) {
            moveStart = nil
            battleOver = nil
            self.battle = battle
            hiliteSquares = Array(repeating: Array(repeating: nil, count: battle.board.squaresHigh), count: battle.board.squaresWide)
            DispatchQueue.main.async {
                self.positionsEvaluated = 0
                self.leavesEvaluated = "\(self.positionsEvaluated) positions evaluated"
                self.timeElapsed = ""
            }
        }
        
        func eraseHilitedSquares() {
            for file in 0..<battle.board.squaresWide {
                for rank in 0..<battle.board.squaresHigh {
                    hiliteSquares[file][rank] = nil
                }
            }
        }
        
        func generateMoves(man: Man, file: Int, rank: Int) {
            moves = man.generateMoves(board: battle.board, x: file, y: rank)
            for move in moves {
                if !(move.attackingAbility?.abilityType == .RotateLeft || move.attackingAbility?.abilityType == .RotateRight) {
                    hiliteSquares[move.toX][move.toY] = man.player
                }
            }
        }
        
        func getBackgroundColor(file: Int, rank: Int) -> Color {
            if let start = moveStart, file == start.0 && rank == start.1 {
                return .white
            }
            let isDark = (file + rank) % 2 == 0
            if hiliteSquares[file][rank] != nil {
                return getHiliteColor(player: hiliteSquares[file][rank]!, isDark: isDark)
            }
            else {
                return isDark ? darkGreen : lightGreen
            }
        }
        
        func getHiliteColor(player: Player, isDark: Bool) -> Color {
            if player == red {
                return isDark ? reddishDarkGreen : reddishLightGreen
            }
            else {
                return isDark ? blueishDarkGreen : blueishLightGreen
            }
        }
        
        @MainActor
        func battleEnded(winner: Player) {
            appState.game.battleEnded(
                winner: winner,
                computerWon: { battleOver = winner },
                humanWon: { battleOver = winner },
                nextLevel: { self.newGame(battle: appState.game.level().battle) }
            )
        }
    
        func firstTapOfAMove(file: Int, rank: Int) {
            if let man = battle.board.squares[file][rank].man {
                if man.player == battle.whoseTurn {
                    generateMoves(man: man, file: file, rank: rank)
                    moveStart = (file, rank)
                    rotatablePieceSelected = man.wounded
                }
            }
        }
        
        func makeAIMove() async {
            let startTime = Date()
            DispatchQueue.main.async {
                self.positionsEvaluated = 0
            }
            if let move = await getBestMove(players: battle.players, whoseTurn: battle.whoseTurn, position: battle.board) {
                battle.board.makeMove(move: move, depth: searchDepth)
                DispatchQueue.main.async {
                    self.eraseHilitedSquares()
                    self.hiliteSquares[move.fromX][move.fromY] = self.battle.whoseTurn
                    self.hiliteSquares[move.toX][move.toY] = self.battle.whoseTurn
                    self.battle.whoseTurn = self.battle.nextPlayer()
                }
                if let winner = battle.thereIsAWinner() {
                    await battleEnded(winner: winner)
                }
            }
            else {
                await battleEnded(winner: self.battle.nextPlayer()) // TODO: not right for more than 2 players
            }
            let endTime = Date()
            DispatchQueue.main.async {
                self.timeElapsed = String(format: "%.3f", endTime.timeIntervalSince(startTime)) + " seconds elapsed"
            }        }
        
        func squareTapped(file: Int, rank: Int) {
            if battle.whoseTurn != blueAI {
                eraseHilitedSquares() // ??? make sure changing start squares only hilites new destinations
                if moveStart == nil {
                    firstTapOfAMove(file: file, rank: rank)
                }
                else {
                    let matches = moves.filter({ $0.toX == file && $0.toY == rank })
                    if matches.count > 0 {
                        let move = matches[0]
                        battle.board.makeMove(move: move, depth: searchDepth)
                        rotatablePieceSelected = false
                        battle.whoseTurn = battle.nextPlayer()
                        if battle.whoseTurn.playerType == .AI {
                            Task {
                                await makeAIMove()
                            }
                        }
                        else {
                            eraseHilitedSquares()
                        }
                    }
                    else {
                        // tapped a square we can't move to, so we're starting to move a new piece
                        firstTapOfAMove(file: file, rank: rank)
                    }
                    moveStart = nil
                    moves.removeAll()
                }
            }
        }
        
        func generateMoves(board: Board, whoseTurn: Player) -> [Move] {
            return board.generateMoves(player: whoseTurn)
        }
        
        func evaluate(board: Board, whoseTurn: Player) -> Int {
            var score = 0
            if appState.game.evaluateEnemy {
                (gravX, gravY) = board.gravitationalCenter(player: battle.nextPlayer())
            }
            for rank in 0..<board.squaresHigh {
                for file in 0..<board.squaresWide {
                    if let man = board.squares[file][rank].man {
                        if man.player == whoseTurn {
                            if appState.game.evaluateMaterial {
                                score += man.value
                            }
                            if appState.game.evaluateMobility {
                                score += man.generateMoves(board: board, x: file, y: rank).count
                            }
                            if appState.game.evaluateCenter {
                                score += board.centrality(file: file, rank: rank)
                            }
                            if appState.game.evaluateEnemy {
                                score += 8 - board.gravitationalDistance(gravX: gravX, gravY: gravY, file: file, rank: rank)
                            }
                        }
                        else {
                            if appState.game.evaluateMaterial {
                                score -= man.value
                            }
                            if appState.game.evaluateMobility {
                                score -= man.generateMoves(board: board, x: file, y: rank).count
                            }
                        }
                    }
                }
            }
            positionsEvaluated += 1
            return score
        }
        
        func getBestMove(players: [Player], whoseTurn: Player, position: Board) async -> Move? {
            let moveTree = MoveTree(players: players, ai: whoseTurn, position: position, evaluator: evaluate, moveGenerator: generateMoves)
            var best: Move?
            switch appState.game.aiType {
            case .random:
                best = getRandomMove(moves: generateMoves(board: position, whoseTurn: whoseTurn))
            case .kamikaze:
                let bestMoveNode = moveTree.miniMax(position: position, players: players, whoseTurn: players[1], depth: 0)
                best = bestMoveNode.move
            case .minimax:
                best = moveTree.miniMaxWORKS(position: position, players: players, whoseTurn: players[1], depth: searchDepth)
            case .pruner:
                let (_, bestMove) = moveTree.negamax(position: position, players: players, whoseTurn: players[1], depth: searchDepth)
                best = bestMove
            }
            DispatchQueue.main.async {
                self.leavesEvaluated = "\(self.positionsEvaluated) positions evaluated"
            }
            return best
        }
        
        func getRandomMove(moves: [Move]) -> Move? {
            var move: Move? = nil
            let moves = battle.board.generateMoves(player: battle.whoseTurn)
            if moves.count > 0 {
                move = moves[Int.random(in: 0..<moves.count)]
            }
            return move
        }
        
        func getSquare(file: Int, rank: Int) -> Square {
            let square = self.battle.board.squares[file][rank]
            return square
        }
        
        func getMan(file: Int, rank: Int) -> Man? {
            let man = getSquare(file: file, rank: rank).man
            return man
        }
        
        func rotateLeft() {
            if let indices = moveStart {
                if let man = getSquare(file: indices.0, rank: indices.1).man {
                    man.rotateLeft()
                    eraseHilitedSquares()
                    moveStart = nil
                    moves.removeAll()
                    rotatablePieceSelected = false
                    battle.whoseTurn = battle.nextPlayer()
                    Task {
                        await makeAIMove()
                    }
                }
            }
        }
        func rotateRight() {
            if let indices = moveStart {
                if let man = getSquare(file: indices.0, rank: indices.1).man {
                    man.rotateRight()
                    eraseHilitedSquares()
                    moveStart = nil
                    moves.removeAll()
                    rotatablePieceSelected = false
                    battle.whoseTurn = battle.nextPlayer()
                    Task {
                        await makeAIMove()
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            Button(
                action: {viewModel.showHowToPlay = true},
                label: {
                    HStack {
                        Text("How to Play")
                        Image(systemName: "questionmark.circle")
                    }
                }
            )
            RatioSplitVStack(
                topWidthRatio: 0.5,
                topContent: {
                    boardView()
                        .padding()
                },
                bottomContent: { bottomView() }
            )
        }
        .padding()
        .overlay(howToPlayOverlay)
        .overlay(gamesInfoOverlay)
        .overlay(aiTypeInfoOverlay)
        .overlay(evaluationHeuristicsInfoOverlay)
    }
    
    @ViewBuilder
    func bottomView() -> some View {
        VStack {
            if viewModel.battleOver != nil {
                HStack {
                    Spacer()
                    Text("\(viewModel.battleOver!.name) Won!!!")
                    Spacer()
                }
            }
            middleButtonsView()
            TabView {
                gamePickerView()
                    .tabItem {
                        Label("Games", systemImage: "checkerboard.rectangle")
                    }
                    .padding(.top, -15)
                    .frame(height: 275)
                aiPickerView()
                    .tabItem {
                        Label("AI Types", systemImage: "brain")
                    }
                    .padding(.top, -15)
                    .frame(height: 275)
                evaluationsView()
                    .tabItem {
                        Label("Evaluation Heuristics", systemImage: "brain.head.profile")
                    }
            }
        }
    }

    @ViewBuilder
    func gamePickerView() -> some View {
        VStack {
            Button(
                action: {viewModel.showGamesInfo = true},
                label: {
                    HStack {
                        Text("Games Info")
                        Image(systemName: "questionmark.circle")
                    }
                }
            )
            List {
                Picker("", selection: $viewModel.appState.gameType) {
                    ForEach(GameType.allCases, id: \.self) {
                        Text($0.rawValue.capitalized)
                    }
                }.pickerStyle(.inline)
            }
        }
#if os(iOS)
        .scaleEffect(0.8)
#endif
    }
    
    @ViewBuilder
    func aiPickerView() -> some View {
        VStack {
            Button(
                action: {viewModel.showAITypeInfo = true},
                label: {
                    HStack {
                        Text("AI Type")
                        Image(systemName: "questionmark.circle")
                    }
                }
            )
            List {
                Picker("", selection: $viewModel.appState.game.aiType) {
                    ForEach(Game.AIType.allCases, id: \.self) {
                        Text($0.rawValue.capitalized)
                    }
                }.pickerStyle(.inline)
            }
            if viewModel.appState.game.aiType != .random && viewModel.appState.game.aiType != .kamikaze {
                searchDepthView()
            }
            else {
                Text("Search depth = 0")
            }
        }
#if os(iOS)
        .scaleEffect(0.8)
#endif
    }
    
    @ViewBuilder
    func middleButtonsView() -> some View {
        HStack {
            Button(action: { viewModel.rotateLeft() }, label: { Text("Rotate Left") })
                .disabled(!viewModel.rotatablePieceSelected)
                .buttonStyle(BorderedButtonStyle())
            Button(action: { viewModel.newGame(battle: viewModel.appState.game.level().battle) }, label: { Text("New Game") })
                .buttonStyle(BorderedButtonStyle())
            Button(action: { viewModel.rotateRight() }, label: { Text("Rotate Right") })
                .disabled(!viewModel.rotatablePieceSelected)
                .buttonStyle(BorderedButtonStyle())
        }
    }

    @ViewBuilder
    func searchDepthView() -> some View {
        VStack {
            Text("Search Depth")
            if viewModel.appState.game.aiType == .minimax || viewModel.appState.game.aiType == .pruner {
                Picker("", selection: $viewModel.searchDepth) {
                    ForEach(0..<5, id: \.self) {
                        Text("\($0)")
                    }
                }
                .pickerStyle(.segmented)
                .padding(.bottom, -50)
            }
            else {
                Text("Random and Kamikaze are always depth = 0")
            }
        }.scaleEffect(0.8)
    }
    
    @ViewBuilder
    func evaluationsView() -> some View {
        VStack {
            Button(
                action: {viewModel.showEvaluationHeuristicsInfo = true},
                label: {
                    HStack {
                        Text("Evaluation Heuristics")
                        Image(systemName: "questionmark.circle")
                    }
                }
            )
            if viewModel.appState.game.aiType != .random && viewModel.appState.game.aiType != .kamikaze {
                VStack {
                    Toggle("Material", isOn: $viewModel.material)
                        .padding(.bottom, 5)
                    Toggle("Mobility", isOn: $viewModel.mobility)
                        .padding(.bottom, 5)
                    Toggle("Center", isOn: $viewModel.center)
                        .padding(.bottom, 5)
                    Toggle("Enemy", isOn: $viewModel.enemy)
                }
                .padding()
            }
            else {
                Spacer()
                if viewModel.appState.game.aiType == .random {
                    Text("Moves are chosen randomly.")
                }
                else {
                    Text("Moves are chosen by the most valuable capture or wound regardless of any consequences.")
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                        .padding([.leading, .trailing], 20)
                }
                Spacer()
            }
            Text(viewModel.timeElapsed)
            Text(viewModel.leavesEvaluated)
        }
#if os(iOS)
        .scaleEffect(0.8)
#endif
    }
    
//    @ViewBuilder
//    func gameControlsView() -> some View {
//        VStack {
//            #if os(iOS)
//                iOSHorizontalListsView()
//            #else
//            macOSVerticalListsView()
//            #endif
//            if viewModel.appState.game.aiType == .minimax || viewModel.appState.game.aiType == .pruner {
//                Text("Search Depth")
//                Picker("", selection: $viewModel.searchDepth) {
//                    ForEach(0..<5, id: \.self) {
//                        Text("\($0)")
//                    }
//                }.pickerStyle(.segmented)
//            }
//            Text(viewModel.timeElapsed)
//            Text(viewModel.leavesEvaluated)
//            Spacer()
//        }
//    }
    
//    @ViewBuilder
//    func iOSHorizontalListsView() -> some View {
//        RatioSplitHStack(
//            leftWidthRatio: 0.5,
//            leftContent: {
//                ZStack {
//                    List {
//                        Picker("", selection: $viewModel.aIType) {
//                            ForEach(ViewModel.AIType.allCases, id: \.self) {
//                                Text($0.rawValue.capitalized)
//                            }
//                        }.pickerStyle(.inline)
//                            .padding(.top, -2)
//                    }
//                    VStack {
//                        HStack {
//                            Text("AI Type")
//                                .padding(5)
//                        }.background(.clear)
//                        Spacer()
//                    }
//                }
//            },
//            rightContent: {
//                iOSEvaluationOrInfoView()
//            }
//        )
//    }
    
//    @ViewBuilder
//    func iOSEvaluationOrInfoView() -> some View {
//        switch viewModel.aIType {
//        case .random:
//            Text("Random has no evaluators")
//        case .kamikaze:
//            Text("Kamikaze has no evaluators")
//        case .minimax:
//            iOSEvaluationChooserView()
//        case .pruner:
//            iOSEvaluationChooserView()
//        }
//    }
    
//    @ViewBuilder
//    func iOSEvaluationChooserView() -> some View {
//        ZStack {
//            VStack {
//                Text("Evaluation Types")
//                    .padding(.top, 5)
//                    .padding(.bottom, 7)
//                Toggle("Material", isOn: $viewModel.material)
//                    .padding(.bottom, 5)
//                Toggle("Mobility", isOn: $viewModel.mobility)
//                    .padding(.bottom, 5)
//                Toggle("Center", isOn: $viewModel.center)
//                    .padding(.bottom, 5)
//                Toggle("Enemy", isOn: $viewModel.enemy)
//                Rectangle()
//                    .frame(maxWidth: .infinity)
//                    .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
//            }
//            .padding([.leading, .trailing], 15)
//            .background(Color(red: 0.95, green: 0.95, blue: 0.95))
//        }
//    }
    
//    @ViewBuilder
//    func macOSVerticalListsView() -> some View {
//        RatioSplitVStack(
//            topWidthRatio: 0.5,
//            topContent: {
//                VStack {
//                    HStack {
//                        Text("AI Type")
//                            .padding(5)
//                    }
//                    List {
//                        Picker("", selection: $viewModel.aIType) {
//                            ForEach(ViewModel.AIType.allCases, id: \.self) {
//                                Text($0.rawValue.capitalized)
//                            }
//                        }.pickerStyle(.inline)
//                            .padding(.top, 13)
//                    }
//                }
//            },
//            bottomContent: {
//                macOSEvaluationOrInfoView()
//            }
//        )
//    }

//    @ViewBuilder
//    func macOSEvaluationOrInfoView() -> some View {
//        switch viewModel.aIType {
//        case .random:
//            Text("Random has no evaluators")
//        case .kamikaze:
//            Text("Kamikaze has no evaluators")
//        case .minimax:
//            macOSEvaluationChooserView()
//        case .pruner:
//            macOSEvaluationChooserView()
//        }
//    }
    
//    @ViewBuilder
//    func macOSEvaluationChooserView() -> some View {
//        VStack {
//            Text("Evaluation Types")
//                .padding(.top, 5)
//                .padding(.bottom, 7)
//            Toggle("Material", isOn: $viewModel.material)
//                .padding(.bottom, 5)
//            Toggle("Mobility", isOn: $viewModel.mobility)
//                .padding(.bottom, 5)
//            Toggle("Center", isOn: $viewModel.center)
//                .padding(.bottom, 5)
//            Toggle("Enemy", isOn: $viewModel.enemy)
//            Rectangle()
//                .frame(maxWidth: .infinity)
//                .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
//        }
//        .padding([.leading, .trailing], 15)
//        .background(Color(red: 0.95, green: 0.95, blue: 0.95))
//    }
        
    @ViewBuilder
    func boardView() -> some View {
        GeometryReader { geometry in
            Grid(horizontalSpacing: 0.0, verticalSpacing: 0.0) {
                ForEach(0..<viewModel.battle.board.squaresHigh, id: \.self) { rank in
                    GridRow {
                        ForEach(0..<viewModel.battle.board.squaresWide, id: \.self) { file in
                            if let man = viewModel.getMan(file: file, rank: rank) {
                                Rectangle()
                                    .fill(viewModel.getBackgroundColor(file: file, rank: rank))
                                    .overlay(
                                        GeometryReader { geometry in
                                            let manViewModel = ManView.ViewModel(size: geometry.size, man: man)
                                            ManView(
                                                viewModel: manViewModel
                                            )
                                            .background(viewModel.redraw ? .clear : .clear)
                                        }
                                    )
                                    .onTapGesture {
                                        viewModel.squareTapped(file: file, rank: rank)
                                    }
                            }
                            else {
                                Rectangle()
                                    .fill(viewModel.getBackgroundColor(file: file, rank: rank))
                                    .onTapGesture {
                                        viewModel.squareTapped(file: file, rank: rank)
                                    }
                            }
//                            .onTapGesture {
//                                viewModel.squareTapped(file: file, rank: rank)
//                            }
//                            ZStack {
//                                Rectangle()
//                                    .fill(viewModel.getBackgroundColor(file: file, rank: rank))
//                                if let man = viewModel.getMan(file: file, rank: rank) {
//                                    GeometryReader { geometry in
//                                        let viewModel = ManView.ViewModel(size: geometry.size, man: man)
//                                        ManView(
//                                            viewModel: viewModel
//                                        )
//                                    }
//                                }
//                            }.onTapGesture {
//                                viewModel.squareTapped(file: file, rank: rank)
//                            }
                        }
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.width)
        }
    }
}

#Preview {
    BattleView(viewModel: BattleView.ViewModel())
        .frame(width: 300, height: 300)
}

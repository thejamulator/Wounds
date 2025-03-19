//
// Copyright (c) 2025 and Confidential to Eric Ford Consulting All rights reserved.
//

import SwiftUI
import WoundsEngine

/*
 A "doubleton", a singleton without a private init. That way we can instantiate separate instances for unit testing
 view models that use it will have it as an input parameter to init, defaulting to shared
 */

enum GameType: String, CaseIterable, Identifiable {
    case bootCamp, annihilation, tenByTen
    var id: Self { self }
}

class AppState: ObservableObject {
    static var shared = AppState(gameType: .bootCamp)
    
    @Published var gameType: GameType {
        didSet {
            setGameFromGameType(gameType: gameType)
        }
    }
    var game: Game

    init(gameType: GameType) {
        self.gameType = gameType
        switch gameType {
        case .bootCamp:
            self.game = BootCamp()
        case .annihilation:
            self.game = Annihilation()
        case .tenByTen:
            self.game = TenByTen()
        }
    }
    
    func setGameFromGameType(gameType: GameType) {
        switch gameType {
        case .bootCamp:
            self.game = BootCamp()
        case .annihilation:
            self.game = Annihilation()
        case .tenByTen:
            self.game = TenByTen()
        }
    }
}

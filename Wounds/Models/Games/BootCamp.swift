//
// Copyright (c) 2025 and Confidential to Eric Ford Consulting All rights reserved.
//

class BootCamp: Game {
    init() {
        super.init(
            levels: [
                Level(battle: Battle.getBootCampLevel6(), sequenceNumber: 1),
                Level(battle: Battle.getBootCampLevel2(), sequenceNumber: 2),
                Level(battle: Battle.getBootCampLevel3(), sequenceNumber: 3),
                Level(battle: Battle.getBootCampLevel4(), sequenceNumber: 4),
                Level(battle: Battle.getBootCampLevel5(), sequenceNumber: 5),
                Level(battle: Battle.getBootCampLevel6(), sequenceNumber: 6)
            ]
        )
        aiType = .pruner
    }
}

//
//  table.swift
//  
//
//  Created by Jonas Everaert on 04/06/2023.
//

import GateEngine

extension ObjectSpawner {
    fileprivate static let tableSize = Size3(0.5)
    
    enum TableType {
        case rectangle
    }
    
    @discardableResult
    static func spawnTable(
        _ game: Game,
        position: Position3 = Position3(0, 0, 0),
        type: TableType = .rectangle
    )  -> Entity {
        switch type {
        case .rectangle:
            return Self.spawnTableRectangle(game, position)
        }
    }
    
    fileprivate static func spawnTableRectangle(_ game: Game, _ position: Position3) -> Entity {
        return Entity()
    }
}

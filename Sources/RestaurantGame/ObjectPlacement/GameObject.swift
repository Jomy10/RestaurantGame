//
//  GameObjects.swift
//  
//
//  Created by Jonas Everaert on 05/06/2023.
//

import GateEngine

enum GameObject {
    case uninitialized
    case booths4Persons(
        booth1: Entity,
        table: Entity,
        Booth2: Entity
    )
}

extension GameObject {
    func move(to position: Position3) {
        switch self {
        case .uninitialized: return
        case .booths4Persons(booth1: let booth1, table: let table, Booth2: let booth2):
            b4p_move(to: position, booth1: booth1, table: table, booth2: booth2)
        }
    }
    
    func rotate(times: Int) {
        switch self {
        case .uninitialized: return
        case .booths4Persons(booth1: let booth1, table: let table, Booth2: let booth2):
            b4p_rotate(times: times, booth1: booth1, table: table, booth2: booth2)
        }
    }
    
    var gridSize: GridSize {
        switch self {
        case .uninitialized: return GridSize.zero
        case .booths4Persons(booth1: let b, table: let t, Booth2: _): return b4p_size(booth1: b, table: t)
        }
    }
}

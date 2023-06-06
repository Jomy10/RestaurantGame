//
//  GameObjects.swift
//  
//
//  Created by Jonas Everaert on 05/06/2023.
//

import GateEngine
import Foundation

struct GameObject {
    var id: UUID = UUID()
    var objects: GameObjects
    
    init(_ objects: GameObjects) {
        self.objects = objects
    }
    
    enum GameObjects {
        case uninitialized
        case booths4Persons(
            booth1: Entity,
            table: Entity,
            Booth2: Entity
        )
    }
}

extension GameObject: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension GameObject {
    func move(to position: Position3) {
        switch self.objects {
        case .uninitialized: break
        case .booths4Persons(booth1: let booth1, table: let table, Booth2: let booth2):
            b4p_move(to: position, booth1: booth1, table: table, booth2: booth2)
        }
    }
    
    func rotate(times: Int) {
        switch self.objects {
        case .uninitialized: break
        case .booths4Persons(booth1: let booth1, table: let table, Booth2: let booth2):
            b4p_rotate(times: times, booth1: booth1, table: table, booth2: booth2)
        }
    }
    
    var gridSize: GridSize {
        switch self.objects {
        case .uninitialized: return GridSize.zero
        case .booths4Persons(booth1: let b, table: let t, Booth2: _): return b4p_size(booth1: b, table: t)
        }
    }
    
    /// returns the upper left corner of the object in the grid
    func minGridPos(pos: GridPos, size: GridSize) -> GridPos {
        switch self.objects {
        case .uninitialized: return GridPos.zero
        case .booths4Persons(booth1: _, table: _, Booth2: _): return b4p_minPos(gridPos: pos, size: size)
        }
    }
}

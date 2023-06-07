//
//  Booths4Persons.swift
//  
//
//  Created by Jonas Everaert on 05/06/2023.
//

import GateEngine

@_transparent func b4p_move(to position: Position3, booth1: Entity, table: Entity, booth2: Entity) {
    guard let tableTransf = table.component(ofType: Transform3Component.self) else { return }
    let diff = position - tableTransf.position
    tableTransf.position = position
    transformObjects(booth1) { t in
        t.position += diff
    }
    transformObjects(booth2) { t in
        t.position += diff
    }
}

@_transparent func b4p_rotate(booth1: Entity, table: Entity, booth2: Entity) {
    let tableTransf = table.component(ofType: Transform3Component.self)!
    let booth1Transf = booth1.component(as: Transform3Component.self)!
    let booth1newPos: Position3
    let booth2newPos: Position3
    let posOffset: Position3
    switch (tableTransf.position - booth1Transf.position) {
    case Position3(-1, 0, 0):
        // booth 1 is left of table
        posOffset = Position3(0, 0, -1)
    case Position3(1, 0, 0):
        // booth 1 is right of table
        posOffset = Position3(0, 0, 1)
    case Position3(0, 0, -1):
        // booth 1 is above of table
        posOffset = Position3(1, 0, 0)
    case Position3(0, 0, 1):
        // booth 1 is below of table
        posOffset = Position3(-1, 0, 0)
    default: unreachable("This may happen due to a bug in code, but shouldn't be possible")
    }
    booth1newPos = tableTransf.position + posOffset
    booth2newPos = tableTransf.position - posOffset
   
    let rotation = Quaternion(direction: .right)
    
    transformObjects(booth1) { transform in
        transform.rotation *= rotation
        transform.position = booth1newPos
    }
    
    transformObjects(booth2) { transform in
        transform.rotation *= rotation
        transform.position = booth2newPos
    }
    
    tableTransf.rotation *= rotation
}

@_transparent func b4p_size(booth1: Entity, table: Entity) -> GridSize {
    let bp = booth1.position3
    let tp = table.position3
    if bp.x != tp.x {
        return GridSize(3, 2)
    } else {
        return GridSize(2, 3)
    }
}

@_transparent func b4p_minPos(gridPos: GridPos, size: GridSize) -> GridPos {
    switch size {
    case GridSize(3, 2):
        return GridPos(gridPos.x - 1, gridPos.y)
    case GridSize(2, 3):
        return GridPos(gridPos.x, gridPos.y - 1)
    default: unreachable()
    }
}

extension GameObject {
    @MainActor static func newBooths4Persons(_ game: Game, position: Position3 = Position3(0, 0, 0)) -> Self {
        let booth1 = ObjectSpawner.spawnBooth(game, position: position + Position3(0, 0, 1), type: .single)
        let booth2 = ObjectSpawner.spawnBooth(game, position: position + Position3(0, 0, -1), type: .single)
        transformObjects(booth1) { transf in
            transf.rotation *= (Quaternion(direction: .left) * Quaternion(direction: .left))
        }
        let table = ObjectSpawner.spawnTable(game)
        
        return GameObject(.booths4Persons(
            booth1: booth1,
            table: table,
            Booth2: booth2
        ))
    }
}

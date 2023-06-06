//
//  Booths4Persons.swift
//  
//
//  Created by Jonas Everaert on 05/06/2023.
//

import GateEngine

@_transparent func b4p_move(to position: Position3, booth1: Entity, table: Entity, booth2: Entity) {
    transformObjects(booth1) { t in
        t.position = position + Position3(0, 0, 1)
    }
    transformObjects(booth2) { t in
        t.position = position + Position3(0, 0, -1)
    }
    table.component(ofType: Transform3Component.self)?.position = position
}

@_transparent func b4p_rotate(times: Int, booth1: Entity, table: Entity, booth2: Entity) {
    let tableTransf = table.component(ofType: Transform3Component.self)!
    let booth1newPos: Position3?
    let booth2newPos: Position3?
    switch times % 4 {
    case 0:
        booth1newPos = nil
        booth2newPos = nil
    case 1:
        booth1newPos = tableTransf.position + Position3(1, 0, 0)
        booth2newPos = tableTransf.position + Position3(-1, 0, 0)
    case 2:
        booth1newPos = tableTransf.position + Position3(0, 0, -1)
        booth2newPos = tableTransf.position + Position3(0, 0, 1)
    case 3:
        booth1newPos = tableTransf.position + Position3(-1, 0, 0)
        booth2newPos = tableTransf.position + Position3(1, 0, 0)
    default:
        unreachable()
    }
    
    transformObjects(booth1) { transform in
        transform.rotation *= (Quaternion(direction: .left) * Float(times))
        if let booth1newPos = booth1newPos { transform.position = booth1newPos }
    }
    
    transformObjects(booth2) { transform in
        transform.rotation *= (Quaternion(direction: .left) * Float(times))
        if let booth2newPos = booth2newPos { transform.position = booth2newPos }
    }
    
    tableTransf.rotation *= (Quaternion(direction: .left) * Float(times))
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

extension GameObject {
    @MainActor static func newBooths4Persons(_ game: Game, position: Position3 = Position3(0, 0, 0)) -> Self {
        let booth1 = ObjectSpawner.spawnBooth(game, position: position + Position3(0, 0, 1), type: .single)
        let booth2 = ObjectSpawner.spawnBooth(game, position: position + Position3(0, 0, -1), type: .single)
        booth2.component(ofType: Transform3Component.self)?.rotation *= (Quaternion(direction: .left) * 2.0)
        let table = ObjectSpawner.spawnTable(game)
        
        return .booths4Persons(
            booth1: booth1,
            table: table,
            Booth2: booth2
        )
    }
}

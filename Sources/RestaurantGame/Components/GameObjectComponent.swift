//
//  GameObjectComponent.swift
//  
//
//  Created by Jonas Everaert on 04/06/2023.
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
            booth1.component(ofType: Transform3Component.self)?.position = position + Position3(0, 0, 1)
            booth2.component(ofType: Transform3Component.self)?.position = position + Position3(0, 0, -1)
            table.component(ofType: Transform3Component.self)?.position = position
        }
    }
    
    func rotate(times: Int) {
        switch self {
        case .uninitialized: return
        case .booths4Persons(booth1: let booth1, table: let table, Booth2: let booth2):
            let booth1Transf = booth1.component(ofType: Transform3Component.self)!
            booth1Transf.rotation *= (Quaternion(direction: .left) * Float(times))
            let booth2Transf = booth2.component(ofType: Transform3Component.self)!
            booth2Transf.rotation *= (Quaternion(direction: .left) * Float(times))
            let tableTransf = table.component(ofType: Transform3Component.self)!
            booth2Transf.rotation *= (Quaternion(direction: .left) * Float(times))
            
            switch times % 4 {
            case 0:
                break
            case 1:
                booth1Transf.position = tableTransf.position + Position3(1, 0, 0)
                booth2Transf.position = tableTransf.position + Position3(-1, 0, 0)
            case 2:
                booth1Transf.position = tableTransf.position + Position3(0, 0, -1)
                booth2Transf.position = tableTransf.position + Position3(0, 0, 1)
            case 3:
                booth1Transf.position = tableTransf.position + Position3(-1, 0, 0)
                booth2Transf.position = tableTransf.position + Position3(1, 0, 0)
            default:
                unreachable()
            }
        }
    }
    
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

final class GameObjectComponent: Component {
    static var componentID: GateEngine.ComponentID = ComponentID()
    
    var gameObject: GameObject
    
    init() {
        self.gameObject = .uninitialized
    }
    
    init(_ gameObject: GameObject) {
        self.gameObject = gameObject
    }
}

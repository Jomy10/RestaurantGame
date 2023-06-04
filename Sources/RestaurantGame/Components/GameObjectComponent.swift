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
    func transform() {
        
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

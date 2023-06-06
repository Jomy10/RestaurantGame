//
//  GameObjectComponent.swift
//  
//
//  Created by Jonas Everaert on 04/06/2023.
//

import GateEngine

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

//
//  GameObjectComponent.swift
//  
//
//  Created by Jonas Everaert on 04/06/2023.
//

import GateEngine

/// Indicates an object that can be placed in the restaurant. Contains mutiple geometry objects
final class GameObjectComponent: Component {
    static var componentID: GateEngine.ComponentID = ComponentID()
    
    var gameObject: GameObject
    
    init() {
        self.gameObject = GameObject(.uninitialized)
    }
    
    init(_ gameObject: GameObject) {
        self.gameObject = gameObject
    }
}

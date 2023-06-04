//
//  CustomGridPositionTransformComponent.swift
//  
//
//  Created by Jonas Everaert on 28/05/2023.
//

import GateEngine

final class CustomGridPositionTransformComponent: Component {
    private var moveTransform: ((GridPos) -> (Position3))? = nil
    
    static var componentID: GateEngine.ComponentID = ComponentID()
    
    required init() {
        self.moveTransform = nil
    }
    
    required init(move: @escaping (GridPos) -> (Position3)) {
        self.moveTransform = move
    }
    
    func setTransorm(_ move: @escaping (GridPos) -> (Position3)) {
        self.moveTransform = move
    }
    
    @inline(__always) public func transform(_ gridPos: GridPos) -> Position3 {
        guard let fn = self.moveTransform else { fatalError() }
        return fn(gridPos)
    }
}

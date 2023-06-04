//
//  MousePicker.swift
//  
//
//  Created by Jonas Everaert on 20/05/2023.
//

import GateEngine

@MainActor
final class MousePicker {
    private let ray: Ray3D?
    private let game: Game
    
    /// Creates a new `MousePicker` and calculates the ray that can be used to pick objects or positions on the floor
    public init(_ game: Game, _ mousePosition: Position2) {
        self.game = game
        guard let window = game.windowManager.mainWindow else {
            self.ray = nil
            return
        }
        guard let camera = Camera(game.cameraEntity) else {
            self.ray = nil
            return
        }
        
        let canvas = Canvas(camera: camera, size: window.size, interfaceScale: window.interfaceScale)
        
        self.ray = canvas.convertTo3DSpace(mousePosition)
    }
    
    public var floorPosition: Position3? {
        guard let ray = self.ray else { return nil }
        guard let t = unitsUntilFloor(cameraPos: ray.origin, ray: ray.direction) else { return nil }
        return Position3(fromVec: (ray.direction * t)) + ray.origin
    }
    
    public var entitiesHit: [(position: Position3, surfaceDirection: Direction3, entity: Entity)] {
        guard let ray = self.ray else { return [] }
        
        return self.game.collision3DSystem.entitiesHit(by: ray)
    }
    
    public var closestEntity: (position: Position3, surfaceDirection: Direction3, triangle: CollisionTriangle?, entity: Entity?)? {
        guard let ray = self.ray else { return nil }
        
        return self.game.collision3DSystem.closestHit(from: ray)
    }
}

func unitsUntilFloor(cameraPos: Position3, ray: Direction3) -> Float? {
    let planeNormal = Vec3(0, 1, 0)
    let planeCenter = Vec3(0, 0, 0)
    
    let denom = planeNormal.dot(ray)
    if abs(denom) > 0.0001 {
        let t = ((planeCenter - cameraPos).dot(planeNormal)) / denom
        
        if (t >= 0) {
            return t
        }
    }
    
    return nil
}

//
//  Renderer.swift
//  
//
//  Created by Jonas Everaert on 03/06/2023.
//

import GateEngine

final class RestaurantGameRenderingSystem: RenderingSystem {
    
    override func render(game: Game, window: Window, withTimePassed delta: Float) {
        
        guard let camera = Camera(game.cameraEntity) else { return }
        
        //=== 3D ===//
        
        var scene = Scene(camera: camera)
       
        // Put entities in scene
        for entity in game.entities {
            guard let material = entity.component(ofType: MaterialComponent.self)?.material else { continue }
            
            guard let transform = entity.component(ofType: Transform3Component.self)?.transform else { continue }
            
            guard let geometry = entity.component(ofType: RenderingGeometryComponent.self)?.geometry else { continue }
            
            scene.insert(geometry, withMaterial: material, at: transform)
        }
        
        window.insert(scene)
        
        //=== 2D ===//
        
        var canvas = Canvas(camera: camera, size: window.size, interfaceScale: window.interfaceScale)
      
        window.insert(canvas)
    }
}

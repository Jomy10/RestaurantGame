//
//  File.swift
//  
//
//  Created by Jonas Everaert on 13/05/2023.
//

import GateEngine

extension ObjectSpawner {
    @discardableResult
    public static func spawnFloor(_ game: Game, position: Position3) -> Entity {
        let floor = Entity()
        floor.configure(Transform3Component.self) { comp in
            comp.position = position
        }
        floor.configure(RenderingGeometryComponent.self) { comp in
            comp.geometry = Geometry(path: "Resources/Objects/floor_tile_pattern_checkered.obj")
        }
        floor.configure(MaterialComponent.self) { material in
            material.channel(0) { channel in
                channel.texture = Texture(path: "Resources/Textures/floor_tile_pattern_checkered.png")
            }
        }
        game.insertEntity(floor)
        
        return floor
    }
}

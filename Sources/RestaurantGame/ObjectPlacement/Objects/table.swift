//
//  table.swift
//  
//
//  Created by Jonas Everaert on 04/06/2023.
//

import GateEngine

extension ObjectSpawner {
    fileprivate static let tableSize = Size3(0.5)
    
    enum TableType {
        case rectangle
    }
    
    @discardableResult
    static func spawnTable(
        _ game: Game,
        position: Position3 = Position3(0, 0, 0),
        type: TableType = .rectangle
    )  -> Entity {
        switch type {
        case .rectangle:
            return Self.spawnTableRectangle(game, position)
        }
    }
    
    fileprivate static func spawnTableRectangle(_ game: Game, _ position: Position3) -> Entity {
        let table = Entity()
        table.configure(Transform3Component.self) { comp in
            comp.position = position
            comp.scale = Self.tableSize
        }
        
        table.configure(RenderingGeometryComponent.self) { comp in
            comp.geometry = Geometry(path: "Resources/Objects/table_rectangle.obj")
        }
        
        table.configure(MaterialComponent.self) { material in
            material.channel(0) { channel in
                channel.texture = Texture(path: "Resources/Textures/table_rectangle.png")
            }
        }
        
        game.insertEntity(table)
        
        return table
    }
}

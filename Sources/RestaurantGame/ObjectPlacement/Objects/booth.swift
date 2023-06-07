//
//  File.swift
//  
//
//  Created by Jonas Everaert on 13/05/2023.
//

import GateEngine

extension ObjectSpawner {
    fileprivate static let boothSize = Size3(1)
    
    @discardableResult
    static func spawnBooth(_ game: Game, position: Position3 = Position3(0, 0, 0), type: BoothType = .full) -> Entity {
        switch type {
        case .single: return Self.spawnBoothHalf(game, position)
        case .full: return Self.spawnBoothFull(game, position)
        }
    }
    
    fileprivate static func spawnBoothFull(_ game: Game, _ position: Position3) -> Entity {
        let booth_deco = Entity()
        booth_deco.configure(Transform3Component.self) { comp in
            comp.position = position
            comp.scale = Self.boothSize
        }
        
        booth_deco.configure(RenderingGeometryComponent.self) { comp in
            comp.geometry = Geometry(path: "Resources/Objects/booth_full__deco.obj")
        }
        
        booth_deco.configure(MaterialComponent.self) { material in
            material.channel(0) { channel in
                channel.texture = Texture(path: "Resources/Textures/booth_full.png")
            }
        }
        
        game.insertEntity(booth_deco)
        
        // Create a new entity
        let cube = Entity()
        
        // Give the entity a 3D transform
        cube.configure(Transform3Component.self) {component in
            component.position = position
            component.scale = Self.boothSize
        }
            
        cube.configure(RenderingGeometryComponent.self) { component in
            component.geometry = Geometry(
                path: "Resources/Objects/booth_full.obj"
            )
        }

        // Give the entity a material
        cube.configure(MaterialComponent.self) { material in
            // Begin modifying material channel zero
            material.channel(0) { channel in
                // Load the engine provided placeholder texture
                channel.texture = Texture(path: "Resources/Textures/booth_full.png")
                // channel.scale = Size2(0.4, 0.4)
                //channel.offset = Position2(10, 10)
                // channel.offset = Position2(0, 0)
            }
        }
        
        cube.configure(Collision3DComponent.self) { (comp: inout Collision3DComponent) in
            // comp.primitiveCollider.radius = cube.transform3.scale / 2
            comp.collider = AxisAlignedBoundingBox3D(radius: cube.transform3.scale / 2)
        }
        
        booth_deco.configure(GroupedComponent.self) { group in
            group.components.append(cube)
        }
        
        cube.configure(GroupedComponent.self) { group in
            group.components.append(booth_deco)
        }
        
        // Add the entity to the game
        game.insertEntity(cube)
        
        return cube
    }
    
    fileprivate static func spawnBoothHalf(_ game: Game, _ position: Position3) -> Entity {
        let booth_deco = Entity()
        booth_deco.configure(Transform3Component.self) { comp in
            comp.position = position
            comp.scale = Self.boothSize
        }
        
        booth_deco.configure(RenderingGeometryComponent.self) { comp in
            comp.geometry = Geometry(path: "Resources/Objects/booth_half__deco.obj")
        }
        
        booth_deco.configure(MaterialComponent.self) { material in
            material.channel(0) { channel in
                channel.texture = Texture(path: "Resources/Textures/booth_half.png")
            }
        }
        
        game.insertEntity(booth_deco)
        
        // Create a new entity
        let cube = Entity()
        
        // Give the entity a 3D transform
        cube.configure(Transform3Component.self) {component in
            component.position = position
            component.scale = Self.boothSize
        }
            
        cube.configure(RenderingGeometryComponent.self) { component in
            component.geometry = Geometry(
                path: "Resources/Objects/booth_half.obj"
            )
        }

        // Give the entity a material
        cube.configure(MaterialComponent.self) { material in
            // Begin modifying material channel zero
            material.channel(0) { channel in
                channel.texture = Texture(path: "Resources/Textures/booth_half.png")
            }
        }
        
        cube.configure(Collision3DComponent.self) { (comp: inout Collision3DComponent) in
            // comp.primitiveCollider.radius = cube.transform3.scale / 2
            comp.collider = AxisAlignedBoundingBox3D(radius: cube.transform3.scale / 2)
        }
        
        booth_deco.configure(GroupedComponent.self) { group in
            group.components.append(cube)
        }
        
        cube.configure(GroupedComponent.self) { group in
            group.components.append(booth_deco)
        }
        
        // Add the entity to the game
        game.insertEntity(cube)
        
        return cube
    }
}

enum BoothType {
    case single
    case full
}

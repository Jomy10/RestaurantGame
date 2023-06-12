//
//  CameraSystem.swift
//  
//
//  Created by Jonas Everaert on 03/06/2023.
//

import GateEngine

fileprivate extension Float {
    func ensureBetween(_ lower: Float, _ upper: Float) -> Float {
        if self < lower {
            return lower
        } else if self > upper {
            return upper
        } else {
            return self
        }
    }
}

final class CameraSystem: System {
    private var previousMouseFloorPos: Position3? = nil
    
    override func setup(game: Game, input: HID) async {
        let camera = Entity()
        
        camera.insert(CameraComponent.self)
        camera.configure(Transform3Component.self) { component in
            component.position.move(4, toward: .backward)
            component.position.move(2, toward: .right) // moving towwards the center of the initial starting restaurant
            component.position.move(3, toward: .up)
            component.rotation.x = (-1.0 * (component.position.y - 1) / 5)
        }
        
        game.insertEntity(camera)
    }
    
    private static var maxYPosition: Float = 10
    private static var minYPosition: Float = 2
    private static var minXRotation: Float = -0.6
    private static var maxXRotation: Float = 0
    
    // TODO: if not in menu / when placing objects
    // override func shouldUpdate(game: Game, input: HID, withTimePassed deltaTime: Float) -> Bool {}
    
    override func update(game: Game, input: HID, withTimePassed delta: Float) async {
        guard let mousePos2 = input.mouse.position else {
            self.previousMouseFloorPos = nil
            return
        }
        defer {
            self.previousMouseFloorPos = InputSystem.mousePicker(game, mousePosition: mousePos2).floorPosition
        }
        
        if InputSystem.isButtonHeldDown(.button1) {
            // Move camera
            
            guard let previousPos = self.previousMouseFloorPos else { return }
            
            guard let currentPos = (InputSystem.mousePicker(game, mousePosition: mousePos2)).floorPosition else {
                return
            }
            let posDiff = previousPos - currentPos
            
            if posDiff.x == 0 && posDiff.z == 0 { return }
            
            guard let cameraEntity = game.cameraEntity else { return }
            cameraEntity.configure(Transform3Component.self) { transform in
                transform.position += posDiff
            }
        } else if InputSystem.isButtonHeldDown(.button2) {
            guard let previousPos = self.previousMouseFloorPos else { return }
            
            guard let currentPos = (InputSystem.mousePicker(game, mousePosition: mousePos2)).floorPosition else { return }
            let posDiff = previousPos - currentPos
            
            if posDiff.z == 0 { return }
            
            guard let cameraEntity = game.cameraEntity else { return }
            cameraEntity.configure(Transform3Component.self) { transform in
                transform.position
                    .move(posDiff.z * 0.5, toward: .down)
                
                if transform.position.y < Self.minYPosition {
                    transform.position.y = Self.minYPosition
                } else if transform.position.y > Self.maxYPosition {
                    transform.position.y = Self.maxYPosition
                }
                
                transform.rotation.x = (-1.0 * (transform.position.y - 1) / 5)
                    .ensureBetween(Self.minXRotation, Self.maxXRotation)
            }
        }
    }
    
    override class var phase: System.Phase { .userInterface }
}

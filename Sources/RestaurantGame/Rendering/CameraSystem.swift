//
//  CameraSystem.swift
//  
//
//  Created by Jonas Everaert on 03/06/2023.
//

import GateEngine

final class CameraSystem: System {
    private var previousMouseFloorPos: Position3? = nil
    
    override func setup(game: Game, input: HID) {
        let camera = Entity()
        
        camera.insert(CameraComponent.self)
        camera.configure(Transform3Component.self) { component in
            component.position.move(1, toward: .backward)
            component.position.move(2, toward: .up)
            component.rotation.x -= 0.4
        }
        
        game.insertEntity(camera)
    }
    
    // TODO: if not in menu / when placing objects
    // override func shouldUpdate(game: Game, input: HID, withTimePassed deltaTime: Float) -> Bool {}
    
    override func update(game: Game, input: HID, withTimePassed delta: Float) {
        guard let mousePos2 = input.mouse.position else {
            self.previousMouseFloorPos = nil
            return
        }
        defer {
            self.previousMouseFloorPos = InputSystem.mousePicker(game, mousePosition: mousePos2).floorPosition
        }
        
        if InputSystem.isbuttonHeldDown(.button1) {
            // Move camera
            
            guard let previousPos = self.previousMouseFloorPos else {
                return
            }
            
            guard let currentPos = (InputSystem.mousePicker(game, mousePosition: mousePos2)).floorPosition else {
                return
            }
            let posDiff = previousPos - currentPos
            
            if posDiff.x == 0 && posDiff.z == 0 { return }
            
            guard let cameraEntity = game.cameraEntity else { return }
            cameraEntity.configure(Transform3Component.self) { transform in
                transform.position += posDiff
            }
        }
//        if InputSystem.isbuttonHeldDown(.button1) {
//            guard let previousPos = self.previousMousePos else {
//                self.previousMousePos =  input.mouse.position
//                return
//            }
            
            // let posDiff = previousPos - (input.mouse.position ?? previousPos)
//        }
    }
    
    override class var phase: System.Phase { .userInterface }
}

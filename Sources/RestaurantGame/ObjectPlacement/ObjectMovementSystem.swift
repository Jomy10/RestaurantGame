//
//  ObjectPlacementSystem.swift
//  
//
//  Created by Jonas Everaert on 03/06/2023.
//

import GateEngine

/// Move objects in the grid, rotate it and place it down
final class ObjectMovementSystem: System {
    /// The object that is being moved
    private static var placingObject: Entity? = nil
    
    public static func selectObject(_ object: Entity) {
        Self.placingObject = object
    }
    
    override func setup(game: Game, input: HID) {}
    
    override func shouldUpdate(game: Game, input: HID, withTimePassed deltaTime: Float) -> Bool {
        Self.placingObject != nil
    }
    
    override func update(game: Game, input: HID, withTimePassed deltaTime: Float) {
        guard let mousePosition = input.mouse.position else { return }
        let object = Self.placingObject.unsafelyUnwrapped // checked in shouldUpdate
        let picker = InputSystem.mousePicker(game, mousePosition: mousePosition)
        guard let mouseFloorPos = picker.floorPosition else { return }
        
        // grid pos in 3d space
        let gridPos = floorPosToGridPos(mouseFloorPos)
        
        // transform grid position back to 3d space
        let floorGridPos: Position3
        if let transform = object.component(ofType: CustomGridPositionTransformComponent.self) {
            floorGridPos = transform.transform(gridPos)
        } else {
            floorGridPos = gridPosToFloorPos(gridPos)
        }
        
        // move the object to the mouse, snapped to the grid
//        object.position3 = floorGridPos
//        if let groupedObjects = object.component(ofType: GroupedComponent.self)?.components {
//            groupedObjects.forEach { entity in
//                entity.position3 = floorGridPos
//            }
//        }
        transformObjects(object) { transform in
            transform.position = floorGridPos
        }
        
        // rotate the object
        if InputSystem.keyClicked[.character("r")]! {
            transformObjects(object) { transform in
                transform.rotation *= Quaternion.init(direction: .left)
            }
        }
        
        // place the object down
        if InputSystem.buttonClicked[.button1]! {
            LevelSystem.grid.addObjectToGrid(object, at: gridPos)
            Self.placingObject = nil
       }
    }
    
    override class func sortOrder() -> SystemSortOrder? {
        SystemSortOrder.after(InputSystem.self)
    }
    
    override class var phase: System.Phase { .userInterface }
}

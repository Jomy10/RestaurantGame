//
//  OpenMenuSystem.swift
//  
//
//  Created by Jonas Everaert on 04/06/2023.
//

import GateEngine

final class OpenMenuSystem: System {
    override func update(game: Game, input: HID, withTimePassed deltaTime: Float) async {
        // TODO: when an icon is clicked too
        
        if InputSystem.keyClicked[transform(key: .character("m"))].unsafelyUnwrapped {
            try! UIState.context.write { code in
                if code == nil {
                    code = .menu
                }
            }
        }
    }

    override class func sortOrder() -> SystemSortOrder? {
        SystemSortOrder.after(InputSystem.self)
    }
    
    override class var phase: System.Phase { .userInterface }
}

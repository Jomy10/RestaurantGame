//
//  UIUpdateSystem.swift
//  
//
//  Created by Jonas Everaert on 21/05/2023.
//

import GateEngine
import GateUI
import Foundation
import JAsync

final class UIUpdateSystem: System {
    override func setup(game: Game, input: HID) async {}
    override func update(game: Game, input: HID, withTimePassed deltaTime: Float) async {
        do {
            try UIState.context.write { context in
                guard let currentContext = context else { return }
                
                guard let mousePosition = input.mouse.interfacePosition else { return }
                let mouseClicked = InputSystem.buttonClicked[.button1]
                assert(mouseClicked != nil) // should never be nil
                
                UIState.contexts[currentContext]?
                    .update(mouseClicked: mouseClicked!, mousePosition: mousePosition)
            }
        } catch let error as RWLock<Any>.Error where error.code == EDEADLK {
            fatalError("Deadlock occured")
        } catch {
            print("error occurred in RWLock read of UI context: \(error)")
        }
    }
    
    override class var phase: Phase { .userInterface }
}

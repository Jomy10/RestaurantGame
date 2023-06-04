//
//  UIUpdateSystem.swift
//  
//
//  Created by Jonas Everaert on 21/05/2023.
//

import GateEngine
import GateUI
import JAsync
import Foundation

final class UIUpdateSystem: System {
    enum UIViewCode {
        case menu
        case objectBuyMenu
        case propertyBuyMenu
    }
    
    private var contexts: [UIViewCode:UIContext] = [:]
    public static var context: RWLock<UIViewCode?> = try! RWLock(nil)
    
    override func setup(game: Game, input: HID) {}
    override func update(game: Game, input: HID, withTimePassed deltaTime: Float) {
        do {
            try Self.context.read { context in
                guard let currentContext = context else { return }
                
                guard let mousePosition = input.mouse.interfacePosition else { return }
                let mouseClicked = InputSystem.buttonClicked[.button1]
                assert(mouseClicked != nil) // should never be nil
                
                self.contexts[currentContext]?.update(mouseClicked: mouseClicked!, mousePosition: mousePosition)
            }
        } catch let error as RWLock<Any>.Error where error.code == EDEADLK {
            fatalError("Deadlock occured")
        } catch {
            print("error occurred in RWLock read of UI context: \(error)")
        }
    }
    
    override class var phase: Phase { .userInterface }
}

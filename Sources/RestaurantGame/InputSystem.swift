//
//  InputSystem.swift
//  
//
//  Created by Jonas Everaert on 03/06/2023.
//

import GateEngine

final class InputSystem: System {
    /// True if the button is currently being held down
    private static var buttonHeldDown: [MouseButton:Bool] = [
        .button1: false,
        .button2: false,
    ]
    /// True if the button has just been pressed (e.g. this frame the button was pressed)
    private static var buttonWasJustClicked: [MouseButton:Bool] = [:]
    public static var buttonClicked: [MouseButton:Bool] {
        Self.buttonWasJustClicked
    }
    
    /// - Returns: True if the button is being held down rather than clicked
    public static func isButtonHeldDown(_ button: MouseButton) -> Bool {
        !(Self.buttonWasJustClicked[button] ?? false) && (Self.buttonHeldDown[button] ?? false)
    }
    
    private static var keyHeldDown: [KeyboardKey:Bool] = [
        .character("r"): false,
        .escape: false,
        .return: false,
    ]
    private static var keyWasJustClicked: [KeyboardKey:Bool] = [:]
    public static var keyClicked: [KeyboardKey:Bool] {
        Self.keyWasJustClicked
    }
    
    private static var __mousePicker: MousePicker?
    public static func mousePicker(_ game: Game, mousePosition: Position2) -> MousePicker {
        Self.__mousePicker ?? MousePicker(game, mousePosition)
    }
    
    override func setup(game: Game, input: HID) {
        Self.buttonWasJustClicked = Self.buttonHeldDown
        Self.keyWasJustClicked = Self.keyHeldDown
    }
    
    override func update(game: Game, input: HID, withTimePassed deltaTime: Float) {
        Self.__mousePicker = nil
        
        // Mouse button
        Self.buttonHeldDown.keys.forEach { button in
            if input.mouse.button(button).isPressed {
                if Self.buttonHeldDown[button].unsafelyUnwrapped {
                    // the button is currently pressed and was presed in the last frame, so
                    // the button was not just pressed
                    Self.buttonWasJustClicked[button] = false
                } else {
                    // Button was just pressed and not pressed in previous frame
                    Self.buttonHeldDown[button] = true
                    Self.buttonWasJustClicked[button] = true
                }
            } else {
                // Button is currently not being pressed
                Self.buttonHeldDown[button] = false
                Self.buttonWasJustClicked[button] = false
            }
        }
        
        // Keyboard keys
        Self.keyHeldDown.keys.forEach { key in
            if input.keyboard.button(key).isPressed {
                if Self.keyHeldDown[key].unsafelyUnwrapped {
                    Self.keyWasJustClicked[key] = false
                } else {
                    Self.keyHeldDown[key] = true
                    Self.keyWasJustClicked[key] = true
                }
            } else {
                Self.keyHeldDown[key] = false
                Self.keyWasJustClicked[key] = false
            }
        }
    }
    
    override class var phase: System.Phase { .userInterface }
    
    override class func sortOrder() -> SystemSortOrder? {
        SystemSortOrder.before(CameraSystem.self)
    }
}

//
//  UIState.swift
//  
//
//  Created by Jonas Everaert on 04/06/2023.
//

import GateEngine
import GateUI
import JAsync

@MainActor
struct UIState {
    enum UIViewCode {
        case menu
        case objectBuyMenu
        case propertyBuyMenu
    }
    
    public static var contexts: [UIViewCode:UIContext] = [:]
    public static var context: RWLock<UIViewCode?> = try! RWLock(nil)
    
    public static func setup() {
        Self.contexts = [
            .menu: UIContext(ui: Menu(), at: Position2(0, 0))
        ]
    }
}

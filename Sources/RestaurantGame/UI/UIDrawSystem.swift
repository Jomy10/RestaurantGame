//
//  UIDrawSystem.swift
//  
//
//  Created by Jonas Everaert on 04/06/2023.
//

import GateEngine
import GateUI

final class UIDrawSystem: RenderingSystem {
    override func shouldRender(game: Game, window: Window, withTimePassed deltaTime: Float) -> Bool {
        guard let shouldUpdate = (try? UIState.context.read { context in
            return context != nil
        }) else { return false }
        return shouldUpdate
    }
    
    override func render(game: Game, window: Window, withTimePassed delta: Float) {
        guard let cameraEntity = game.cameraEntity else {return}
        let camera = Camera(cameraEntity)
        
        var canvas = Canvas(camera: camera, size: window.size, interfaceScale: window.interfaceScale)
        
        do {
            try UIState.context.read { context in
                if let context = context {
                    UIState.contexts[context]?.draw(in: &canvas)
                }
            }
        } catch {
            print("Error occurred in RWLock: \(error)")
        }
        
        window.insert(canvas)
    }
    
    override class func sortOrder() -> RenderingSystemSortOrder? {
        RenderingSystemSortOrder.after(RestaurantGameRenderingSystem.self)
    }
}

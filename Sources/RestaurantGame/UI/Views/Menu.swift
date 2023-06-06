//
//  Menu.swift
//  
//
//  Created by Jonas Everaert on 29/05/2023.
//

import GateEngine
import Foundation
import GateUI

struct Menu: UIElement {
   private var root: UIVStack
    
    init() {
        self.root = UIVStack {
            UIHStack {
                UIVStack {
                    UIRectangle(size: Size2(splat: 50), color: .red)
                    UIText("Buy property")
                }.on(click: {
//                    State.playerMode = .propertyBuying
                    // we are inside of .update, so we are already writing to context, that's why we
                    // launch a new process here to change the context when update is done
                    // i.e. wait for the lock to become available
                    DispatchQueue.global(qos: .userInteractive).async {
                        do {
                            try UIState.context.write { (code: inout UIState.UIViewCode?) in
                                code = .propertyBuyMenu
                            }
                        } catch {
                            print("Error occured in RWLock: \(error)")
                        }
                    }
                })
                UIVStack {
                    UIRectangle(size: Size2(splat: 50), color: .blue)
                    UIText("Buy furniture")
                }.on(click: {
                    DispatchQueue.global(qos: .userInteractive).async {
                        do {
                            try UIState.context.write { (code: inout UIState.UIViewCode?) in
                                code = .objectBuyMenu
                            }
                        } catch {
                            print("Error occured in RWLock: \(error)")
                        }
                    }
                })
            }
        }
    }
    
    mutating func update(drawingAt position: GameMath.Position2, mouseClicked: Bool, mousePosition: GameMath.Position2) {
        self.root.update(drawingAt: position, mouseClicked: mouseClicked, mousePosition: mousePosition)
    }
    
    func draw(in canvas: inout GateEngine.Canvas, at position: GameMath.Position2) {
        self.root.draw(in: &canvas, at: position)
    }
    
    var size: GameMath.Size2 { self.root.size }
}

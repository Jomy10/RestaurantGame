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
//                    assert(UIManager.UIs[.propertyBuyMenu] != nil, "you forgot to add the UI, stupid")
//
//                    // Wait for the rwlock to become available (after UI has finished update)
//                    DispatchQueue.global(qos: .userInteractive).async {
//                        try! UIManager.context.write { $0 = UIManager.UIs[.propertyBuyMenu] }
//                    }
                })
                UIVStack {
                    UIRectangle(size: Size2(splat: 50), color: .blue)
                    UIText("Buy furniture")
                }.on(click: {
//                    assert(UIManager.UIs[.objectBuyMenu] != nil, "you forgot to add the UI, stupid")
//
//                    // Wait for the rwlock to become available (after UI has finished update)
//                    DispatchQueue.global(qos: .userInteractive).async {
//                        try! UIManager.context.write { $0 = UIManager.UIs[.objectBuyMenu] }
//                    }
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

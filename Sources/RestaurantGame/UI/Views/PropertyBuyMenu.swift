//
//  PropertyBuyMenu.swift
//  
//
//  Created by Jonas Everaert on 29/05/2023.
//

import GateEngine
import GateUI

struct PropertyBuyMenu: UIElement {
    private var root: UIHStack
    
    init() {
        self.root = UIHStack {
            UIText("Price: $??")
//            If({ PropertyBuySystem.selectedProperty != nil }, then: {
//                UIHStack {
//                    UIRectangle(size: Size2(splat: 50), color: .red)
//                        //.on(click: { PropertyBuySystem.cancel() })
//                    UIRectangle(size: Size2(splat: 50), color: .green)
//                        //.on(click: { PropertyBuySystem.buy() })
//                }
//            })
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

//
//  ObjectSelectMenu.swift
//  
//
//  Created by Jonas Everaert on 24/05/2023.
//

import GateEngine
import GateUI

struct ObjectSelectMenu: UIElement {
    private var root: UIVStack
    
    init(_ game: Game) {
        // TODO: have a variable for unlocked items -> ForEach in UI
        self.root = UIVStack {
            UIText("Items")
            UIHStack {
                UIVStack {
                    UIRectangle(size: Size2(splat: 25), color: .red)
                    UIText("booth")
                }.on(click: {
                    //ObjectPlacer.place(game, object: .booth)
                })
                UIVStack {
                    UIRectangle(size: Size2(splat: 25), color: .green)
                    UIText("Table")
                }.on(click: { })
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

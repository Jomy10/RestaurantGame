//
//  UIRectangle.swift
//  
//
//  Created by Jonas Everaert on 21/05/2023.
//

import GateEngine

@MainActor
public struct UIRectangle: UIElement {
    private let rectSize: UIValue<Size2>
    private var rect: Rect
    private var color: UIValue<Color>
    
    public init(size: Size2, color: Color) {
        self.init(size: .value(size), color: .value(color))
    }
    
    public init(size: UIValue<Size2>, color: UIValue<Color>) {
        self.rect = Rect(position: Position2(0, 0), size: size.value)
        self.color = color
        self.rectSize = size
    }
    
    public mutating func update(drawingAt position: GameMath.Position2, mouseClicked: Bool, mousePosition: GameMath.Position2) {
        if case .observable(let size) = self.rectSize {
            size.changed({ size in
                self.rect = Rect(position: Position2(0, 0), size: size)
            })
        }
    }
    
    public func draw(in canvas: inout Canvas, at position: Position2) {
        canvas.insert(self.rect, color: self.color.value, at: position)
    }
    
    public var size: GameMath.Size2 {
        self.rect.size
    }
}

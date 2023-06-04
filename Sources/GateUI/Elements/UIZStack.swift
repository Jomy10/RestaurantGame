//
//  UIZStack.swift
//  
//
//  Created by Jonas Everaert on 22/05/2023.
//

import GateEngine

@MainActor
public struct UIZStack: UIElement {
    private var elements: [any UIElement]
    
    public init(@UIBuilder _ elements: () -> [any UIElement]) {
        self.elements = elements()
    }
    
    public mutating func update(drawingAt position: GameMath.Position2, mouseClicked: Bool, mousePosition: GameMath.Position2) {
        for i in 0..<self.elements.count {
            self.elements[i].update(drawingAt: position, mouseClicked: mouseClicked, mousePosition: mousePosition)
        }
    }
    
    public func draw(in canvas: inout GateEngine.Canvas, at position: GameMath.Position2) {
        for i in 0..<self.elements.count {
            self.elements[i].draw(in: &canvas, at: position)
        }
    }
    
    public var size: GameMath.Size2 {
        self.elements
            .map { $0.size }
            .reduce(Size2.zero) { Size2(max($0.width, $1.width), max($0.height, $1.height)) }
    }
}

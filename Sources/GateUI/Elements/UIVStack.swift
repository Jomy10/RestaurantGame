//
//  UIVStack.swift
//  
//
//  Created by Jonas Everaert on 21/05/2023.
//

import GateEngine

@MainActor
public struct UIVStack: UIElement {
    private var elements: [any UIElement]
    private var verticalSpacing: UIValue<Float>
    
    public init(spacing: Float = 10, @UIBuilder _ elements: () -> [any UIElement]) {
        self.init(spacing: .value(spacing), elements)
    }
    
    public init(spacing: UIValue<Float>, @UIBuilder _ elements: () -> [any UIElement]) {
        self.elements = elements()
        let _ = elements()
        self.verticalSpacing = spacing
    }
    
    public mutating func update(drawingAt position: GameMath.Position2, mouseClicked: Bool, mousePosition: GameMath.Position2) {
        let verticalSpacing = self.verticalSpacing.value
        var offset: Position2 = position + Position2(0, verticalSpacing)
        for i in 0..<self.elements.count {
            self.elements[i].update(drawingAt: offset, mouseClicked: mouseClicked, mousePosition: mousePosition)
            offset.y += self.elements[i].size.height + verticalSpacing
        }
    }
    
    public func draw(in canvas: inout Canvas, at position: Position2) {
        let verticalSpacing = self.verticalSpacing.value
        var offset: Position2 = position + Position2(0, verticalSpacing)
        for i in 0..<self.elements.count {
            self.elements[i].draw(in: &canvas, at: offset)
            offset.y += self.elements[i].size.height + verticalSpacing
        }
    }
    
    public var size: GameMath.Size2 {
        let verticalSpacing = self.verticalSpacing.value
        let sizes = self.elements.map { $0.size }
        
        let maxWidth = sizes.max { a, b in
            a.width < b.width
        }?.width ?? 0
        
        let totalHeight: Float = sizes.reduce(0) { partialResult, size in
            partialResult + size.height + verticalSpacing
        } + verticalSpacing // extra spacing before the first element
        
        return Size2(maxWidth, totalHeight)
    }
}

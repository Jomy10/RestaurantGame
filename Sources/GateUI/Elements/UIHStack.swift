//
//  UIHStack.swift
//  
//
//  Created by Jonas Everaert on 21/05/2023.
//

import GateEngine

@MainActor
public struct UIHStack: UIElement {
    private var elements: [any UIElement]
    private var horizontalSpacing: UIValue<Float>
    
    public init(spacing: Float = 10, @UIBuilder _ elements: () -> [any UIElement]) {
        self.init(spacing: .value(spacing), elements)
    }
    public init(spacing: UIValue<Float>, @UIBuilder _ elements: () -> [any UIElement]) {
        self.horizontalSpacing = spacing
        self.elements = elements()
    }
    
    public mutating func update(drawingAt position: GameMath.Position2, mouseClicked: Bool, mousePosition: GameMath.Position2) {
        let horizontalSpacing = self.horizontalSpacing.value
        var offset: Position2 = position + Position2(horizontalSpacing, 0)
        for i in 0..<self.elements.count {
            self.elements[i].update(drawingAt: offset, mouseClicked: mouseClicked, mousePosition: mousePosition)
            offset.x += self.elements[i].size.width + horizontalSpacing
        }
    }
    
    public func draw(in canvas: inout GateEngine.Canvas, at position: GameMath.Position2) { let horizontalSpacing = self.horizontalSpacing.value
        var offset: Position2 = position + Position2(horizontalSpacing, 0)
        for i in 0..<self.elements.count {
            self.elements[i].draw(in: &canvas, at: offset)
            offset.x += self.elements[i].size.width + horizontalSpacing
        }
    }
    
    public var size: GameMath.Size2 {
        let horizontalSpacing = self.horizontalSpacing.value
        let sizes = self.elements.map { $0.size }
        
        let maxHeight = sizes.max { a, b in
            a.height < b.height
        }?.height ?? 0
        
        let totalWidth: Float = sizes.reduce(0) { partialResult, size in
            partialResult + size.height + horizontalSpacing
        } + horizontalSpacing
        
        return Size2(totalWidth, maxHeight)
    }
}

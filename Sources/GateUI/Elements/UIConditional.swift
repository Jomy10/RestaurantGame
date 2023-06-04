//
//  UIConditional.swift
//  
//
//  Created by Jonas Everaert on 23/05/2023.
//

import GateEngine

extension GateEngine.Size2 {
    init(splat v: Float) {
        self.init(v, v)
    }
}

public typealias If = UIConditional

@MainActor
public struct UIConditional: UIElement {
    private var condition: () -> Bool
    private var trueContent: any UIElement
    private var falseContent: (any UIElement)?
    private var evaluatedContition: Bool
    
    public init(_ condition: @autoclosure @escaping () -> Bool, then trueContent: () -> any UIElement, `else` falseContent: () -> (any UIElement)? = { nil }) {
        self.trueContent = trueContent()
        self.falseContent = falseContent()
        self.condition = condition
        self.evaluatedContition = condition()
    }
    
    public mutating func update(drawingAt position: GameMath.Position2, mouseClicked: Bool, mousePosition: GameMath.Position2) {
        self.evaluatedContition = self.condition()
    }
    
    public func draw(in canvas: inout GateEngine.Canvas, at position: GameMath.Position2) {
        if self.evaluatedContition {
            trueContent.draw(in: &canvas, at: position)
        } else {
            if let falseContent = self.falseContent {
                falseContent.draw(in: &canvas, at: position)
            }
        }
    }
    
    public var size: GameMath.Size2 { self.condition() ? self.trueContent.size : (self.falseContent?.size ?? Size2(splat: 0)) }
}

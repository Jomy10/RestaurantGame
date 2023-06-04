//
//  UIText.swift
//  
//
//  Created by Jonas Everaert on 21/05/2023.
//

import GateEngine

@MainActor
public struct UIText: UIElement {
    private var text: UIValue<String> //Observable<String>
    private var pointSize: UInt
    private var color: Color
    private var textElement: Text
    
    public init(_ text: String, pointSize: UInt = 25, color: Color = .white) {
        self.text = .value(text)
        self.pointSize = pointSize
        self.color = color
        self.textElement = Text(string: text, pointSize: pointSize, color: color)
    }
    
    public init(_ text: Observed<String>, pointSize: UInt = 25, color: Color = .white) {
        self.text = .observable(text)
        self.pointSize = pointSize
        self.color = color
        self.textElement = Text(string: text.value, pointSize: pointSize, color: color)
    }
    
    public mutating func update(drawingAt position: GameMath.Position2, mouseClicked: Bool, mousePosition: GameMath.Position2) {
        if case .observable(let observed) = text {
            observed.changed { (value: String) in
                self.textElement = Text(string: value, pointSize: self.pointSize, color: self.color)
            }
        }
    }
    
    public func draw(in canvas: inout GateEngine.Canvas, at position: GameMath.Position2) {
        canvas.insert(self.textElement, at: position)
    }
    
    public var size: GameMath.Size2 { self.textElement.size }
}


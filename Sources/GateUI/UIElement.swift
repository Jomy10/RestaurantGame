//
//  UIElement.swift
//
//
//  Created by Jonas Everaert on 21/05/2023.
//

import GateEngine

// typealias DrawCommand = @MainActor (_ canvas: inout Canvas) -> ()

@MainActor
public protocol UIElement {
    /// Updates the element and gets draw commands ready to be called during the drawing phase
    ///
    /// - Parameters:
    ///     - `drawingAt position`: the position (upper left corner) that this element should be drawn at
    ///     - `mouseClicked`: is true when the mouse has been clicked (so will be false if it is still held down)
    ///     - `mousePosition`: the current position of the mouse
    mutating func update(drawingAt position: Position2, mouseClicked: Bool, mousePosition: Position2)
    func draw(in canvas: inout Canvas, at position: Position2)
    
    var size: Size2 { get }
}

public extension UIElement {
    func on(click: @escaping () -> () = {}, enter: @escaping () -> () = {}, leave: @escaping () -> () = {}) -> InteractableUIElement<Self> {
        InteractableUIElement(self, onClick: click, onEnter: enter, onLeave: leave)
    }
    
    func fill(color: Color) -> ExtendedDrawUIElement<Self> {
        ExtendedDrawUIElement(self) { canvas, drawPosition in
            canvas.insert(Rect(0, 0, self.size.x, self.size.y), color: color, at: drawPosition)
        }
    }
    
    func padding(_ value: Float) -> PaddedUIElement<Self> {
        PaddedUIElement(self, padding: value)
    }
    
    func padding(_ value: Float, _ direction: DirectionalPaddedUIElement<Self>.PaddingDirection) -> DirectionalPaddedUIElement<Self> {
        DirectionalPaddedUIElement(self, padding: value, direction: direction)
    }
}

// - MARK: Interactable element

public struct InteractableUIElement<Element: UIElement>: UIElement {
    private var __onClick: () -> ()
    private var __onEnter: () -> ()
    private var __onLeave: () -> ()
    /// An element is hot when the mouse is hovering over it
    private var isHot: Bool = false
    private var body: Element
    
    internal init(_ e: Element, onClick: @escaping () -> (), onEnter: @escaping () -> (), onLeave: @escaping () -> ()) {
        self.body = e
        self.__onClick = onClick
        self.__onEnter = onEnter
        self.__onLeave = onLeave
    }

    public mutating func update(drawingAt position: GameMath.Position2, mouseClicked: Bool, mousePosition: GameMath.Position2) {
        // Interactivity
        if mousePosition.x > position.x && mousePosition.y > position.y
            && mousePosition.x < position.x + self.size.x && mousePosition.y < position.y + self.size.y {
            if !self.isHot {
                self.isHot = true
                self.__onEnter()
            }
            
            if mouseClicked {
                self.__onClick()
            }
        } else if self.isHot {
            self.isHot = false
            self.__onLeave()
        }
        
        // Body update
        return body.update(drawingAt: position, mouseClicked: mouseClicked, mousePosition: mousePosition)
    }
    
    public func draw(in canvas: inout Canvas, at position: Position2) {
        body.draw(in: &canvas, at: position)
    }
    
    public var size: GameMath.Size2 { self.body.size }
}

// - MARK: ExtendedDraw

/// Add any arbitrary drawing logic before an element's draw implementation
public struct ExtendedDrawUIElement<Element: UIElement>: UIElement {
    public typealias ExtendedDrawCommand = @MainActor (_ canvas: inout Canvas, _ drawCommand: Position2) -> ()
    
    private var drawCommand: ExtendedDrawCommand
    private var body: Element
    
    public init(_ body: Element, _ drawCommand: @escaping ExtendedDrawCommand) {
        self.body = body
        self.drawCommand = drawCommand
    }
    
    public mutating func update(drawingAt position: GameMath.Position2, mouseClicked: Bool, mousePosition: GameMath.Position2) {
        // var drawCommands = [self.drawCommand(position)]
        self.body.update(drawingAt: position, mouseClicked: mouseClicked, mousePosition: mousePosition)
    }
    
    public func draw(in canvas: inout Canvas, at position: Position2) {
        self.drawCommand(&canvas, position)
        self.body.draw(in: &canvas, at: position)
    }
    
    public var size: GameMath.Size2 { self.body.size }
}

// - MARK: Padding
public struct PaddedUIElement<Element: UIElement>: UIElement {
    private var padding: Float
    private var body: Element
    
    internal init(_ body: Element, padding: Float) {
        self.padding = padding
        self.body = body
    }
    
    public mutating func update(drawingAt position: GameMath.Position2, mouseClicked: Bool, mousePosition: GameMath.Position2) {
        self.body.update(drawingAt: position + self.padding, mouseClicked: mouseClicked, mousePosition: mousePosition)
    }
    
    public func draw(in canvas: inout GateEngine.Canvas, at position: GameMath.Position2) {
        self.body.draw(in: &canvas, at: position + self.padding)
    }
    
    public var size: GameMath.Size2 {
        self.body.size + self.padding * 2
    }
}

public struct DirectionalPaddedUIElement<Element: UIElement>: UIElement {
    public enum PaddingDirection {
        case up
        case down
        case left
        case right
    }
    
    private var body: Element
    private var padding: Float
    private var direction: PaddingDirection
    
    internal init(_ body: Element, padding: Float, direction: PaddingDirection) {
        self.body = body
        self.padding = padding
        self.direction = direction
    }
    
    public mutating func update(drawingAt position: GameMath.Position2, mouseClicked: Bool, mousePosition: GameMath.Position2) {
        var elementPosition = position
        if self.direction == .left {
            elementPosition = elementPosition.moved(self.padding, toward: .right)
        } else if self.direction == .up {
            elementPosition = elementPosition.moved(self.padding, toward: .down)
        }
        self.body.update(drawingAt: elementPosition, mouseClicked: mouseClicked, mousePosition: mousePosition)
    }
    
    public func draw(in canvas: inout GateEngine.Canvas, at position: GameMath.Position2) {
        var elementPosition = position
        if self.direction == .left {
            elementPosition = elementPosition.moved(self.padding, toward: .right)
        } else if self.direction == .up {
            elementPosition = elementPosition.moved(self.padding, toward: .down)
        }
        self.body.draw(in: &canvas, at: elementPosition)
    }
    
    public var size: GameMath.Size2 {
        switch self.direction {
        case .up: fallthrough
        case .down:
            return self.body.size + Size2(0,self.padding)
        case .left: fallthrough
        case .right:
            return self.body.size + Size2(self.padding, 0  )
        }
    }
}

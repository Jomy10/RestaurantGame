//
//  UIManager.swift
//  
//
//  Created by Jonas Everaert on 21/05/2023.
//

import GateEngine

@resultBuilder
public struct UIBuilder {
    public static func buildBlock(_ components: any UIElement...) -> [any UIElement] {
        components
    }
}

//@MainActor
//public struct UIManager {
//    static var context: RWLock<UIContext?> = try! RWLock(nil)
//
//    enum UIViewCode {
//        case menu
//        case objectBuyMenu
//        case propertyBuyMenu
//    }
//    static var UIs: [UIViewCode:UIContext] = [:]
//
//    static func setup(_ game: Game) {
//        Self.UIs = [
//            .menu: {
//                var context = UIContext()
//                context.setUI(Menu())
//                context.position = Position2(splat: 0)
//                return context
//            }(),
//            .objectBuyMenu: {
//                var context = UIContext()
//                context.setUI(ObjectSelectMenu(game))
//                context.position = Position2(splat: 0)
//                return context
//            }(),
//            .propertyBuyMenu: {
//                var context = UIContext()
//                context.setUI(PropertyBuyMenu())
//                context.position = Position2(splat: 0)
//                return context
//            }()
//        ]
//    }
//
//    static var size: Size2? {
//        try! self.context.read { $0?.size }
//    }
//
//    static func update(mouseClicked: Bool, mousePosition: Position2) {
//        try! Self.context.write { $0?.update(mouseClicked: mouseClicked, mousePosition: mousePosition) }
//    }
//
//    @MainActor static func draw(in canvas: inout Canvas) {
//        try! Self.context.read { $0?.draw(in: &canvas) }
//    }
//}

@MainActor
public struct UIContext {
    /// root UI element
    private var rootElement: (any UIElement)?
    /// UI postion
    public var position: Position2 = Position2(0, 0)
    private var drawCommands: [DrawCommand] = []
    
    public var size: Size2? {
        self.rootElement?.size
    }
    
    public mutating func setUI(at position: Position2? = nil, _ root: any UIElement) {
        if let pos = position {
            self.position = pos
        }
        self.rootElement = root
    }
    
    public mutating func update(mouseClicked: Bool, mousePosition: Position2) {
        self.rootElement?.update(drawingAt: self.position, mouseClicked: mouseClicked, mousePosition: mousePosition)
    }
    
    @MainActor
    public func draw(in canvas: inout Canvas) {
        self.rootElement?.draw(in: &canvas, at: self.position)
    }
}

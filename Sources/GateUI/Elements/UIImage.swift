//
//  UIImage.swift
//  
//
//  Created by Jonas Everaert on 21/05/2023.
//

import GateEngine

// TODO: texture.state == .ready -> anders een loading image
@MainActor
public struct UIImage: UIElement {
    private var sprite: Sprite {
        let texture = self.texture.value
        return Sprite(texture: texture, bounds: Rect(size: texture.size))
    }
    private var texture: UIValue<Texture>
    private let texturePath: Observed<String>?
    private let textureReadyCallback: () -> ()
    private var isTextureReady: Bool = false
    
    public init(_ path: String, sizeHint: Size2 = Size2(25, 25), onTextureReady: @escaping () -> () = { }) {
        self.texture = .value(Texture(path: path, sizeHint: sizeHint))
        self.texturePath = nil
        self.textureReadyCallback = onTextureReady
    }
    
    public init(_ path: Observed<String>, sizeHint: Size2 = Size2(25, 25), onTextureReady: @escaping () -> () = { }) {
        self.texture = .value(Texture(path: path.value, sizeHint: sizeHint))
        self.texturePath = path
        self.textureReadyCallback = onTextureReady
    }
    
    public init(texture: UIValue<Texture>, onTextureReady: @escaping () -> () = { }) {
        self.texture = texture
        self.texturePath = nil
        self.textureReadyCallback = onTextureReady
    }
    
    public mutating func update(drawingAt position: GameMath.Position2, mouseClicked: Bool, mousePosition: GameMath.Position2) {
        if let path = self.texturePath {
            path.changed { val in
                self.texture = .value(Texture(path: val, sizeHint: self.sprite.texture.size))
            }
        }
        if !self.isTextureReady && self.texture.value.state == .ready {
            self.isTextureReady = true
            self.textureReadyCallback()
        }
    }
    
    public func draw(in canvas: inout GateEngine.Canvas, at position: GameMath.Position2) {
        canvas.insert(self.sprite, at: position + self.size / 2)
    }
    
    public var size: GameMath.Size2 { self.sprite.texture.size }
}

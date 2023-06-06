//
//  Vec2.swift
//  
//
//  Created by Jonas Everaert on 03/06/2023.
//

import GateEngine

extension Vector2 {
    init(splat v: Float) {
        self.init(v, v)
    }
}

protocol IVector2: Hashable, Equatable {
    associatedtype T: BinaryInteger
    var x: T { get set }
    var y: T { get set }
    init(_ x: T, _ y: T)
}

extension IVector2 {
    @_transparent static func * (lhs: Self, rhs: Self) -> Self {
        Self(
            lhs.x * rhs.x,
            lhs.y * rhs.y
        )
    }
    
    @_transparent static func * (lhs: Self, rhs: T) -> Self {
        Self(
            lhs.x * rhs,
            lhs.y * rhs
        )
    }
    
    @_transparent static func + (lhs: Self, rhs: Self) -> Self {
        Self(
            lhs.x + rhs.x,
            lhs.y + rhs.y
        )
    }
}

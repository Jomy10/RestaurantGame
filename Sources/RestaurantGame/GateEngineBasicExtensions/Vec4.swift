//
//  Vec4.swift
//  
//
//  Created by Jonas Everaert on 20/05/2023.
//

import GateEngine

struct Vec4 {
    var x: Float
    var y: Float
    var z: Float
    var w: Float
    
    init(_ x: Float, _ y: Float, _ z: Float, _ w: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
    
    var xyz: Vec3 {
        return Vec3(self.x, self.y, self.z)
    }
    
    @_transparent static func *(lhs: Self, rhs: Matrix4x4) -> Self {
        var x: Float = lhs.x * rhs.a
        x += lhs.y * rhs.b
        x += lhs.z * rhs.c
        x += lhs.w * rhs.d
        
        var y: Float = lhs.x * rhs.e
        y += lhs.y * rhs.f
        y += lhs.z * rhs.g
        y += lhs.w * rhs.h
        
        var z: Float = lhs.x * rhs.i
        z += lhs.y * rhs.j
        z += lhs.z * rhs.k
        z += lhs.w * rhs.l
        
        var w: Float = lhs.x * rhs.m
        w += lhs.y * rhs.n
        w += lhs.z * rhs.o
        w += lhs.w * rhs.p
        
        return Self(x, y, z, w)
    }
    
    @_transparent static func *(lhs: Matrix4x4, rhs: Self) -> Self {
        return rhs * lhs
    }
    
    @_transparent static func *(lhs: Self, rhs: Float) -> Self {
        return Self(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs, lhs.w * rhs)
    }
    
    @_transparent static func *=(lhs: inout Self, rhs: Float) {
        lhs = lhs * rhs
    }
    
    @_transparent static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z && lhs.w == rhs.w
    }
    
    @_transparent static func !=(lhs: Self, rhs: Self) -> Bool {
        return !(lhs == rhs)
    }
    
    @_transparent
    public var squaredLength: Float {
        return x * x + y * y + z * z + w * w
    }
    
    @_transparent
    public var magnitude: Float {
        return self.squaredLength.squareRoot()
    }
    
    @_transparent
    public var normalized: Self {
        var copy = self
        copy.normalize()
        return copy
    }
    
    @_transparent
    public mutating func normalize() {
        if self != Self.zero {
            let magnitude = self.magnitude
            let factor = 1 / magnitude
            self *= factor
        }
    }
    
    public static var zero: Self {
        Self(0, 0, 0, 0)
    }
}


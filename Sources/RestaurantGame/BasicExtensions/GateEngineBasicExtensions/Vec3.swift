//
//  Vec3.swift
//  
//
//  Created by Jonas Everaert on 20/05/2023.
//

import GateEngine

extension Vector3 {
    init(fromVec other: some Vector3) {
        self.init(other.x, other.y, other.z)
    }
}

/// A generic 3d vector
struct Vec3: Vector3 {
    var x: Float
    var y: Float
    var z: Float
    
    init(_ x: Float, _ y: Float, _ z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    static var zero: Vec3 = Vec3(0, 0, 0)
}

extension Transform3 {
    func isPointInside(_ point: Position3) -> Bool {
        return point.x > self.position.x && point.x < self.position.x + self.scale.x
        && point.y > self.position.y && point.y < self.position.y + self.scale.y
        && point.z > self.position.z && point.z < self.position.z + self.scale.z
    }
}

extension Size3 {
    init(splat val: Float) {
        self.init(val, val, val)
    }
}

extension Position3 {
    @_transparent init<Vec: Vector3>(fromVec vec: Vec) {
        self.init(vec.x, vec.y, vec.z)
    }
}

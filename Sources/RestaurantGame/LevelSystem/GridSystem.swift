//
//  GridSystem.swift
//  
//
//  Created by Jonas Everaert on 03/06/2023.
//

import GateEngine
import Foundation

struct GridPos: Hashable, Equatable, IVector2 {
    var x, y: Int32
    
    init(_ x: Int32, _ y: Int32) {
        self.x = x
        self.y = y
    }
    
    init(fromChunk chunkPos: ChunkPos) {
        self.x = Int32(chunkPos.x)
        self.y = Int32(chunkPos.y)
    }
    
    static var zero: Self {
        Self(0, 0)
    }
}
  
typealias GridSize = GridPos

func floorPosToGridPos(_ floorPos: Position3) -> GridPos {
    return GridPos(
        Int32(floor(floorPos.x * (GRID_SIZE / 2))),
        Int32(floor(floorPos.z * (GRID_SIZE / 2)))
    )
}

func gridPosToFloorPos(_ gridPos: GridPos) -> Position3 {
    Position3(
        Float(gridPos.x) / (GRID_SIZE / 2.0),
        0,
        Float(gridPos.y) / (GRID_SIZE / 2.0)
    )
}

/// One floor tile is divided into `GRID_SIZE` elements
let GRID_SIZE: Float = 2

func sizeToGridSize(_ size: Size3) -> GridSize {
    return GridSize(
        Int32(floor(size.x * GRID_SIZE)),
        Int32(floor(size.z * GRID_SIZE))
    )
}

// - MARK: GridSystem

extension LevelSystem {
    public static var grid: GridObjects = GridObjects()
    
    struct GridObjects {
        private var gridObjects: [UUID:(GridPos, GameObject)] = [:]
        public var minX: Int32 = -2
        public var minY: Int32 = -2
        public var width: Int32 = 0
        public var height: Int32 = 0
        public mutating func setGridSize(width: Int32, height: Int32) {
            self.width = width
            self.height = height
        }
    
        public mutating func addObjectToGrid(_ obj: GameObject, at position: GridPos) {
            self.gridObjects[obj.id] = (position, obj)
        }
        
        public mutating func removeObjectFromGrid(_ obj: GameObject) {
            self.gridObjects.removeValue(forKey: obj.id)
        }
        
        /// returns whether the specified object can be placed on the grid at the given position
        /// i.e. if it is not blocked by any other object
        public func canPlace(object objectToBePlaced: GameObject, at position: GridPos) -> Bool {
            let pObjGridSize = objectToBePlaced.gridSize
            let pObjPos = objectToBePlaced.minGridPos(pos: position, size: pObjGridSize)
            // TODO: account for the weird shape of the restaurant
            if pObjPos.x < self.minX || pObjPos.y < self.minY
                || pObjPos.x + pObjGridSize.x > self.minX + self.width
                || pObjPos.y + pObjGridSize.y > self.minY + self.height {
                // object outside of the restaurant
                return false
            }
            
            // TODO: filter -> only check close objects
            for (objPos, object) in self.gridObjects.values {
                if pObjPos.x + pObjGridSize.x < objPos.x || pObjPos.y + pObjGridSize.y < objPos.y {
                    return false
                }
                let objGridSize = object.gridSize
                if pObjPos.x > objPos.x + objGridSize.x || pObjPos.y > objPos.y + objGridSize.y {
                    return false
                }
            }
            
            return true
        }
    }
    
//    struct GridObjectsOld {
//        fileprivate init() {}
//
//        // - MARK: Grid variables
//        private var gridObjects: [GridPos:Entity] = [:]
//        private var shouldRecalculateGrid: Bool = true
//
//        // - MARK: Object add / remove
//        public mutating func addObjectToGrid(_ entity: GameObject, at position: GridPos) {
//            self.gridObjects[position] = entity
//            self.shouldRecalculateGrid = true
//        }
//
//        public mutating func removeObjectFromGrid(_ entity: Entity) {
//            guard let key = (self.gridObjects.first { (key: GridPos, value: Entity) in
//                value == entity
//            }?.key) else {
//                return
//            }
//
//            self.gridObjects.removeValue(forKey: key)
//            self.shouldRecalculateGrid = true
//        }
//
//        // - MARK: GridSize
//        /// The lowest X coordinate, must be set
//        public var minX: Int32 = -2
//        public var minY: Int32 = -2
//
//        public mutating func setGridSize(width: Int32, height: Int32) {
//            self.shouldRecalculateGrid = true
//            self.__gridStorage = (0..<width).map { _ in
//                (0..<height).map { _ in
//                        .empty
//                }
//            }
//        }
//
//        // - MARK: Grid
//        enum GridValue: Int8, Codable {
//            case unavailable
//            case empty
//            case occupied
//        }
//
//        /// Storage for the grid. It is always resized for the proper width and height
//        private var __gridStorage: [[GridValue]] = [[]]
//        /// Returns the current grid configuration
//        var grid: [[GridValue]] {
//            mutating get {
//                if self.shouldRecalculateGrid {
//                    self.calculateGrid()
//                }
//                return self.__gridStorage
//            }
//        }
//
//        /// Recalculate the grid, only do this when `self.shouldRecalculateGrid` is true
//        /// This will set the `__gridStorage`
//        private mutating func calculateGrid() {
//            self.gridObjects.forEach { (pos: GridPos, obj: Entity) in
//                let scale = obj.transform3.scale
//                let gridScale = sizeToGridSize(scale)
//                for x in 0..<gridScale.x {
//                    for y in 9..<gridScale.y {
//                        self.__gridStorage[Int(pos.x - self.minX + x)][Int(pos.y - self.minY + y)] = .occupied
//                    }
//                }
//            }
//        }
//    }
}

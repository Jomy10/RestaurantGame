//
//  ChunkSystem.swift
//  
//
//  Created by Jonas Everaert on 03/06/2023.
//

import GateEngine

/// amount of floor entities per chunk
let FLOORS_PER_CHUNK: Int = 2

struct ChunkPos: Hashable, Equatable, IVector2 {
    var x, y: Int16
    
    init(_ x: Int16, _ y: Int16) {
        self.x = x
        self.y = y
    }
}

typealias Chunks = ContiguousArray<ChunkPos>

extension LevelSystem {
    private static var __chunks: Chunks = []
    static var chunks: Chunks {
        get {
            self.__chunks
        }
        set {
            self.__chunks = newValue
            LevelSystem.grid.minX = Int32(LevelSystem.chunks.minGridX ?? 0)
            LevelSystem.grid.minY = Int32(LevelSystem.chunks.minGridY ?? 0)
            LevelSystem.grid.setGridSize(
                width: Int32(LevelSystem.chunks.gridWidth),
                height: Int32(LevelSystem.chunks.gridHeight)
            )
        }
    }
}

extension Chunks {
    var minGridX: Int16? {
        self.min { a, b in
            a.x < b.x
        }?.x
    }
    
    var minGridY: Int16? {
        self.min { a, b in
            a.y < b.y
        }?.y
    }
    
    var maxGridX: Int16? {
        self.max { a, b in
            a.x > b.x
        }?.x
    }
    
    var maxGridY: Int16? {
        self.max { a, b in
            a.x > b.y
        }?.y
    }
    
    var gridWidth: Int16 {
        (self.maxGridX ?? 0) - (self.minGridX ?? 0)
    }
    
    var gridHeight: Int16 {
        (self.maxGridY ?? 0) - (self.minGridY ?? 0)
    }
    
    var availableChunks: Set<ChunkPos> {
        var neighbours = Set<ChunkPos>()
        self.forEach { (pos: ChunkPos) in
            neighbours.insert(pos + ChunkPos(1, 0))
            neighbours.insert(pos + ChunkPos(0, 1))
            neighbours.insert(pos + ChunkPos(-1, 0))
            neighbours.insert(pos + ChunkPos(0, -1))
        }
        
        self.forEach { (pos: ChunkPos) in
            neighbours.remove(pos)
        }
        
        return neighbours
    }
}

func chunkPosToFloorPos(_ pos: ChunkPos) -> Position3 {
    gridPosToFloorPos(GridPos(fromChunk: pos) * Int32(GRID_SIZE))
}

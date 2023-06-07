//
//  LevelSystem.swift
//  
//
//  Created by Jonas Everaert on 03/06/2023.
//

import GateEngine

@MainActor
struct LevelSystem {
    /// - chunks: the unlocked chunks
    static func loadChunks(_ game: Game, chunks: Chunks) {
        chunks.forEach { (chunk: ChunkPos) in
            (0..<FLOORS_PER_CHUNK).forEach { r in
                (0..<FLOORS_PER_CHUNK).forEach { c in
                    ObjectSpawner.spawnFloor(game, position: chunkPosToFloorPos(chunk + ChunkPos(Int16(r), Int16(c))))
                }
            }
        }
    }
}

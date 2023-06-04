//
//  .swift
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
            ObjectSpawner.spawnFloor(game, position: chunkPosToFloorPos(chunk))
        }
    }
}

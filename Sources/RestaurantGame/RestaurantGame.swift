import GateEngine

@main
final class RestaurantGame: GameDelegate {
    public func didFinishLaunching(game: Game, options: LaunchOptions) {
        game.insertSystem(CameraSystem.self)
        game.insertSystem(ObjectMovementSystem.self)
        
        // UI
        game.insertSystem(InputSystem.self)
        game.insertSystem(UIUpdateSystem.self)
        
        LevelSystem.chunks = [ChunkPos(0, 0), ChunkPos(1, 0)]
        LevelSystem.loadChunks(game, chunks: LevelSystem.chunks)
        
        // Renering system
        game.insertSystem(RestaurantGameRenderingSystem.self)
    }
}

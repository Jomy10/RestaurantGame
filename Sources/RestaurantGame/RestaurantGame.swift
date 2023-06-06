import GateEngine

@main
final class RestaurantGame: GameDelegate {
    public func didFinishLaunching(game: Game, options: LaunchOptions) {
        game.insertSystem(CameraSystem.self)
        game.insertSystem(ObjectMovementSystem.self)
        
        // UI
        game.insertSystem(InputSystem.self)
        game.insertSystem(UIUpdateSystem.self)
        game.insertSystem(OpenMenuSystem.self)
        
        // Set up the different UIs
        // TODO: do this after the initial resources have been loaded (in ResourceLoader)
        UIState.setup(game)
        
        LevelSystem.chunks = [ChunkPos(0, 0), ChunkPos(1, 0)]
        LevelSystem.loadChunks(game, chunks: LevelSystem.chunks)
        
        // Renering system
        game.insertSystem(RestaurantGameRenderingSystem.self)
        game.insertSystem(UIDrawSystem.self)
    }
}

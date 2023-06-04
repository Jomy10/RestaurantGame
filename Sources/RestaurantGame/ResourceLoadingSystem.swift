//
//  ResourceLoadingSystem.swift
//  
//
//  Created by Jonas Everaert on 03/06/2023.
//

import GateEngine

final class ResourceLoadingSystem: System {
    private var done: Bool = false
   
    // TODO: 
    private struct ResourceGroupLoaded {
        var hasLoaded: Bool
        var models: [String]
        var textures: [String]
        
        init(models: [(String)] = [], textures: [(String)] = [], cacheHint: CacheHint = .forever) {
        }
    }
    
    private var loading: [ResourceGroupLoaded] = [
        
    ]
    
    override func setup(game: Game, input: HID) {}
    
    @inline(__always) override func shouldUpdate(game: Game, input: HID, withTimePassed deltaTime: Float) -> Bool {
        return !done
    }
    
    override func update(game: Game, input: HID, withTimePassed deltaTime: Float) {
    }
    
    override class var phase: System.Phase { .updating }
}

//
//  ResourceLoadingSystem.swift
//  
//
//  Created by Jonas Everaert on 03/06/2023.
//

import GateEngine

final class ResourceLoader {
    enum LoadingOrder: Int, Equatable {
        case startingScreenUI = 0
        case floor
        case essentialObjects
        /// The objects in in the player's restaurant
        case objectsInScene
    }
    
    /// Linked list of loading orders
    struct LoadingOrderList {
        var node: LoadingOrderNode? = nil
        
        mutating func first(_ t: LoadingOrder) {
            if let node = self.node {
                self.node = LoadingOrderNode(t, child: node)
            } else {
                self.node = LoadingOrderNode(t)
            }
        }
        
        mutating func last(_ t: LoadingOrder) {
            if self.node == nil { self.node = LoadingOrderNode(t) }
            var node = self.node!
            while true {
                if node.next == nil { break }
                node = node.next.unsafelyUnwrapped
            }
            node.next = LoadingOrderNode(t)
        }
        
        mutating func insert(_ t: LoadingOrder, after other: LoadingOrder) {
            if self.node == nil { fatalError("the list is empty") }
            var node = self.node!
            while true {
                if node.type == other {
                    if let next = node.next {
                        node.next = LoadingOrderNode(t, child: next)
                    } else {
                        node.next = LoadingOrderNode(t)
                    }
                    break
                }
                
                if let next = node.next {
                    node = next
                } else {
                    fatalError("After value was not found \(other)")
                }
            }
        }
        
//        mutating func insert(_ t: LoadingOrder, after other: LoadingOrder) {
//            if self.node == nil { fatalError("Cannot insert node when there are no nodes added yet") }
//            var node = self.node!
//            while true {
//                if node.type == other {
//                    if let next = node.next {
//                        node.next = LoadingOrderNode(t, child: next)
//                    }
//                    break
//                }
//                if node.next == nil { fatalError("\(other) does not exist in the list yet, adding \(t)") }
//                node = node.next!
//            }
//        }
//
//        mutating func insert(_ t: LoadingOrder, before other: LoadingOrder) {
//            if self.node == nil { fatalError() }
//            var node = self.node!
//            while true {
//                if node.next == nil { fatalError("\(other) does not exist in the list yet, adding \(t)") }
//                if node.next!.type == other {
//                    node.next = LoadingOrderNode(t, child: node.next!)
//                    break
//                }
//                node = node.next!
//            }
//        }
    }
    
    final class LoadingOrderNode {
        let type: LoadingOrder
        var next: LoadingOrderNode?
        
        init(_ t: LoadingOrder) {
            self.type = t
            self.next = nil
        }
        
        init(_ t: LoadingOrder, child: LoadingOrderNode) {
            self.type = t
            self.next = child
        }
    }
    
    struct ResourceLoadingGroup {
        let textures: [String:CacheHint]
        let models: [String:CacheHint]
        
        @MainActor func loadEntities() -> ResourceLoadingGroupEntities {
            ResourceLoadingGroupEntities(
                textures: self.textures.map { (path, cacheHint) in
                    let t = Texture(path: "Resources/Textures/\(path)")
                    t.cacheHint = cacheHint
                    return t
                },
                models: self.models.map { (path, cacheHint) in
                    let g = Geometry(path: "Resources/Objects/\(path)")
                    g.cacheHint = cacheHint
                    return g
                }
            )
        }
    }
    
    struct ResourceLoadingGroupEntities {
        let textures: [Texture]
        let models: [Geometry]
        
        @MainActor var finished: Result<Bool, String> {
            for texture in self.textures {
                switch texture.state {
                case .failed(reason: let reason):
                    return .failure(reason)
                case .pending: return .success(false)
                case .ready: continue
                }
            }
            
            for model in self.models {
                switch model.state {
                 case .failed(reason: let reason):
                    return .failure(reason)
                case .pending: return .success(false)
                case .ready: continue
                }
            }
            
            return .success(true)
        }
    }
    
    var loadingList: LoadingOrderList
    var toLoad: [LoadingOrder:(ResourceLoadingGroup, ResourceLoadingGroupEntities?)]
    var currentGroup: LoadingOrderNode
    var finished: Bool = false
    var error: String? = nil
    
    init() {
        self.loadingList = LoadingOrderList()
        self.loadingList.first(.startingScreenUI)
        self.loadingList.insert(.floor, after: .startingScreenUI)
        self.loadingList.insert(.essentialObjects, after: .floor)
        self.loadingList.insert(.objectsInScene, after: .startingScreenUI)
        
        self.currentGroup = self.loadingList.node!
        
        self.toLoad = [
            .startingScreenUI: (
                ResourceLoadingGroup(
                    textures: [:],
                    models: [:]
                ), nil
            ),
            .floor: (
                ResourceLoadingGroup(
                    textures: [
                        "floor_tile_pattern_checkered.png":.forever,
                    ], models: [
                        "floor_tile_pattern_checkered.obj":.forever,
                    ]
                ), nil
            ),
            .essentialObjects: (
                ResourceLoadingGroup(
                    textures: [
                        "booth_full.png":.forever,
                        "booth_half.png":.forever,
                        "table_rectangle.png":.forever,
                    ],
                    models: [
                        "booth_full.obj":.forever,
                        "booth_full__deco.obj":.forever,
                        "booth_half.obj":.forever,
                        "booth_half__deco.obj":.forever,
                        "table_rectangle.obj":.forever,
                    ]
                ), nil
            ),
            .objectsInScene: (
                ResourceLoadingGroup(
                    textures: [:],
                    models: [:]
                ), nil
            )
        ]
    }
    
    /// Starts loading
    @MainActor func start() {
        self.loadCurrentGroup()
    }
    
    @MainActor private func loadCurrentGroup() {
        print(self.toLoad.keys, self.currentGroup.type)
        let (group, _) = self.toLoad[self.currentGroup.type]!
        print("loading \(self.currentGroup.type)")
        self.toLoad[self.currentGroup.type] = (
            group,
            group.loadEntities()
        )
    }
    
    @MainActor func loadNextIfFinished() {
        switch self.toLoad[self.currentGroup.type]!.1!.finished {
        case .failure(let f):
            self.error = f
        case .success(let finished):
            if finished {
                #if DEBUG
                print("Finished loading \(self.currentGroup.type)", {
                    if let next = self.currentGroup.next {
                        return ", continuing to load \(next.type)"
                    } else {
                        return ""
                    }
                }(), separator: "")
                #endif
                if let group = self.currentGroup.next {
                    self.currentGroup = group
                    self.loadCurrentGroup()
                } else {
                    self.finished = true
                }
            }
        }
    }
}

final class ResourceLoadingSystem: System {
    private var done: Bool = false
    private var loader: ResourceLoader?
    
    override func setup(game: Game, input: HID) async {
        self.loader = ResourceLoader()
        self.loader!.start()
    }
    
    @inline(__always) override func shouldUpdate(game: Game, input: HID, withTimePassed deltaTime: Float) async -> Bool {
        return !done
    }
    
    override func update(game: Game, input: HID, withTimePassed deltaTime: Float) async {
        self.loader!.loadNextIfFinished()
        if let err = self.loader!.error {
            print("Error occurred: \(err)")
            self.done = true
        }
        if self.loader!.finished {
            self.done = true
        }
    }
    
    override class var phase: System.Phase { .updating }
}

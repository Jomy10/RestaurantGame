//
//  GroupedComponent.swift
//  
//
//  Created by Jonas Everaert on 21/05/2023.
//

import GateEngine

final class GroupedComponent: Component {
    var components: ContiguousArray<Entity>
    
    static let componentID = ComponentID()
    
    required init() {
        self.components = []
    }
}

/// Transforms a (possible) group of entities with the same function
func transformObjects(_ ent: Entity, _ confTrans: (inout Transform3Component) -> ()) {
    if let group = ent.component(ofType: GroupedComponent.self) {
        group.components.forEach { entity in
            entity.configure(Transform3Component.self, confTrans)
        }
    }
    
    ent.configure(Transform3Component.self, confTrans)
}

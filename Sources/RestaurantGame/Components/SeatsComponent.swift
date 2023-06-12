//
//  SeatsComponent.swift
//  
//
//  Created by Jonas Everaert on 12/06/2023.
//

import GateEngine

final class SeatsComponent: Component {
    static var componentID = GateEngine.ComponentID()
   
    typealias Seat = (position: GridPos, occupied: Bool)
    var seats: [Seat]
    
    init() {
        self.seats = []
    }
    
    init(_ seats: [Seat]) {
        self.seats = seats
    }
}

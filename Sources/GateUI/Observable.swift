//
//  Observable.swift
//  
//
//  Created by Jonas Everaert on 23/05/2023.
//

import Foundation

// TODO: transform to the inner class
public final class Observable<Element> {
    private var changedIds: [UUID:Bool]
    private var wrappedValue: Element
    
    public init(_ value: Element) {
        self.wrappedValue = value
        self.changedIds = [:]
    }
    
    fileprivate func addObservingId(_ id: UUID) {
        self.changedIds[id] = false
    }
   
    @inline(__always)
    public var value: Element {
        get {
            self.wrappedValue
        }
        set {
            self.wrappedValue = newValue
            for idx in self.changedIds.indices {
                self.changedIds.values[idx] = true
            }
        }
    }
    
    fileprivate func hasChanged(_ id: UUID) -> Bool {
        if self.changedIds[id] ?? false {
            self.changedIds[id] = false
            return true
        } else {
            return false
        }
    }
    
    public var observed: Observed<Element> {
        let observed = Observed(self)
        self.addObservingId(observed.id)
        return observed
    }
}

// Separate from Observable to prevent confusion
public struct Observed<Element> {
    private var inner: Observable<Element>
    internal var id: UUID
    
    fileprivate init(_ inner: Observable<Element>) {
        self.inner = inner
        self.id = UUID()
    }
   
    @inline(__always)
    public var value: Element {
        get {
            self.inner.value
        }
        set {
            self.inner.value = newValue
        }
    }
    
    @inline(__always)
    public func changed(_ cb: (Element) -> ()) {
        if self.inner.hasChanged(self.id) {
            print("Value has changed: ", self.value)
            cb(self.value)
        }
    }
   
    public var reObserved: Self {
        var newObservable = self
        newObservable.id = UUID()
        self.inner.addObservingId(newObservable.id)
        return newObservable
    }
}

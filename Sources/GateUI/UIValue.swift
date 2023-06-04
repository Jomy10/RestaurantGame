//
//  UIView.swift
//  
//
//  Created by Jonas Everaert on 24/05/2023.
//

public enum UIValue<Element> {
    case observable(Observed<Element>)
    case value(Element)
}

extension UIValue {
    public var value: Element {
        switch self {
        case .observable(let obs):
            return obs.value
        case .value(let elem):
            return elem
        }
    }
}

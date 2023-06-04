//
//  unreachable.swift
//  
//
//  Created by Jonas Everaert on 04/06/2023.
//

@_transparent func unreachable() -> Never {
    #if DEBUG
    fatalError("Unreachable reached", file: #file, line: #line)
    #else
    return unsafeBitCast((), to: Never.self)
    #endif
}

@_transparent func unreachable(msg: @autoclosure () -> String = "Unreachable reached") -> Never {
    #if DEBUG
    fatalError(msg(), file: #file, line: #line)
    #else
    return unsafeBitCast((), to: Never.self)
    #endif
}

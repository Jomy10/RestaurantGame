//
//  .swift
//  
//
//  Created by Jonas Everaert on 04/06/2023.
//

enum KeyboardLayout {
    case AZERTY(_ locale: KeyboardLocale? = nil)
    case QWERTY(_ locale: KeyboardLocale? = nil)
    case Dvorak(_ locale: KeyboardLocale? = nil)
}

enum KeyboardLocale {
    case BE
    case FR
    case EN
}

// allow regex in switch case
fileprivate func ~=(regex: Regex<Substring>, str: String) -> Bool {
    // errors count as "not match"
    (try? regex.wholeMatch(in: str)) != nil
}

extension KeyboardLayout {
    static lazy var detectOnce: Self? {
        Self.detect
    }
    
    static var detect: Self? {
        #if os(macOS)
        Self.mac_detect
        #else
        return nil // unimplemented
        #endif
    }
    
    #if os(macOS)
    @_transparent private static var mac_detect: Self? {
        let layout = String(cString: mac_getKBLayout())
        let pref = "com.apple.keylayout."
        switch try! Regex(#"/com.apple.keylayout.(?<layout>[\w-\d]+)"#))["layout"]!.range! {
        case "Belgian":
            return .AZERTY(.BE)
        case try! Regex(#"French.*"#):
            return .AZERTY(.FR)
        }
        if layout.contains("AZERTY") {
            return .AZERTY(nil)
        } else if layout.contains("QWERTY") {
            return .QWERTY(nil)
        } else if layout.contains("DVORAK") {
            return .Dvorak(nil)
        }
       
        // Couldn't detect keyboard layout
        return nil
    }
    #endif
}

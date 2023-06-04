//
//  keyboardLayout.swift
//  
//
//  Created by Jonas Everaert on 04/06/2023.
//

#if os(macOS)
import KeyboardLayout_mac

import Foundation //NSRegularExpression
#endif

public enum KeyboardLayout {
    case AZERTY(_ locale: KeyboardLocale? = nil)
    case QWERTY(_ locale: KeyboardLocale? = nil)
    case Dvorak(_ locale: KeyboardLocale? = nil)
}

public enum KeyboardLocale {
    case BE
    case FR
    case EN
}

// allow regex in switch case
@available(macOS 13.0, *)
fileprivate func ~=(regex: Regex<Substring>, str: String) -> Bool {
    // errors count as "not match"
    (try? regex.wholeMatch(in: str)) != nil
}

#if os(macOS)
// macOS < 13
fileprivate func ~=(regex: NSRegularExpression, str: String) -> Bool {
    let range = NSRange(location: 0, length: str.count)
    return regex.firstMatch(in: str, options: [], range: range) != nil
}

fileprivate func ~=(regex: RegexMatchSwitch, str: String) -> Bool {
    regex.matches(str)
}

struct RegexMatchSwitch {
    let regex: String
    init(_ r: String) {
        self.regex = r
    }
    
    func matches(_ s: String) -> Bool {
        if #available(macOS 13.0, *) {
            return ((try! Regex(self.regex)) ~= s)
        } else {
            return ((try! NSRegularExpression(pattern: self.regex)) ~= s)
        }
    }
}

#endif

extension KeyboardLayout {
    public static var detectOnce: Self? = {
        Self.detect
    }()
    
    public static var detect: Self? {
        #if os(macOS)
        Self.mac_detect
        #else
        // TODO: Windows & Linux
        return nil // unimplemented
        #endif
    }
    
    #if os(macOS)
    @_transparent private static var mac_detect: Self? {
        let layout = String(cString: mac_getKBLayout())
            .replacingOccurrences(of: "com.apple.keylayout.", with: "")
        
//        let frRegexPat = #"French.*"#
//        #if canImport(Foundation.Regex)
//        let frenchRegex: Regex<Substring> = try! Regex(frRegexPat)
//        #else
//        let frenchRegex = try! NSRegularExpression(pattern: frRegexPat)
//        #endif
        
        switch layout {
        case "Belgian":
            return .AZERTY(.BE)
        case RegexMatchSwitch(#"French.*"#):
            return .AZERTY(.FR)
        default: break
        }
        
        // Default cases
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

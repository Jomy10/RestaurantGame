//
//  transform.swift
//  
//
//  Created by Jonas Everaert on 04/06/2023.
//

import GateEngine

extension KeyboardLayout {
    public func transform(key: KeyboardKey) -> KeyboardKey {
        switch self {
        case .AZERTY(_):
            // TODO: locale
            switch key {
            //case .character(_, _):
            case .character(let character, let l):
                if let char = characterFromAZERTYToQWERTY(character) {
                    return .character(char, l)
                } else {
                    return key
                }
            default: return key
            }
        case .QWERTY(_):
            // TODO: locale
            return key
        case .Dvorak(_):
            print("unimplemented")
            return key
        }
    }
}

// This is currently on French azerty
fileprivate func characterFromAZERTYToQWERTY(_ char: Character) -> Character? {
    switch char {
        // thank you kind soul: https://github.com/mungadunga/azerty-to-qwerty/blob/main/src/replacements.ts
        // TODO: check which ones aren't needed
       case "²": return "`"
       case "&": return "1"
       case "1": return "!"
       case "é": return "2"
       case "2": return "@"
       case "\"": return "3"
       case "3": return "#"
       case "'": return "4"
       case "4": return "$"
       case "(": return "5"
       case "5": return "%"
       case "-": return "6"
       case "6": return "^"
       case "è": return "7"
       case "7": return "&"
       case "_": return "8"
       case "8": return "*"
       case "ç": return "9"
       case "9": return "("
       case "à": return "0"
       case "0": return ")"
       case ")": return "-"
       case "°": return "_"
       case "=": return "="
       case "+": return "+"
       case "a": return "q"
       case "A": return "Q"
       case "z": return "w"
       case "Z": return "W"
       case "e": return "e"
       case "E": return "E"
       case "r": return "r"
       case "R": return "R"
       case "t": return "t"
       case "T": return "T"
       case "y": return "y"
       case "Y": return "Y"
       case "u": return "u"
       case "U": return "U"
       case "i": return "i"
       case "I": return "I"
       case "o": return "o"
       case "O": return "O"
       case "p": return "p"
       case "P": return "P"
       case "^": return "["
       case "¨": return "{"
       case "$": return "]"
       case "£": return "}"
       case "*": return "\\"
       case "µ": return "|"
       case "q": return "a"
       case "Q": return "A"
       case "s": return "s"
       case "S": return "S"
       case "d": return "d"
       case "D": return "D"
       case "f": return "f"
       case "F": return "F"
       case "g": return "g"
       case "G": return "G"
       case "h": return "h"
       case "H": return "H"
       case "j": return "j"
       case "J": return "J"
       case "k": return "k"
       case "K": return "K"
       case "l": return "l"
       case "L": return "L"
       case "m": return ";"
       case "M": return ":"
       case "ù": return "'"
       case "%": return "\""
       case "w": return "z"
       case "x": return "x"
       case "c": return "c"
       case "v": return "v"
       case "b": return "b"
       case "n": return "n"
       case ",": return "m"
       case "?": return "M"
       case ";": return ","
       case ".": return "<"
       case ":": return "."
       case "/": return ">"
       case "!": return "/"
       case "§": return "?"
       case " ": return " "
    
    default: return nil
    }
}

//
//  DDHotKeyTranslation.swift
//  DDHotKey
//
//  Created by Dave DeLong on 8/28/19.
//

import Cocoa
import Carbon

fileprivate let standardModifiers: Dictionary<Int, NSEvent.ModifierFlags> = [
    kVK_Option: .option,
    kVK_Shift: .shift,
    kVK_Command: .command,
    kVK_Control: .control
]

internal func keyCodeAndModifiers(from string: String) -> (CGKeyCode, NSEvent.ModifierFlags)? {
    var flags = NSEvent.ModifierFlags()
    var keyCode: Int?
    
    for character in string {
        guard let code = keycode(for: String(character)) else { return nil }
        if let modifier = standardModifiers[code] {
            flags.insert(modifier)
        } else if keyCode == nil {
            keyCode = code
        } else {
            return nil
        }
    }
    
    guard let code = keyCode else { return nil }
    
    return (CGKeyCode(code), flags)
}

internal func stringFrom(keyCode: CGKeyCode, modifiers: NSEvent.ModifierFlags) -> String {
    var final = ""
    if modifiers.contains(.control) {
        final += string(for: kVK_Control)!
    }
    if modifiers.contains(.option) {
        final += string(for: kVK_Option)!
    }
    if modifiers.contains(.shift) {
        final += string(for: kVK_Shift)!
    }
    if modifiers.contains(.command) {
        final += string(for: kVK_Command)!
    }
    
    if standardModifiers[Int(keyCode)] != nil { return final }
    
    if let mapped = string(for: Int(keyCode), carbonModifiers: carbonModifiers(from: modifiers)) {
        final += mapped
    }
    return final
}

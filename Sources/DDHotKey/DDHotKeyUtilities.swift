//
//  DDHotKeyUtilities.swift
//  DDHotKey
//
//  Created by Dave DeLong on 8/28/19.
//

import Carbon
import Cocoa

internal extension OSType {
    
    init(fourCharCode: String) {
        
        let scalars = Array(fourCharCode.unicodeScalars)[0 ..< 4]
        var sum: UInt32 = 0
        for scalar in scalars {
            sum = (sum << 8) + scalar.value
        }
        self = sum
    }
    
}

fileprivate let characterMap: Dictionary<Int, String> = [
    kVK_Return: "↩",
    kVK_Tab: "⇥",
    kVK_Space: "⎵",
    kVK_Delete: "⌫",
    kVK_Escape: "⎋",
    kVK_Command: "⌘",
    kVK_Shift: "⇧",
    kVK_CapsLock: "⇪",
    kVK_Option: "⌥",
    kVK_Control: "⌃",
    kVK_RightShift: "⇧",
    kVK_RightOption: "⌥",
    kVK_RightControl: "⌃",
    kVK_VolumeUp: "🔊",
    kVK_VolumeDown: "🔈",
    kVK_Mute: "🔇",
    kVK_Function: "\u{2318}",
    kVK_F1: "F1",
    kVK_F2: "F2",
    kVK_F3: "F3",
    kVK_F4: "F4",
    kVK_F5: "F5",
    kVK_F6: "F6",
    kVK_F7: "F7",
    kVK_F8: "F8",
    kVK_F9: "F9",
    kVK_F10: "F10",
    kVK_F11: "F11",
    kVK_F12: "F12",
    kVK_F13: "F13",
    kVK_F14: "F14",
    kVK_F15: "F15",
    kVK_F16: "F16",
    kVK_F17: "F17",
    kVK_F18: "F18",
    kVK_F19: "F19",
    kVK_F20: "F20",
    //                       kVK_Help: "",
    kVK_ForwardDelete: "⌦",
    kVK_Home: "↖",
    kVK_End: "↘",
    kVK_PageUp: "⇞",
    kVK_PageDown: "⇟",
    kVK_LeftArrow: "←",
    kVK_RightArrow: "→",
    kVK_DownArrow: "↓",
    kVK_UpArrow: "↑",
]

internal func carbonModifiers(from cocoaModifiers: NSEvent.ModifierFlags) -> UInt32 {
    var newFlags: Int = 0
    if cocoaModifiers.contains(.control) { newFlags |= controlKey }
    if cocoaModifiers.contains(.command) { newFlags |= cmdKey }
    if cocoaModifiers.contains(.shift) { newFlags |= shiftKey }
    if cocoaModifiers.contains(.option) { newFlags |= optionKey }
    if cocoaModifiers.contains(.capsLock) { newFlags |= alphaLock }
    return UInt32(newFlags)
}

fileprivate let keycodesToCharacters: Dictionary<Int, String> = {
    var map = characterMap
    for code in 0 ..< 65536 {
        if map[code] != nil { continue }
        if let character = string(for: code, useCache: false) {
            map[code] = character
        }
    }
    return map
}()

fileprivate let charactersToKeycodes: Dictionary<String, Int> = {
    var map = Dictionary<String, Int>(minimumCapacity: keycodesToCharacters.count)
    for (code, string) in keycodesToCharacters {
        map[string] = code
    }
    return map
}()

fileprivate let layoutData: CFData? = {
    var currentKeyboard = TISCopyCurrentKeyboardInputSource()?.takeRetainedValue()
    if currentKeyboard == nil {
        currentKeyboard = TISCopyCurrentASCIICapableKeyboardInputSource()?.takeRetainedValue()
    }
    guard let keyboard = currentKeyboard else { return nil }
    
    guard let ptr = TISGetInputSourceProperty(keyboard, kTISPropertyUnicodeKeyLayoutData) else { return nil }
    return Unmanaged<CFData>.fromOpaque(ptr).takeUnretainedValue()
}()

internal func string(for keyCode: Int, carbonModifiers: UInt32 = UInt32(alphaLock >> 8), useCache: Bool = true) -> String? {
    if useCache == true {
        if let mapped = keycodesToCharacters[keyCode] { return mapped }
    }
    
    guard let data = layoutData else { return nil }
    guard let bytePtr = CFDataGetBytePtr(data) else { return nil }
    
    var deadKeyState: UInt32 = 0
    var actualStringLength: Int = 0
    var characters = Array<UniChar>(repeating: 0, count: 255)
    
    let status = bytePtr.withMemoryRebound(to: UCKeyboardLayout.self, capacity: 1) { pointer -> OSStatus in
        return UCKeyTranslate(pointer,
                              UInt16(keyCode), UInt16(kUCKeyActionDown), carbonModifiers,
                              UInt32(LMGetKbdType()), 0,
                              &deadKeyState, 255,
                              &actualStringLength, &characters)
    }
    
    guard status == noErr else { return nil }
    guard actualStringLength > 0 else { return nil }
    return String(utf16CodeUnits: &characters, count: actualStringLength)
}

internal func keycode(for string: String) -> Int? {
    return charactersToKeycodes[string]
}

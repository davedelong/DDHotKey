//
//  DDHotKey.swift
//  DDHotKey
//
//  Created by Dave DeLong on 8/28/19.
//

import Cocoa
import Carbon

public class DDHotKey {
    internal var hotKeyID: UInt32?
    internal var hotKeyRef: EventHotKeyRef?
    
    internal let uuid = UUID()
    internal let keyCode: CGKeyCode
    internal let modifiers: NSEvent.ModifierFlags
    internal let handler: (NSEvent) -> Void
    
    public init(keyCode: CGKeyCode, modifiers: NSEvent.ModifierFlags, handler: @escaping (NSEvent) -> Void) {
        self.keyCode = keyCode
        self.modifiers = modifiers
        self.handler = handler
    }
    
    public convenience init?(shortcut: String, handler: @escaping (NSEvent) -> Void) {
        guard let (keyCode, modifiers) = keyCodeAndModifiers(from: shortcut) else {
            return nil
        }
        
        self.init(keyCode: keyCode, modifiers: modifiers, handler: handler)
    }
    
    internal func invoke(with event: NSEvent) {
        handler(event)
    }
}

public struct DDHotKeyOld: Hashable {
    var hotKeyID: UInt32 = 0
    var keyCode: UInt16 = 0
    var text = "Hello, World!"
    
    func invoke(with event: NSEvent) -> OSStatus {
        return noErr
    }
}


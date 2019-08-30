//
//  DDHotKeyCenter.swift
//  DDHotKey
//
//  Created by Dave DeLong on 8/28/19.
//

import Cocoa
import Carbon

public class DDHotKeyCenter {

    public enum RegistrationError: Error {
        case alreadyRegistered
        case tooManyHotKeys
        case conflictsWithExistingHotKey(DDHotKey)
        case unableToRegisterHotKey(OSStatus)
    }
    
    public enum UnregistrationError: Error {
        case notRegistered
        case unknownHotKey
        case unableToUnregisterHotKey(OSStatus)
    }
    
    public static let shared = DDHotKeyCenter()
    
    private var registered = Dictionary<UUID, DDHotKey>()
    private var nextID: UInt32 = 1
    
    private init() {
        
        var spec = EventTypeSpec()
        spec.eventClass = OSType(kEventClassKeyboard)
        spec.eventKind = UInt32(kEventHotKeyReleased)
        InstallEventHandler(GetApplicationEventTarget(),
                            handler,
                            1,
                            &spec,
                            nil,
                            nil)
    }
    
    internal func hotKeysMatching(_ filter: (DDHotKey) -> Bool) -> Array<DDHotKey> {
        return registered.values.filter(filter)
    }
    
    public func registeredHotKeys() -> Array<DDHotKey> {
        return Array(registered.values)
    }
    
    public func register(hotKey: DDHotKey) throws /* RegistrationError */ {
        // cannot register a hot key that is already registered
        if hotKey.hotKeyID != nil {
            throw RegistrationError.alreadyRegistered
        }
        
        guard nextID < UInt32.max else {
            throw RegistrationError.tooManyHotKeys
        }
        
        // cannot register a hot key that has the same invocation as an existing hotkey
        let matching = registered.values.filter { $0.keyCode == hotKey.keyCode && $0.modifiers == hotKey.modifiers }
        if matching.isEmpty == false {
            throw RegistrationError.conflictsWithExistingHotKey(matching[0])
        }
        
        let hotKeyID = EventHotKeyID(signature: OSType(fourCharCode: "htk1"), id: nextID)
        let flags = carbonModifiers(from: hotKey.modifiers)
        
        var hotKeyRef: EventHotKeyRef?
        let error = RegisterEventHotKey(UInt32(hotKey.keyCode), flags, hotKeyID, GetEventDispatcherTarget(), 0, &hotKeyRef)
        
        if error != noErr {
            throw RegistrationError.unableToRegisterHotKey(error)
        }
        
        hotKey.hotKeyRef = hotKeyRef
        hotKey.hotKeyID = nextID
        registered[hotKey.uuid] = hotKey
        
        nextID += 1
    }
    
    public func unregister(hotKey: DDHotKey) throws /* UnregistrationError */ {
        guard let ref = hotKey.hotKeyRef, hotKey.hotKeyID != nil else {
            throw UnregistrationError.notRegistered
        }
        
        guard let existing = registered[hotKey.uuid], existing === hotKey else {
            throw UnregistrationError.unknownHotKey
        }
        
        let status = UnregisterEventHotKey(ref)
        
        guard status == noErr else {
            throw UnregistrationError.unableToUnregisterHotKey(status)
        }
        
        registered.removeValue(forKey: hotKey.uuid)
    }
}


fileprivate var handler: EventHandlerProcPtr = { (callRef, eventRef, context) -> OSStatus in
    return autoreleasepool { () -> OSStatus in
        var hotKeyID = EventHotKeyID()
        GetEventParameter(eventRef,
                          EventParamName(kEventParamDirectObject),
                          EventParamType(typeEventHotKeyID),
                          nil,
                          MemoryLayout<EventHotKeyID>.size,
                          nil,
                          &hotKeyID);
        
        let keyID = hotKeyID.id
        let matches = DDHotKeyCenter.shared.hotKeysMatching { $0.hotKeyID == keyID }
        if matches.count != 1 {
            print("Unable to find a single hotkey with id \(keyID)")
            return OSStatus(errAborted)
        }
        let matching = matches[matches.startIndex]
        
        guard let ref = eventRef else {
            print("Missing EventRef to handle hotkey with id \(keyID)")
            return OSStatus(errAborted)
        }
        
        guard let event = NSEvent(eventRef: UnsafeRawPointer(ref)) else {
            print("Unable to create NSEvent from EventRef \(ref) for the hotkey with id \(keyID)")
            return OSStatus(errAborted)
        }
        
        let keyEvent = NSEvent.keyEvent(with: .keyUp,
                                        location: event.locationInWindow,
                                        modifierFlags: event.modifierFlags,
                                        timestamp: event.timestamp,
                                        windowNumber: -1,
                                        context: nil,
                                        characters: "",
                                        charactersIgnoringModifiers: "",
                                        isARepeat: false,
                                        keyCode: matching.keyCode)
        
        guard let key = keyEvent else {
            print("Unable to create key event from NSEvent \(event) for the hotkey with id \(keyID)")
            return OSStatus(errAborted)
        }
        
        matching.invoke(with: key)
        return noErr
    }
    
}

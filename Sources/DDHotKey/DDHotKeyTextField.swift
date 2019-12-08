//
//  DDHotKeyTextField.swift
//  
//
//  Created by Dave DeLong on 12/8/19.
//

#if canImport(AppKit)

import AppKit
import Carbon

fileprivate let DDFieldEditor: DDHotKeyTextFieldEditor = {
    let editor = DDHotKeyTextFieldEditor(frame: NSRect(x: 0, y: 0, width: 100, height: 32))
    editor.isFieldEditor = true
    return editor
}()

open class DDHotKeyTextField: NSTextField {
    
    open override class var cellClass: AnyClass? {
        get { return DDHotKeyTextFieldCell.self }
        set { super.cellClass = DDHotKeyTextFieldCell.self }
    }
    
    public var hotKey: DDHotKey? {
        didSet {
            super.stringValue = ""
        }
    }
    
    open override var stringValue: String {
        get {
            print("DDHotKeyTextField.stringValue is not what you want. Use DDHotKeyTextField.hotKey instead.")
            return super.stringValue
        }
        set {
            print("DDHotKeyTextField.stringValue is not what you want. Use DDHotKeyTextField.hotKey instead.")
            super.stringValue = newValue
        }
    }
    
}

private class DDHotKeyTextFieldCell: NSTextFieldCell {
    
    override func fieldEditor(for controlView: NSView) -> NSTextView? {
        guard let hkField = controlView as? DDHotKeyTextField else { return nil }
        
        let editor = DDFieldEditor
        editor.insertionPointColor = editor.backgroundColor
        editor.hotKeyField = hkField
        return editor
    }
    
}

fileprivate class DDHotKeyTextFieldEditor: NSTextView {
    private var hasSeenKeyDown: Bool = false
    private var globalMonitor: Any?
    private var originalHotKey: DDHotKey?
    
    weak var hotKeyField: DDHotKeyTextField? {
        didSet {
            originalHotKey = hotKeyField?.hotKey
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        guard super.becomeFirstResponder() else { return false }
        
        hasSeenKeyDown = false
        globalMonitor = NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .flagsChanged], handler: self.processHotKeyEvent(_:))
        
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        guard super.resignFirstResponder() else { return false }
        hasSeenKeyDown = false
        hotKeyField = nil
        if let m = globalMonitor {
            NSEvent.removeMonitor(m)
            globalMonitor = nil
        }
        return true
    }
    
    private func processHotKeyEvent(_ event: NSEvent) -> NSEvent? {
        let flags = event.modifierFlags
        let hasModifier = flags.contains(.command) || flags.contains(.option) || flags.contains(.control) || flags.contains(.shift) || flags.contains(.function)
        
        if event.type == .keyDown {
            hasSeenKeyDown = true
            let char = event.charactersIgnoringModifiers?.first
            
            if hasModifier == false && (char?.isNewline == true || event.keyCode == Int16(kVK_Escape)) {
                if event.keyCode == Int16(kVK_Escape) {
                    hotKeyField?.hotKey = originalHotKey
                    
                    let str = stringFrom(keyCode: event.keyCode, modifiers: flags)
                    textStorage?.mutableString.setString(str.uppercased())
                }
                
                hotKeyField?.sendAction(hotKeyField?.action, to: hotKeyField?.target)
                window?.makeFirstResponder(nil)
            }
        }
        
        if hasModifier && (event.type == .keyDown || (event.type == .flagsChanged && hasSeenKeyDown == false)) {
            
            hotKeyField?.hotKey = DDHotKey(keyCode: event.keyCode, modifiers: flags, handler: originalHotKey?.handler)
            
            let str = stringFrom(keyCode: event.keyCode, modifiers: flags)
            textStorage?.mutableString.setString(str.uppercased())
            hotKeyField?.sendAction(hotKeyField?.action, to: hotKeyField?.target)
        }
        
        return nil
    }
    
}

#endif

# DDHotKey

Copyright &copy; Dave DeLong <http://www.davedelong.com>

## About

DDHotKey is an easy-to-use package for registering an application to respond to system key events, or "hotkeys".

A global hotkey is a key combination that always executes a specific action, regardless of which app is frontmost.  For example, the Mac OS X default hotkey of "command-space" shows the Spotlight search bar, even if Finder is not the frontmost application.

## License

The license for this framework is included in every source file, and is repoduced in its entirety here:

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.  The software is provided "as is", without warranty of any kind, including all implied warranties of merchantability and fitness. In no event shall the authors or copyright holders be liable for any claim, damages, or other liability, whether in an action of contract, tort, or otherwise, arising from, out of, or in connection with the software or the use or other dealings in the software.

## Usage

When you wish to create a hotkey, you'll need to do so via the `DDHotKeyCenter` singleton.

All hotkeys execute a block (closure) when invoked. The block is passed an `NSEvent` object, which contains information regarding the hotkey event (such as the location, the keyCode, the modifierFlags, etc).

Any hotkey that you have registered via `DDHotKeyCenter` can be unregistered by passing the `DDHotKey` instance back to the `unregister(hotKey:)` method.

DDHotKey also includes a rudimentary `DDHotKeyTextField`: an `NSTextField` subclass that simplifies the process of creating a key combination.  Simply drop an `NSTextField` into your xib and change its class to `DDHotKeyTextField`.  Programmatically, you'll get an `NSTextField` into which you can type arbitrary key combinations.  You access the resulting combination via the textfield's `hotKey` property.

//
//  DDHotKeyAppDelegate.m
//  DDHotKey
//
//  Created by Dave DeLong on 2/24/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "DDHotKeyAppDelegate.h"
#import "DDHotKeyCenter.h"

@implementation DDHotKeyAppDelegate

@synthesize window, output;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
}

- (void) addOutput:(NSString *)newOutput {
	NSString * current = [output string];
	[output setString:[current stringByAppendingFormat:@"%@\n", newOutput]];
	[output scrollRangeToVisible:NSMakeRange([[output string] length], 0)];
}

- (void) hotkeyWithEvent:(NSEvent *)hkEvent {
	[self addOutput:[NSString stringWithFormat:@"Firing -[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]];
	[self addOutput:[NSString stringWithFormat:@"Hotkey event: %@", hkEvent]];
}

- (void) hotkeyWithEvent:(NSEvent *)hkEvent object:(id)anObject {
	[self addOutput:[NSString stringWithFormat:@"Firing -[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]];
	[self addOutput:[NSString stringWithFormat:@"Hotkey event: %@", hkEvent]];
	[self addOutput:[NSString stringWithFormat:@"Object: %@", anObject]];
}

- (IBAction) registerExample1:(id)sender {
	[self addOutput:@"Attempting to register hotkey for example 1"];
	DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];
	if (![c registerHotKeyWithTarget:self action:@selector(hotkeyWithEvent:) object:nil keyCode:9 modifierFlags:NSControlKeyMask]) {
		[self addOutput:@"Unable to register hotkey for example 1"];
	} else {
		[self addOutput:@"Registered hotkey for example 1"];
	}
	[c release];
}

- (IBAction) registerExample2:(id)sender {
	[self addOutput:@"Attempting to register hotkey for example 2"];
	DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];
	if (![c registerHotKeyWithTarget:self action:@selector(hotkeyWithEvent:object:) object:@"hello, world!" keyCode:9 modifierFlags:(NSControlKeyMask | NSAlternateKeyMask)]) {
		[self addOutput:@"Unable to register hotkey for example 2"];
	} else {
		[self addOutput:@"Registered hotkey for example 2"];
	}
	[c release];
}

- (IBAction) registerExample3:(id)sender {
	[self addOutput:@"Attempting to register hotkey for example 3"];
	DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];
	int theAnswer = 42;
	DDHotKeyTask task = ^(NSEvent *hkEvent) {
		[self addOutput:@"Firing block hotkey"];
		[self addOutput:[NSString stringWithFormat:@"Hotkey event: %@", hkEvent]];
		[self addOutput:[NSString stringWithFormat:@"the answer is: %d", theAnswer]];	
	};
	if (![c registerHotKeyWithBlock:task keyCode:9 modifierFlags:(NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask)]) {
		[self addOutput:@"Unable to register hotkey for example 3"];
	} else {
		[self addOutput:@"Registered hotkey for example 3"];
	}
	[c release];
}

- (IBAction) unregisterExample1:(id)sender {
	DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];
	[c unregisterHotKeyWithKeyCode:9 modifierFlags:NSControlKeyMask];
	[self addOutput:@"Unregistered hotkey for example 1"];
	[c release];
}

- (IBAction) unregisterExample2:(id)sender {
	DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];
	[c unregisterHotKeyWithKeyCode:9 modifierFlags:(NSControlKeyMask | NSAlternateKeyMask)];
	[self addOutput:@"Unregistered hotkey for example 2"];
	[c release];
}

- (IBAction) unregisterExample3:(id)sender {
	DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];
	[c unregisterHotKeyWithKeyCode:9 modifierFlags:(NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask)];
	[self addOutput:@"Unregistered hotkey for example 3"];
	[c release];
}

@end

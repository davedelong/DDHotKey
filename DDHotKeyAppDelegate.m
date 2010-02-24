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

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	
	DDHotKeyCenter * center = [[DDHotKeyCenter alloc] init];
	
	[center registerHotKeyWithTarget:self action:@selector(hotkeyWithEvent:) object:nil keyCode:9 modifierFlags:NSControlKeyMask];
	[center registerHotKeyWithTarget:self action:@selector(hotkeyWithEvent:object:) object:@"foo!" keyCode:9 modifierFlags:(NSControlKeyMask | NSAlternateKeyMask)];
	
	int theAnswer = 42;
	[center registerHotKeyWithBlock:^(NSEvent *hkEvent) {
		NSLog(@"Firing block hotkey");
		NSLog(@"Hotkey event: %@", hkEvent);
		NSLog(@"the answer is: %d", theAnswer);
	} keyCode:9 modifierFlags:(NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask)];
	
	[center release];
}

- (void) hotkeyWithEvent:(NSEvent *)hkEvent {
	NSLog(@"Firing -[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
	NSLog(@"Hotkey event: %@", hkEvent);
}

- (void) hotkeyWithEvent:(NSEvent *)hkEvent object:(id)anObject {
	NSLog(@"Firing -[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
	NSLog(@"Hotkey event: %@", hkEvent);
	NSLog(@"Object: %@", anObject);
}

@end

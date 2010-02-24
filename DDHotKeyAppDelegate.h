//
//  DDHotKeyAppDelegate.h
//  DDHotKey
//
//  Created by Dave DeLong on 2/24/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DDHotKeyAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	NSTextView *output;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextView *output;

- (void) addOutput:(NSString *)newOutput;

- (IBAction) registerExample1:(id)sender;
- (IBAction) registerExample2:(id)sender;
- (IBAction) registerExample3:(id)sender;

- (IBAction) unregisterExample1:(id)sender;
- (IBAction) unregisterExample2:(id)sender;
- (IBAction) unregisterExample3:(id)sender;

@end

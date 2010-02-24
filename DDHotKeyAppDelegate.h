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
}

@property (assign) IBOutlet NSWindow *window;

@end

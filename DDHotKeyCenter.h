//
//  DDHotKeyManager.h
//  EmptyAppKit
//
//  Created by Dave DeLong on 2/20/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define BUILD_FOR_SNOWLEOPARD (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_6)

#if BUILD_FOR_SNOWLEOPARD
typedef void (^DDHotKeyTask)(NSEvent*);
#endif

@interface DDHotKeyCenter : NSObject {

}

- (BOOL) registerHotKeyWithTarget:(id)target action:(SEL)action object:(id)object keyCode:(unsigned short)keyCode modifierFlags:(NSUInteger)flags;

#if BUILD_FOR_SNOWLEOPARD
- (BOOL) registerHotKeyWithBlock:(DDHotKeyTask)task keyCode:(unsigned short)keyCode modifierFlags:(NSUInteger)flags;
#endif

- (BOOL) hasRegisteredHotKeyWithKeyCode:(unsigned short)keyCode modifierFlags:(NSUInteger)flags;
- (void) unregisterHotKeysWithTarget:(id)target;
- (void) unregisterHotKeyWithTarget:(id)target action:(SEL)action;
- (void) unregisterHotKeyWithKeyCode:(unsigned short)keyCode modifierFlags:(NSUInteger)flags;

@end

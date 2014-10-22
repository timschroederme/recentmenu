//
//  RMHotkeyController.m
//  Recent Menu
//
//  Created by Tim Schröder on 20.07.12.
//  Copyright (c) 2012 Tim Schroeder. All rights reserved.
//

#import "RMHotkeyController.h"
#import "RMConstants.h"
#import "DDHotKeyCenter.h"
#import <Carbon/Carbon.h>

@implementation RMHotkeyController

@synthesize delegate = _delegate;

static RMHotkeyController *_sharedController = nil;

#pragma mark -
#pragma mark Singleton Methods

+ (RMHotkeyController *)sharedController
{
	if (!_sharedController) {
        _sharedController = [[super allocWithZone:NULL] init];
    }
    return _sharedController;
}	

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedController];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


#pragma mark -
#pragma mark Hotkey methods

-(NSDictionary*)loadHotkeyPreferences
{
    NSInteger keyCode=-1;
    NSUInteger flags;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *numKeyCode = [defaults objectForKey:DEFAULTS_KEYCODE];
    NSNumber *numFlags = [defaults objectForKey:DEFAULTS_KEYFLAGS]; 
    
    if (numKeyCode != nil) {
        keyCode = [numKeyCode integerValue];
        flags = [[defaults objectForKey:DEFAULTS_KEYFLAGS] unsignedIntegerValue];
        [self updateHotkeyWithKeyCode:keyCode andFlags:flags];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:numKeyCode, @"keyCode", numFlags, @"modifierFlags" , nil];
        return dict;
    }
    return nil;
}

-(void)saveHotkeyPreferencesWithKeyCode:(NSInteger)keyCode andFlags:(NSUInteger)flags
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *numKeyCode = [NSNumber numberWithInt:keyCode];
    NSNumber *numFlags = [NSNumber numberWithUnsignedInt:flags];
    [defaults setObject:numKeyCode forKey:DEFAULTS_KEYCODE];
    [defaults setObject:numFlags forKey:DEFAULTS_KEYFLAGS];
    [defaults synchronize];
}

// Hotkey ein- oder ausschalten
-(void)updateHotkeyWithKeyCode:(NSInteger)keyCode andFlags:(NSUInteger)flags
{
    
    DDHotKeyCenter *hotKeyCenter = [[DDHotKeyCenter alloc] init];
    [hotKeyCenter unregisterHotKeysWithTarget:self.delegate];    
	if (keyCode!=-1) {
        [hotKeyCenter registerHotKeyWithKeyCode:keyCode 
                                  modifierFlags:flags 
                                         target:self.delegate
                                         action:@selector(hotkeyPressed:) 
                                         object:nil];
        
	} else {
        [hotKeyCenter unregisterHotKeysWithTarget:self];
    }
    [hotKeyCenter release];
    
}


@end

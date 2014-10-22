//
//  RMHotkeyController.h
//  Recent Menu
//
//  Created by Tim Schröder on 20.07.12.
//  Copyright (c) 2012 Tim Schroeder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMHotkeyController : NSObject

+ (RMHotkeyController *)sharedController;

-(NSDictionary*)loadHotkeyPreferences;
-(void)saveHotkeyPreferencesWithKeyCode:(NSInteger)keyCode andFlags:(NSUInteger)flags;
-(void)updateHotkeyWithKeyCode:(NSInteger)keyCode andFlags:(NSUInteger)flags;

@property (assign) id delegate;

@end

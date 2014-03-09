//
//  RMAppDelegate+Menu.h
//  Recent Menu
//
//  Created by Tim Schröder on 10.02.11.
//  Copyright 2011 Tim Schroeder. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RMAppDelegate.h"


@interface RMAppDelegate (Menu) <NSMenuDelegate, NSWindowDelegate>

-(void)showEntriesMenu;
-(void)showQueryMenu;
-(void)showSandboxMenu;
-(void)activateStatusMenu;
-(void)populateRecentMenu;


@end

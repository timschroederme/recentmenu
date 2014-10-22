//
//  RMAppDelegate.h
//  Recent Menu
//
//  Created by Tim Schröder on 09.02.11.
//  Copyright 2011 Tim Schröder. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RMImageView, RMPopoverController;

@interface RMAppDelegate : NSObject <NSApplicationDelegate> {
	
	NSStatusItem *statusItem;
	NSMenu *mainMenu;
	NSMenu *recentItemsMenu;
	NSMutableArray *queryArray;
	BOOL allQueriesFinished;
	IBOutlet NSView *menuView;
	IBOutlet NSProgressIndicator *spinningWheel;
	IBOutlet NSTextField *waitText;
    RMPopoverController *popoverController;
}

@property (strong) RMImageView *statusView;
@property (assign) BOOL sandboxAccess;

-(void) hotkeyPressed:(NSEvent*)hotKeyEvent;

@end

//
//  RMAppDelegate.m
//  Recent Menu
//
//  Created by Tim Schröder on 09.02.11.
//  Copyright 2011 Tim Schröder. All rights reserved.
//

#import "RMAppDelegate.h"
#import "RMPrefsWindowController.h"
#import "RMConstants.h"
#import "RMAppDelegate+Menu.h"
#import "RMAppDelegate+MetadataQuery.h"
#import "RMAppDelegate+UserDefaults.h"
#import "RMLaunchAtLoginController.h"
#import "RMSecurityScopedBookmarkController.h"
#import "RMHotkeyController.h"

@implementation RMAppDelegate


@synthesize statusView = _statusView, sandboxAccess;

#pragma mark -
#pragma mark Overriden Methods

- (id)init
{
    self = [super init];
    if (self) {
		queryArray = [[NSMutableArray arrayWithCapacity:0] retain];
		allQueriesFinished = NO;
    }
    return self;
}	


-(void)awakeFromNib 
{    
    // Init menu
	[self activateStatusMenu];
    
    // Init hotkeys
    [[RMHotkeyController sharedController] setDelegate:self];
	[[RMHotkeyController sharedController] loadHotkeyPreferences];
    
	[spinningWheel setUsesThreadedAnimation:YES];
    
    // Test if app is runnning sandboxed for the first time
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:DEFAULTS_SANDBOX]) {
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:DEFAULTS_SANDBOX];
        [defaults synchronize];
        if ([[RMLaunchAtLoginController sharedController] launchAtLogin]) [[RMLaunchAtLoginController sharedController] turnOnLaunchAtLogin];
    } 
        
    // Register for security-scoped bookmark notifications
    __block id self_ = self;
    [[[NSNotificationCenter defaultCenter] 
      addObserverForName: NOTIFICATION_ACCESS_GRANTED
      object: nil
      queue: [NSOperationQueue mainQueue]
      usingBlock: ^(NSNotification * notification) {
          [[RMPrefsWindowController sharedPrefsWindowController] setAccessButtonTitleToRevoke];
          [self_ startAllQueries];
          self.sandboxAccess = YES;
      }] retain];

    [[[NSNotificationCenter defaultCenter]
      addObserverForName: NOTIFICATION_ACCESS_REMOVED
      object: nil
      queue: [NSOperationQueue mainQueue]
      usingBlock: ^(NSNotification * notification) {
          [self_ showSandboxMenu];
          self.sandboxAccess = NO;
      }] retain];

    // Test if we have a security-scoped bookmark
    if (![[RMSecurityScopedBookmarkController sharedController] hasBookmark]) {
        [self showSandboxMenu];
        self.sandboxAccess = NO;
        [NSApp activateIgnoringOtherApps:YES];
        [[RMPrefsWindowController sharedPrefsWindowController] showGeneralPrefsPane];
        [[RMPrefsWindowController sharedPrefsWindowController] setAccessButtonTitleToGrant];
        
        // No, show info that we would need that
        [[RMPrefsWindowController sharedPrefsWindowController] showNeedsAccessRightsAlert];
    } else {
        [[RMSecurityScopedBookmarkController sharedController] startAccessingSecurityScopedBookmark];
        self.sandboxAccess = YES;
        
        // Start Queries
        [self startAllQueries];
    }
}

-(void)applicationWillTerminate:(NSNotification *)notification
{
    [[RMSecurityScopedBookmarkController sharedController] stopAccessingSecurityScopedBookmark];
}

-(void)dealloc
{
	[statusItem release];
	[recentItemsMenu release];
	[mainMenu release];
	[queryArray release];
	[super dealloc];
}

#pragma mark -
#pragma mark User Actions

-(IBAction) showPreferences:(id)sender
{
	[NSApp activateIgnoringOtherApps:YES];
	[[RMPrefsWindowController sharedPrefsWindowController] showWindow:self];
}

-(IBAction) showHelp:(id)sender
{
	[NSApp activateIgnoringOtherApps:YES];
}

-(IBAction) showAbout:(id)sender
{
	[NSApp activateIgnoringOtherApps:YES];
	[NSApp orderFrontStandardAboutPanel:self];
}

-(void) hotkeyPressed:(NSEvent*)hotKeyEvent
{
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    [statusItem popUpStatusItemMenu:mainMenu];
} 


@end


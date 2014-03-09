//
//  RMAppDelegate+Menu.m
//  Recent Menu
//
//  Created by Tim Schröder on 10.02.11.
//  Copyright 2011 Tim Schroeder. All rights reserved.
//

#import "RMAppDelegate+Menu.h"
#import "RMConstants.h"
#import "RMAppDelegate+UserDefaults.h"
#import "RMSecurityScopedBookmarkController.h"


@implementation RMAppDelegate (Menu)

#pragma mark -
#pragma mark NSMenu Delegate Methods

- (void)menuNeedsUpdate:(NSMenu *)menu
{
	if (!allQueriesFinished) {
		if ([[RMSecurityScopedBookmarkController sharedController] hasBookmark]) [self showQueryMenu];
	}
	[self populateRecentMenu];
}

- (void)menuWillOpen:(NSMenu *)menu
{
    [[NSRunLoop currentRunLoop] performSelector:@selector(startAnimation:) target:spinningWheel argument:self order:0 modes:[NSArray arrayWithObject:NSEventTrackingRunLoopMode]];
}

#pragma mark -
#pragma mark Menu Action Methods

-(IBAction)click:(id)sender
{
	NSString *path = [sender representedObject];
	NSURL *pathURL = [NSURL fileURLWithPath:path];
	if (pathURL == nil) return; 
	
	if ([sender isAlternate]) {
		// Show in Finder
		[[NSWorkspace sharedWorkspace] selectFile:path inFileViewerRootedAtPath:nil];
	} else {
		// Launch default app
		[[NSWorkspace sharedWorkspace] openURL:pathURL];
	}
}


#pragma mark -
#pragma mark Menu Activation Methods

-(void)showEntriesMenu
{
    while ([mainMenu numberOfItems]>numberOfGlobalItems) {
        [mainMenu removeItemAtIndex:0];
    }
}

-(void)showQueryMenu
{
    [spinningWheel stopAnimation:self];
    while ([mainMenu numberOfItems]>numberOfGlobalItems) {
        [mainMenu removeItemAtIndex:0];
    }
    NSMenuItem *newItem = [mainMenu insertItemWithTitle:@""
                                                 action:nil
                                          keyEquivalent:@""
                                                atIndex:([mainMenu numberOfItems]-numberOfGlobalItems)];
    [mainMenu insertItem:[NSMenuItem separatorItem] atIndex:([mainMenu numberOfItems]-numberOfGlobalItems)];
    [waitText setStringValue:MENU_WAITNOTICE];
    [newItem setEnabled:NO];
    [newItem setView:menuView];
    [spinningWheel setHidden:NO];
    [[NSRunLoop currentRunLoop] performSelector:@selector(startAnimation:) target:spinningWheel argument:self order:0 modes:[NSArray arrayWithObject:NSEventTrackingRunLoopMode]];
}

-(void)showSandboxMenu
{
    while ([mainMenu numberOfItems]>numberOfGlobalItems) {
        [mainMenu removeItemAtIndex:0];
    }
    //[spinningWheel stopAnimation:self];
    [spinningWheel setHidden:YES];
    NSMenuItem *newItem = [mainMenu insertItemWithTitle:@""
                                                 action:nil
                                          keyEquivalent:@""
                                                atIndex:([mainMenu numberOfItems]-numberOfGlobalItems)];
    [mainMenu insertItem:[NSMenuItem separatorItem] atIndex:([mainMenu numberOfItems]-numberOfGlobalItems)];
    [newItem setView:menuView];
    [waitText setStringValue:MENU_SANDBOXNOTICE];
    [newItem setEnabled:NO];
}


#pragma mark -
#pragma mark Menu Population Methods

// Initialisierung des Menu Items
-(void) activateStatusMenu
{
	// Ggf. StatusMenu erzeugen
	if (!statusItem) {
		NSStatusBar *bar = [NSStatusBar systemStatusBar];
		statusItem = [bar statusItemWithLength:NSSquareStatusItemLength];
		[statusItem retain];
        [statusItem setHighlightMode:YES];
        [statusItem setImage:[NSImage imageNamed:@"menuitem.png"]];
        [statusItem setAlternateImage:[NSImage imageNamed:@"menuitem-alternate.png"]];
    }
	if (!mainMenu) {
		mainMenu = [[NSMenu alloc] initWithTitle:@""];
				
		[mainMenu insertItemWithTitle:MENU_QUIT 
							   action:@selector (terminate:)
						keyEquivalent:@""
							  atIndex:0];
		
		[mainMenu insertItemWithTitle:MENU_ABOUT 
							   action:@selector (showAbout:)
						keyEquivalent:@""
							  atIndex:0];
        
		[mainMenu insertItemWithTitle:MENU_HELP 
							   action:@selector (showHelp:)
						keyEquivalent:@""
							  atIndex:0];
		[mainMenu insertItemWithTitle:MENU_PREFERENCES 
							   action:@selector (showPreferences:)
						keyEquivalent:@""
							  atIndex:0];
		
		// Liste mit Einträgen ausblenden
		[statusItem setMenu:mainMenu];
		[mainMenu setDelegate:self];
	}
}

-(void)populateRecentMenu
{
    if (!allQueriesFinished) return;
    if (!self.sandboxAccess) return;

    // Remove old menu entries
    while ([mainMenu numberOfItems]>numberOfGlobalItems) {
        [mainMenu removeItemAtIndex:0];
    }
    
    // Create Headings
    int i, j, k;
    BOOL hasResults = NO;
	int categoryCount = 0;
	for (i=0;i<[[self filterArray] count];i++) {
		NSDictionary *entry = [[self filterArray] objectAtIndex:i];
		if ([[entry valueForKey:SCOPE_DICT_ENABLED] boolValue]) {
            categoryCount++;
            
            // Create title and tag for category
            NSString *title = [entry valueForKey:SCOPE_DICT_TITLE];
            int tag = categoryCount;
            
            // Check if there are any results
            for (j=0;j<[queryArray count];j++) {
                NSDictionary *queryDict = [queryArray objectAtIndex:j];
                NSMetadataQuery *query = [queryDict valueForKey:QUERY_DICT_QUERY];
                int compareTag = [[queryDict valueForKey:QUERY_DICT_TAG] intValue];
                if (tag == compareTag) {
                    int wantedCount = [[queryDict valueForKey:QUERY_DICT_COUNT] intValue]; // Number of results to be shown
                    int actualCount = [query resultCount]; // Number of results
                    int resultCount = wantedCount;
                    if (actualCount < wantedCount) resultCount = actualCount;
                    if (actualCount > 0) { // Yes, we have results, insert them
                        hasResults = YES;
                        
                        // Insert title
                        if (title) {
                            NSMenuItem *newItem = [mainMenu insertItemWithTitle:title
                                                                         action:nil
                                                                  keyEquivalent:@""
                                                                        atIndex:([mainMenu numberOfItems]-numberOfGlobalItems)];
                            [newItem setTag:tag];
                            
                            // Collect results
                            NSMutableArray *tempResults = [[NSMutableArray alloc] initWithCapacity:0];
                            for (k=0;k<resultCount;k++) {
                                [tempResults addObject:[[query results] objectAtIndex:k]];
                            }
                            
                            // Insert results
                            [self insertItems:tempResults
                                       forTag:tag];
                            [tempResults release];
                            
                            // Insert divider
                            [mainMenu insertItem:[NSMenuItem separatorItem] atIndex:([mainMenu numberOfItems]-numberOfGlobalItems)];
                        }
                    }
                }
            }
        }
	}
    if (!hasResults) {
        // Insert empty entry
        NSMenuItem *newItem = [mainMenu insertItemWithTitle:@"No results available"
                                                     action:nil
                                              keyEquivalent:@""
                                                    atIndex:([mainMenu numberOfItems]-numberOfGlobalItems)];
        [mainMenu insertItem:[NSMenuItem separatorItem] atIndex:([mainMenu numberOfItems]-numberOfGlobalItems)];
        [newItem setEnabled:NO];
    }
}


// Called by -populateRecentMenu
-(void)insertItems:(NSArray*) array forTag:(int)tag
{
	int i;
	int startPos;
	startPos = [mainMenu indexOfItemWithTag:tag]; // recentItemsMenu
	if (startPos == -1) return;
	startPos++;
	for (i=0;i<[array count];i++) {
		NSString *itemPath = [[array objectAtIndex:i] valueForAttribute:MDI_PATH];
		NSString *itemTitle = [[array objectAtIndex:i] valueForAttribute:MDI_DISPLAYTITLE];
        if (!itemTitle) itemTitle = [[NSFileManager defaultManager] displayNameAtPath:itemPath];
        if ((itemPath) && (itemTitle)) {
            if (([itemPath length] > 0) && ([itemTitle length] > 0)) {
                // Insert normal item
                NSMenuItem *item = [self createMenuItem:itemPath
                                            isAlternate:NO
                                                  title:itemTitle];
                [mainMenu insertItem:item atIndex:startPos+(i*2)];
                // Insert alternate item
                NSMenuItem *itemAlternate = [self createMenuItem:itemPath
                                                     isAlternate:YES
                                                           title:itemTitle];
                [mainMenu insertItem:itemAlternate atIndex:startPos+(i*2)+1];
            }
        }
	}
}


// Called by -insertItems
-(NSMenuItem*)createMenuItem:(NSString*)filePath isAlternate:(BOOL)alternate title:(NSString*)title
{
	NSString *setTitle = [NSString stringWithString:title];
	NSImage *itemIcon = nil;
	if (filePath) {
		itemIcon = [[NSWorkspace sharedWorkspace] iconForFile:filePath];
		NSSize size;
		size.width = 16;
		size.height = 16;
		[itemIcon setSize:size];
	}
	NSMenuItem *item = [[[NSMenuItem alloc] initWithTitle:setTitle
												   action:@selector(click:)
											keyEquivalent:@""] autorelease];
	if (itemIcon) [item setImage:itemIcon];
	[item setRepresentedObject:filePath];
	[item setIndentationLevel:1];
	[item setKeyEquivalentModifierMask:0];
	[item setAlternate:NO];
    [item setToolTip:filePath];
	if (alternate) {
		[item setAlternate:YES];
		[item setKeyEquivalentModifierMask:NSCommandKeyMask];
		NSString *alternateTitle;
		alternateTitle = [NSString stringWithFormat:MENU_SHOWINFINDER, title];
		[item setTitle:alternateTitle];
	}
	return item;
}


@end

//
//  RMSecurityScopedBookmarkController.h
//  Recent Menu
//
//  Created by Tim Schröder on 19.07.12.
//  Copyright (c) 2012 Tim Schroeder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMSecurityScopedBookmarkController : NSObject

+ (RMSecurityScopedBookmarkController *)sharedController;

-(NSData*)loadBookmark;
-(void)saveBookmark:(NSData*)bookmarkData;
-(void)deleteBookmark;

-(BOOL)hasBookmark;
-(void)startAccessingSecurityScopedBookmark;
-(void)stopAccessingSecurityScopedBookmark;
-(void)grantBookmarkAccessForWindow:(NSWindow*)win;

@property (strong) NSURL *bookmarkURL;

@end

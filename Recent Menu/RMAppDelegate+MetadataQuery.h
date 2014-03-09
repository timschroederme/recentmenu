//
//  RMAppDelegate+MetadataQuery.h
//  Recent Menu
//
//  Created by Tim Schröder on 11.02.11.
//  Copyright 2011 Tim Schroeder. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RMAppDelegate.h"


@interface RMAppDelegate (MetadataQuery) <NSMetadataQueryDelegate>

-(void)startAllQueries;

@end

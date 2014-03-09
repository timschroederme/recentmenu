//
//  RMLocalizePreferencesController.m
//  Recent Menu
//
//  Created by Tim Schröder on 22.01.11.
//  Copyright 2011 Tentacle Forge. All rights reserved.
//

#import "RMConstants.h"
#import "RMLocalizePreferencesController.h"
#import "NSString+RMAdditions.h"


@implementation RMLocalizePreferencesController

-(void)awakeFromNib
{
	[startup setStringValue:PREFWINDOW_STARTUP];

	[searchTime setStringValue:PREFWINDOW_SEARCHTIME];
	
	NSString *prefix = PREFWINDOW_SEARCHTIMEPREFIX;
	[searchTimePrefix setStringValue:prefix];
	float prefixWidth =  [prefix calculateStringWidth:(NSControl*)searchTimePrefix];
	NSRect inputRect = [searchTimeInput frame];
	NSRect prefixRect = [searchTimePrefix frame];
	prefixRect.size.width = prefixWidth + 5;
	[searchTimePrefix setFrame:prefixRect];
	inputRect.origin.x = prefixRect.origin.x + prefixWidth + 10;
	[searchTimeInput setFrame:inputRect];
	NSRect suffixRect = [searchTimeSuffix frame];
	suffixRect.origin.x = inputRect.origin.x + inputRect.size.width + 5;
	[searchTimeSuffix setFrame:suffixRect];
	// Set serachTimeInput position
	// Set searchTimeSuffix 
	[searchTimeSuffix setStringValue:PREFWINDOW_SEARCHTIMESUFFIX];

	[searchLocation setStringValue:PREFWINDOW_SEARCHLOCATION];
	[searchLocationSmall setTitle:PREFWINDOW_SEARCHLOCATIONSMALL];
	[searchLocationBig setTitle:PREFWINDOW_SEARCHLOCATIONBIG];
		
	[queryTitle setStringValue:PREFWINDOW_QUERYTITLE];
	[queryEnabledCheckBox setTitle:PREFWINDOW_QUERYENABLEDCHECKBOX];
	[queryEnabledTitle setStringValue:PREFWINDOW_QUERYENABLEDTITLE];
	[queryCountTitle setStringValue:PREFWINDOW_QUERYCOUNTTITLE];
	
	[queryIsCaption setStringValue:PREFWINDOW_QUERYISCAPTION];
	[queryCriterionTitle setStringValue:PREFWINDOW_QUERYCRITERIONTITLE];
	[wildCard setStringValue:PREFWINDOW_WILDCARD];
    
    [resetCaption setTitle:PREFWINDOW_RESETCAPTION];
	
}

@end

//
//  RMAppDelegate+MetadataQuery.m
//  Recent Menu
//
//  Created by Tim Schröder on 11.02.11.
//  Copyright 2011 Tim Schroeder. All rights reserved.
//

#import "RMAppDelegate+MetadataQuery.h"
#import "RMConstants.h"
#import "RMAppDelegate+UserDefaults.h"
#import "RMAppDelegate+Menu.h"


@implementation RMAppDelegate (MetadataQuery)


#pragma mark -
#pragma mark Query Administration Methods

-(void)allQueriesFinished
{
	[self populateRecentMenu];
	[self showEntriesMenu];
}

-(void)startAllQueries
{
    [self showQueryMenu];
	allQueriesFinished = NO;
        
    int ex;
    for (ex=0;ex<[queryArray count]; ex++) {
        [[[queryArray objectAtIndex:ex] valueForKey:QUERY_DICT_QUERY] stopQuery];
    }
	[queryArray removeAllObjects];
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
    
	NSSortDescriptor *des = [[NSSortDescriptor alloc] initWithKey:SEARCH_KEY_1
														ascending:NO
														 selector:@selector(compare:)];
	NSArray *querySortDescriptor = [[NSArray arrayWithObjects:des, nil] retain];
	[des release];
	
    NSInteger activeCount = 0;
    for (NSDictionary *filter in [self filterArray]) {
        if ([[filter valueForKey:SCOPE_DICT_ENABLED] boolValue]) activeCount++;
    }
	if (activeCount > 0) {
        int entryCount = 0;
        int i;
		for (i=0;i<[[self filterArray] count];i++) {
			NSDictionary *entry = [[self filterArray] objectAtIndex:i];
			if ([[entry valueForKey:SCOPE_DICT_ENABLED] boolValue]) {
						
				NSMetadataQuery *query = [[NSMetadataQuery alloc] init];
				int tag = entryCount+1;
				NSString *tagString = [NSString stringWithFormat:@"%d", tag];
				NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
									  query,QUERY_DICT_QUERY,
									  [entry valueForKey:SCOPE_DICT_SHOWCOUNT], QUERY_DICT_COUNT,
									  tagString, QUERY_DICT_TAG, 
                                      [entry valueForKey:SCOPE_DICT_TITLE], QUERY_DICT_TITLE,
									  nil];
				[queryArray addObject:dict];
                [query release];
				[[dict valueForKey:QUERY_DICT_QUERY] setSortDescriptors:querySortDescriptor];
								
                [nc addObserver:self
					   selector:@selector(queryFinished:)
						   name:NSMetadataQueryDidFinishGatheringNotification 
						 object:[dict valueForKey:QUERY_DICT_QUERY]];
							
                NSDate *today = [NSDate date];
				double interval = [[self searchInterval] doubleValue];
				interval = -(interval * 60.0 * 60.0);
				NSDate *date = [NSDate dateWithTimeInterval:interval sinceDate:today];
							         
                NSPredicate *predicate;
				NSString *predicateString;
                NSMutableArray *cleanStrings;
                cleanStrings = [[NSMutableArray alloc] initWithCapacity:0];
				if ([[entry valueForKey:SCOPE_DICT_VALUE] length] != 0) {
                    
                    NSArray *dirtyStrings = [[entry valueForKey:SCOPE_DICT_VALUE] componentsSeparatedByString:@","];
                    int queryCnt;
                    for (queryCnt=0;queryCnt<[dirtyStrings count];queryCnt++) { // Strings trimmen
                        NSString *temp;
                        temp = [[dirtyStrings objectAtIndex:queryCnt] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        if ([temp length] > 0) [cleanStrings addObject:temp];
                    }
                    
                    if ([cleanStrings count] > 0) {
                        predicateString = @"(";
                        int j;
                        for (j=0;j<[cleanStrings count];j++) {
                            if (j>0) predicateString = [predicateString stringByAppendingString:@" || "];
                            NSString *temp = [cleanStrings objectAtIndex:j];
                            NSString *stringToAdd;
                            if ([[entry valueForKey:SCOPE_DICT_TYPE] isEqualToString:QUERY_UTI_SHORT]) {
                                
                                if ([[temp substringToIndex:1] isEqualToString:@"!"]) {
                                    temp = [temp substringFromIndex:1];
                                    stringToAdd = [NSString stringWithFormat:@"(%@%@')", QUERY_NOT_UTI, temp];
                                } else {
                                    stringToAdd = [NSString stringWithFormat:@"(%@%@')", QUERY_UTI, temp];
                                }
                            } else {
                                if ([[temp substringToIndex:1] isEqualToString:@"!"]) {
                                    temp = [temp substringFromIndex:1];
                                    stringToAdd = [NSString stringWithFormat:@"(%@%@')", QUERY_NOT_FILENAME, temp];
                                } else {
                                    stringToAdd = [NSString stringWithFormat:@"(%@%@')", QUERY_FILENAME, temp];
                                }
                            }

                            predicateString = [predicateString stringByAppendingString:stringToAdd];
                        }
                        predicateString = [predicateString stringByAppendingString:@")"];
                        
                    } else {
                        predicateString = @"";
                    }
                    
				} else {
					predicateString = @"";
				}
                [cleanStrings release];
                
				NSString *prepareString;
				if ([predicateString length] > 0) {
					NSString *prepS = @"(%K > %@) &&";
					prepareString = [prepS stringByAppendingString:predicateString];
				} else {
					prepareString = @"(%K > %@)";
				}
				predicate = [NSPredicate predicateWithFormat:prepareString, SEARCH_KEY_1, date];
			
				[[dict valueForKey:QUERY_DICT_QUERY] setPredicate:predicate];
				int locFlag = [[self searchLocation] intValue];
			
				if (locFlag==0) {
				
					NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
					[arr addObject:NSMetadataQueryUserHomeScope];	
					[arr addObject:PATH_MAINAPPDIR];
					[arr addObject:PATH_DEVELOPAPPDIR];
					[[dict valueForKey:QUERY_DICT_QUERY] setSearchScopes:arr];
				}
				if (locFlag==1) {
					[[dict valueForKey:QUERY_DICT_QUERY] setSearchScopes: [NSArray arrayWithObjects: NSMetadataQueryLocalComputerScope, nil]];
				}
			
				[[dict valueForKey:QUERY_DICT_QUERY] startQuery];	
			
				entryCount++;
			}
		}
	} else {
        allQueriesFinished = YES;
		[self allQueriesFinished];
	}
    [querySortDescriptor release];
}


#pragma mark -
#pragma mark NSMetadataQuery Delegate Methods

- (void)queryFinished:(NSNotification *)notification
{
	BOOL allFinished = YES;
	int i;
	for (i=0;i<[queryArray count];i++) { // Prüfen, ob wirklich alle Queries fertig sind
		NSMetadataQuery *query = [[queryArray objectAtIndex:i] valueForKey:QUERY_DICT_QUERY];
		if ((![[notification object] isEqual: query]) && ([query isGathering])) allFinished = NO;
	}
	if ((allFinished) && (!allQueriesFinished)) {
		allQueriesFinished = YES;
		[self allQueriesFinished];
	}
}

@end
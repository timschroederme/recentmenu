//
//  RMAppDelegate+UserDefaults.m
//  Recent Menu
//
//  Created by Tim Schröder on 09.02.11.
//  Copyright 2011 Tim Schröder. All rights reserved.
//

#import "RMAppDelegate+UserDefaults.h"
#import "NSDictionary+RMAdditions.h"
#import "RMConstants.h"


@implementation RMAppDelegate (UserDefaults)


#pragma mark -
#pragma Internal Helper Methods

+(NSArray*)standardFilters
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"defaultfilters" ofType:@"plist"];
    NSData *xmlData = [NSData dataWithContentsOfFile:path];
    NSArray *standardFilters = [NSPropertyListSerialization propertyListWithData:xmlData
                                                                         options:NSPropertyListImmutable
                                                                          format:NULL
                                                                           error:nil];
    return standardFilters;
    
}


#pragma mark -
#pragma mark Overriden Methods

// Registering User Defaults - Preferences

+ (void)initialize
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [self standardFilters], DEFAULTS_SCOPEFILTER,
								 DEFAULTS_SEARCHINTERVAL_PRESET, DEFAULTS_SEARCHINTERVAL,
								 DEFAULTS_SEARCHLOCATION_PRESET, DEFAULTS_SEARCHLOCATION,
								 nil];
    [defaults registerDefaults:appDefaults];
}


#pragma mark -
#pragma mark Hilfsfunktionen 

-(NSArray*)filterArray
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return ([defaults valueForKey:DEFAULTS_SCOPEFILTER]);
}

-(NSString*)searchInterval
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *interval = [defaults objectForKey:DEFAULTS_SEARCHINTERVAL];
	return interval;
}

-(NSString*)searchLocation
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *location = [defaults objectForKey:DEFAULTS_SEARCHLOCATION];
	return location;	
}

-(void)resetQueries
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
}




@end

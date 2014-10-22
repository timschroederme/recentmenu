//
//  NSDictionary+RMAdditions.m
//  Recent Menu
//
//  Created by Tim Schröder on 25.01.11.
//  Copyright 2011 Tim Schröder. All rights reserved.
//

#import "NSDictionary+RMAdditions.h"
#import "RMConstants.h"

@implementation NSDictionary (RMAdditions)

+(NSDictionary*)  createFilter:(NSString *)title 
					  withType:(NSString *)type
					 withValue:(NSString*)value
					isEditable:(BOOL)editable
					 isEnabled:(BOOL)enabled
					   withTag:(NSNumber *)tag
{
	NSString *editableString;
	if (editable) {
		editableString = @"YES";
	} else {
		editableString = @"NO";
	}
	NSString *enabledString;
	if (enabled) {
		enabledString = @"YES";
	} else {
		enabledString = @"NO";
	}
	NSDictionary *dict = [[[NSDictionary alloc] initWithObjectsAndKeys:
						   title, SCOPE_DICT_TITLE,
						   type, SCOPE_DICT_TYPE,
						   value, SCOPE_DICT_VALUE,
						   @"NO", SCOPE_DICT_HIDDEN,
						   enabledString, SCOPE_DICT_ENABLED,
						   editableString, SCOPE_DICT_EDITABLE,
						   @"10", SCOPE_DICT_SHOWCOUNT,
						   tag, SCOPE_DICT_TAG,
						   nil] autorelease];
	return dict;
}

@end

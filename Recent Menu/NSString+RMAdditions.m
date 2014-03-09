//
//  NSString+RMAdditions.m
//  Recent Menu
//
//  Created by Tim Schröder on 28.12.10.
//  Copyright 2010 Tim Schröder. All rights reserved.
//

#import "RMConstants.h"
#import "NSString+RMAdditions.h"


@implementation NSString (RMAdditions)


// Called by Localization Controller to calculate length of a string
-(float)calculateStringWidth:(NSControl*)control
{
	NSMutableParagraphStyle *primaryStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
	NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys: 
									[control font], NSFontAttributeName, 
									primaryStyle, NSParagraphStyleAttributeName, 
									nil];	
	NSSize stringSize = [self sizeWithAttributes:textAttributes];
	return roundf (stringSize.width);
}

@end

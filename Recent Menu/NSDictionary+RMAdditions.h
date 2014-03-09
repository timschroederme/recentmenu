//
//  NSDictionary+RMAdditions.h
//  Recent Menu
//
//  Created by Tim Schröder on 25.01.11.
//  Copyright 2011 Tim Schröder. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSDictionary (RMAdditions)

+(NSDictionary*)  createFilter:(NSString *)title 
					  withType:(NSString *)type
					 withValue:(NSString*)value
					isEditable:(BOOL)editable
					 isEnabled:(BOOL)enabled
					   withTag:(NSNumber *)tag;

@end

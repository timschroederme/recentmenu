//
//  RMFilterFormatter.m
//  Recent Menu
//
//  Created by Tim Schröder on 28.04.11.
//  Copyright 2011 Tim Schroeder. All rights reserved.
//

#import "RMFilterFormatter.h"


@implementation RMFilterFormatter

- (BOOL)getObjectValue:(id *)obj forString:(NSString *)string
      errorDescription:(NSString  **)error
{
    *obj = [NSString stringWithString:string];
    return YES;
}

- (NSString *)stringForObjectValue:(id)anObject
{
    if([anObject isKindOfClass:[NSString class]])
    {
        return [NSString stringWithString:anObject];
    }
    else
    {
        return (@"");
    }
}

- (BOOL)isPartialStringValid:(NSString *)partialString
            newEditingString:(NSString **)newString errorDescription:(NSString
                                                                      **)error
{
    NSRange range = [partialString rangeOfString:@"'"];
    if (range.location == NSNotFound) return YES;
    NSBeep();
    return NO;

}


@end

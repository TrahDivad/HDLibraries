//
//  UIApplication+HDAdditions.m
//  HDLibraries
//
//  Created by David Hart on 7/11/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "UIApplication+HDAdditions.h"


@implementation UIApplication (HDAdditions)

- (NSString*)version
{
	NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSString* shortVersion = infoDictionary[@"CFBundleShortVersionString"];
	NSString* version = infoDictionary[@"CFBundleVersion"];
	return [NSString stringWithFormat:@"%@ (%@)", shortVersion, version];
}

@end

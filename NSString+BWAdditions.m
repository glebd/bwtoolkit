//
//  NSString+BWAdditions.m
//  BWToolkit
//
//  Created by Brandon Walkin on 15/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NSString+BWAdditions.h"


@implementation NSString (BWAdditions)

+ (NSString *)randomUUID
{
	CFUUIDRef uuidObj = CFUUIDCreate(nil);
	NSString *newUUID = (NSString*)CFUUIDCreateString(nil, uuidObj);
	CFRelease(uuidObj);
	
	return [newUUID autorelease];
}

@end

//
//  BWToolbarItem.m
//  BWToolkit
//
//  Created by Brandon Walkin (www.brandonwalkin.com)
//  All code is provided under the New BSD license.
//

#import "BWToolbarItem.h"

@interface BWToolbarItem ()
@property (copy) NSString *identifierString;
@end

@interface NSToolbarItem (BWTIPrivate)
- (void)_setItemIdentifier:(id)fp8;
@end

@implementation BWToolbarItem

@synthesize identifierString;

- (void)setIdentifierString:(NSString *)aString
{
	if (identifierString != aString)
	{
		[identifierString release];
		identifierString = [aString copy];
	}
	
	if (identifierString == nil || [identifierString isEqualToString:@""])
	{
		// Generate a random UUID
		CFUUIDRef uuidObj = CFUUIDCreate(nil);
		NSString *newUUID = (NSString*)CFUUIDCreateString(nil, uuidObj);
		CFRelease(uuidObj);
		[newUUID autorelease];
		
		// Set the identifier to the UUID
		[self _setItemIdentifier:[super itemIdentifier]];
	}
	else
	{
		[self _setItemIdentifier:identifierString];
	}
}

- (void)dealloc
{
	[identifierString release];
	[super dealloc];
}

@end

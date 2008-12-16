//
//  BWToolbarItem.m
//  BWToolkit
//
//  Created by Brandon Walkin (www.brandonwalkin.com)
//  All code is provided under the New BSD license.
//

#import "BWToolbarItem.h"
#import "NSString+BWAdditions.h"

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
		[self _setItemIdentifier:[NSString randomUUID]];
	else
		[self _setItemIdentifier:identifierString];
}

- (void)dealloc
{
	[identifierString release];
	[super dealloc];
}

@end

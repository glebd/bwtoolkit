//
//  BWToolbarShowColorsItem.m
//  BWToolkit
//
//  Created by Brandon Walkin (www.brandonwalkin.com)
//  All code is provided under the New BSD license.
//

#import "BWToolbarShowColorsItem.h"

@implementation BWToolbarShowColorsItem

- (id)initWithItemIdentifier:(NSString *)itemIdentifier
{
	if (self = [super initWithItemIdentifier:itemIdentifier])
	{
		NSBundle *bundle = [NSBundle bundleForClass:[BWToolbarShowColorsItem class]];
		
		NSImage *colorsIcon = [[[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"ToolbarItemColors.tiff"]] autorelease];
		
		[self setImage:colorsIcon];
	}
	return self;
}

- (NSString *)itemIdentifier
{
	return @"BWToolbarShowColorsItem";
}

- (NSString *)label
{
	return @"Colors";
}

- (NSString *)paletteLabel
{
	return @"Colors";
}

- (id)target
{
	return [NSApplication sharedApplication];
}

- (SEL)action
{
	return @selector(orderFrontColorPanel:);
}

- (NSString *)toolTip
{
	return @"Show Color Panel";
}

@end

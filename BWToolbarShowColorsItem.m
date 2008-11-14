//
//  BWToolbarShowColorsItem.m
//  BWToolkit
//
//  Created by Brandon Walkin (www.brandonwalkin.com)
//  All code is provided under the New BSD license.
//

#import "BWToolbarShowColorsItem.h"

static NSImage *colorsIcon;

@implementation BWToolbarShowColorsItem

+ (void)initialize
{
	NSBundle *bundle = [NSBundle bundleForClass:[BWToolbarShowColorsItem class]];
	
	colorsIcon = [[[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"ToolbarItemColors.tiff"]] copy];
}

- (NSImage *)image
{
	return [colorsIcon copy];
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

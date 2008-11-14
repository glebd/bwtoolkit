//
//  BWAnchoredButtonBarViewIntegration.m
//  BWToolkit
//
//  Created by Brandon Walkin (www.brandonwalkin.com)
//  All code is provided under the New BSD license.
//

#import <InterfaceBuilderKit/InterfaceBuilderKit.h>
#import "BWAnchoredButtonBar.h"
#import "BWAnchoredButtonBarInspector.h"


@implementation BWAnchoredButtonBar ( BWAnchoredButtonBarIntegration )

- (void)ibPopulateKeyPaths:(NSMutableDictionary *)keyPaths {
    [super ibPopulateKeyPaths:keyPaths];

    [[keyPaths objectForKey:IBAttributeKeyPaths] addObjectsFromArray:[NSArray arrayWithObjects:@"selectedIndex", @"selectedMinWidthUnit", @"selectedMaxWidthUnit", @"minWidth", @"maxWidth", nil]];
}

- (void)ibPopulateAttributeInspectorClasses:(NSMutableArray *)classes {
    [super ibPopulateAttributeInspectorClasses:classes];

    [classes addObject:[BWAnchoredButtonBarInspector class]];
}

// Provide default values. A min width of 135 pt and a max width of 60% of the window width.
- (void)ibDidAddToDesignableDocument:(IBDocument *)document
{
	[super ibDidAddToDesignableDocument:document];
	
	if ([self maxWidth] == nil && [self minWidth] == nil && [self selectedMinWidthUnit] == 0 && [self selectedMaxWidthUnit] == 0)
	{
		[self setSelectedMaxWidthUnit:1];
		[self setMinWidth:[NSNumber numberWithInt:135]];
		[self setMaxWidth:[NSNumber numberWithInt:60]];
	}
}

- (NSArray *)ibDefaultChildren
{
	return [self subviews];
}

- (NSView *)ibDesignableContentView
{
	return self;
}

- (NSSize)ibMinimumSize
{
	NSSize minSize = NSZeroSize;
	
	if (isAtBottom)
		minSize.height = 23;
	else
		minSize.height = 24;

	return minSize;
}

- (NSSize)ibMaximumSize
{
	NSSize maxSize;
	maxSize.width = 100000;
	
	if (isAtBottom)
		maxSize.height = 23;
	else
		maxSize.height = 24;

	return maxSize;
}


@end

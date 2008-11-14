//
//  BWAnchoredButtonBar.m
//  BWToolkit
//
//  Created by Brandon Walkin (www.brandonwalkin.com)
//  All code is provided under the New BSD license.
//

#import "BWAnchoredButtonBar.h"
#import "NSColor+BWAdditions.h"
#import "NSView+BWAdditions.h"
#import "BWAnchoredButton.h"

static NSColor *topLineColor, *bottomLineColor;
static NSColor *topColor, *middleTopColor, *middleBottomColor, *bottomColor;
static NSColor *sideInsetColor, *borderedTopLineColor;
static NSColor *resizeHandleColor, *resizeInsetColor;
static NSGradient *gradient;
static BOOL wasBorderedBar;
static float scaleFactor = 0.0f;

@interface BWAnchoredButtonBar (BWABBPrivate)
- (void)drawResizeHandleInRect:(NSRect)handleRect withColor:(NSColor *)color;
- (void)drawLastButtonInsetInRect:(NSRect)rect;
@end

@implementation BWAnchoredButtonBar

@synthesize selectedIndex;
@synthesize isAtBottom;
@synthesize isResizable;
@synthesize selectedMinWidthUnit;
@synthesize selectedMaxWidthUnit;
@synthesize minWidth;
@synthesize maxWidth;

+ (void)initialize;
{
	topLineColor		 = [[NSColor colorWithCalibratedWhite:(202.0f / 255.0f) alpha:1] retain];
	bottomLineColor		 = [[NSColor colorWithCalibratedWhite:(170.0f / 255.0f) alpha:1] retain];
    topColor			 = [[NSColor colorWithCalibratedWhite:(253.0f / 255.0f) alpha:1] retain];
    middleTopColor		 = [[NSColor colorWithCalibratedWhite:(242.0f / 255.0f) alpha:1] retain];
    middleBottomColor	 = [[NSColor colorWithCalibratedWhite:(230.0f / 255.0f) alpha:1] retain];
	bottomColor			 = [[NSColor colorWithCalibratedWhite:(230.0f / 255.0f) alpha:1] retain];
	sideInsetColor		 = [[NSColor colorWithCalibratedWhite:(255.0f / 255.0f) alpha:0.5] retain];
	borderedTopLineColor = [[NSColor colorWithCalibratedWhite:(190.0f / 255.0f) alpha:1] retain];
    
	gradient			 = [[NSGradient alloc] initWithColorsAndLocations:
						   topColor, (CGFloat)0.0,
						   middleTopColor, (CGFloat)0.45454,
						   middleBottomColor, (CGFloat)0.45454,
						   bottomColor, (CGFloat)1.0,
						   nil];
	
	resizeHandleColor	 = [[NSColor colorWithCalibratedWhite:(0.0f / 255.0f) alpha:0.598] retain];
	resizeInsetColor	 = [[NSColor colorWithCalibratedWhite:(255.0f / 255.0f) alpha:0.55] retain];
}

- (id)initWithFrame:(NSRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
        scaleFactor = [[NSScreen mainScreen] userSpaceScaleFactor];
		[self setIsResizable:YES];
		[self setIsAtBottom:YES];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder;
{
    if ((self = [super initWithCoder:decoder]) != nil)
	{
		[self setIsResizable:[decoder decodeBoolForKey:@"BWABBIsResizable"]];
		[self setIsAtBottom:[decoder decodeBoolForKey:@"BWABBIsAtBottom"]];
		[self setSelectedIndex:[decoder decodeIntForKey:@"BWABBSelectedIndex"]];
		[self setSelectedMinWidthUnit:[decoder decodeIntForKey:@"BWABBSelectedMinWidthUnit"]];
		[self setSelectedMaxWidthUnit:[decoder decodeIntForKey:@"BWABBSelectedMaxWidthUnit"]];
		[self setMinWidth:[decoder decodeObjectForKey:@"BWABBMinWidth"]];
		[self setMaxWidth:[decoder decodeObjectForKey:@"BWABBMaxWidth"]];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder*)coder
{
    [super encodeWithCoder:coder];
	
	[coder encodeBool:[self isResizable] forKey:@"BWABBIsResizable"];
	[coder encodeBool:[self isAtBottom] forKey:@"BWABBIsAtBottom"];
	[coder encodeInt:[self selectedIndex] forKey:@"BWABBSelectedIndex"];
	[coder encodeInt:[self selectedMinWidthUnit] forKey:@"BWABBSelectedMinWidthUnit"];
	[coder encodeInt:[self selectedMaxWidthUnit] forKey:@"BWABBSelectedMaxWidthUnit"];
	[coder encodeObject:[self minWidth] forKey:@"BWABBMinWidth"];
	[coder encodeObject:[self maxWidth] forKey:@"BWABBMaxWidth"];
}

- (void)awakeFromNib
{
	scaleFactor = [[NSScreen mainScreen] userSpaceScaleFactor];
	
	// Iterate through superviews, see if we're in a split view, and set its delegate
	NSSplitView *splitView = nil;
	id currentView = self;
	
	while (![currentView isKindOfClass:[NSSplitView class]] && currentView != nil)
	{
		currentView = [currentView superview];
		if ([currentView isKindOfClass:[NSSplitView class]])
			splitView = currentView;
	}
	
	if (splitView != nil && [splitView isVertical] && [self isResizable])
		[splitView setDelegate:self];
		
	[self bringToFront];
}

- (void)drawRect:(NSRect)rect 
{	
	rect = self.bounds;
	
	// Draw gradient
	NSRect gradientRect;
	if (isAtBottom)
		gradientRect = NSMakeRect(rect.origin.x,rect.origin.y,rect.size.width,rect.size.height - 1);
	else
		gradientRect = NSInsetRect(rect, 0, 1); 
	[gradient drawInRect:gradientRect angle:270];
	
	// Draw top line
	if (isAtBottom)
		[topLineColor drawPixelThickLineAtPosition:0 withInset:0 inRect:rect inView:self horizontal:YES flip:YES];
	else
		[borderedTopLineColor drawPixelThickLineAtPosition:0 withInset:0 inRect:rect inView:self horizontal:YES flip:YES];
	
	// Draw resize handle
	if (isResizable)
	{
		NSRect handleRect = NSMakeRect(NSMaxX(rect)-11,6,6,10);
		[self drawResizeHandleInRect:handleRect withColor:resizeHandleColor];
		
		NSRect insetRect = NSOffsetRect(handleRect,1,-1);
		[self drawResizeHandleInRect:insetRect withColor:resizeInsetColor];
	}
	
	[self drawLastButtonInsetInRect:rect];
	
	// Draw bottom line and sides if it's in non-bottom mode
	if (!isAtBottom)
	{
		[bottomLineColor drawPixelThickLineAtPosition:0 withInset:0 inRect:rect inView:self horizontal:YES flip:NO];
		[bottomLineColor drawPixelThickLineAtPosition:0 withInset:1 inRect:rect inView:self horizontal:NO flip:NO];
		[bottomLineColor drawPixelThickLineAtPosition:0 withInset:1 inRect:rect inView:self horizontal:NO flip:YES];
	}
}

- (void)drawResizeHandleInRect:(NSRect)handleRect withColor:(NSColor *)color
{
	[color drawPixelThickLineAtPosition:0 withInset:0 inRect:handleRect inView:self horizontal:NO flip:NO];
	[color drawPixelThickLineAtPosition:3 withInset:0 inRect:handleRect inView:self horizontal:NO flip:NO];
	[color drawPixelThickLineAtPosition:6 withInset:0 inRect:handleRect inView:self horizontal:NO flip:NO];
}

- (void)drawLastButtonInsetInRect:(NSRect)rect
{
	NSView *rightMostView = nil;
	
	if ([[self subviews] count] > 0)
	{
		rightMostView = [[self subviews] objectAtIndex:0];
		
		NSView *currentSubview = nil;
		for (currentSubview in [self subviews])
		{
			if ([[currentSubview className] isEqualToString:@"BWAnchoredButton"] || [[currentSubview className] isEqualToString:@"BWAnchoredPopUpButton"])
			{
				if (NSMaxX([currentSubview frame]) > NSMaxX([rightMostView frame]))
					rightMostView = currentSubview;
				
				if ([currentSubview frame].origin.x == 0)
					[(BWAnchoredButton *)currentSubview setIsAtLeftEdgeOfBar:YES];
				else
					[(BWAnchoredButton *)currentSubview setIsAtLeftEdgeOfBar:NO];
				
				if (NSMaxX([currentSubview frame]) == NSMaxX([self bounds]))
					[(BWAnchoredButton *)currentSubview setIsAtRightEdgeOfBar:YES];
				else
					[(BWAnchoredButton *)currentSubview setIsAtRightEdgeOfBar:NO];
			}
		}
	}
	
	if (rightMostView != nil && ([[rightMostView className] isEqualToString:@"BWAnchoredButton"] || [[rightMostView className] isEqualToString:@"BWAnchoredPopUpButton"]))
	{
		NSRect newRect = NSOffsetRect(rect,0,-1);
		[sideInsetColor drawPixelThickLineAtPosition:NSMaxX([rightMostView frame]) withInset:0 inRect:newRect inView:self horizontal:NO flip:NO];
	}
}

- (void)setIsAtBottom:(BOOL)flag
{
	isAtBottom = flag;

	if (flag)
	{
		[self setFrameSize:NSMakeSize(self.frame.size.width,23)];
		wasBorderedBar = NO;
	}
	else
	{
		[self setFrameSize:NSMakeSize(self.frame.size.width,24)];
		wasBorderedBar = YES;
	}

	[self setNeedsDisplay:YES];
}

- (void)setSelectedIndex:(int)anIndex
{
	if (anIndex == 0)
	{
		[self setIsAtBottom:YES];
		[self setIsResizable:YES];
	}
	else if (anIndex == 1)
	{
		[self setIsAtBottom:YES];
		[self setIsResizable:NO];
	}
	else if (anIndex == 2)
	{
		[self setIsAtBottom:NO];
		[self setIsResizable:NO];
	}
	selectedIndex = anIndex;
	
	[self setNeedsDisplay:YES];
}

+ (BOOL)wasBorderedBar
{
	return wasBorderedBar;
}

#pragma mark NSSplitView Delegate Methods

// Add the resize handle rect to the split view hot zone
- (NSRect)splitView:(NSSplitView *)aSplitView additionalEffectiveRectOfDividerAtIndex:(NSInteger)dividerIndex
{
	NSRect paddedHandleRect;
	paddedHandleRect.origin.y = [aSplitView frame].size.height - [self frame].origin.y - [self bounds].size.height;
	paddedHandleRect.origin.x = NSMaxX([self bounds]) - 15;
	paddedHandleRect.size.width = 15;
	paddedHandleRect.size.height = [self bounds].size.height;
	
	return paddedHandleRect;
}

// Set the min width of the left most pane
- (CGFloat)splitView:(NSSplitView *)sender constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(NSInteger)offset
{
	if (minWidth != nil && offset == 0)
	{
		if (selectedMinWidthUnit == 0) // Points
			return [minWidth floatValue];
		else if (selectedMinWidthUnit == 1) // %
		{
			float splitViewWidth = [sender bounds].size.width;
			return splitViewWidth * [minWidth floatValue] * 0.01;
		}
	}
	
	return 0.0;
}

// Set the max width of the left most pane
- (CGFloat)splitView:(NSSplitView *)sender constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(NSInteger)offset
{
	if (maxWidth != nil && offset == 0)
	{
		if (selectedMaxWidthUnit == 0) // Points
			return [maxWidth floatValue];
		else if (selectedMaxWidthUnit == 1) // %
		{
			float splitViewWidth = [sender bounds].size.width;
			return splitViewWidth * [maxWidth floatValue] * 0.01;
		}
	}
	
	return [sender bounds].size.width;
}

// When the window resizes, keep all of the split view subviews at a constant width except for the right most view
- (void)splitView:(NSSplitView*)sender resizeSubviewsWithOldSize:(NSSize)oldSize
{
	NSRect newFrame = [sender frame];
	float totalDividerThickness = [sender dividerThickness] * ([[sender subviews] count] - 1);
	float totalSubviewWidth;
	
	// Sum the total width of the views except for the right most one
	int i;
	for (i = 0; i < [sender subviews].count - 1; i++)
	{
		NSView *view = [[sender subviews] objectAtIndex:i];
		NSRect viewFrame = [view frame];
		
		totalSubviewWidth += viewFrame.size.width;
	}
	
	// Calculate the frame for the right most view
	NSView *lastView = [[sender subviews] lastObject];
	NSRect lastViewFrame = [lastView frame];
	lastViewFrame.size.height = newFrame.size.height;
	lastViewFrame.size.width = newFrame.size.width - totalDividerThickness - totalSubviewWidth;
	
	// Workaround for a bug
	if (newFrame.size.width - totalDividerThickness - totalSubviewWidth == lastViewFrame.size.width)
	{
		// Set frames on all views except the right most view
		int j;
		for (j = 0; j < [sender subviews].count - 1; j++)
		{
			NSView *view = [[sender subviews] objectAtIndex:j];
			NSRect viewFrame = [view frame];
			viewFrame.size.height = newFrame.size.height;
			[view setFrame:viewFrame];
		}
		
		// Set frame on the right most view
		[lastView setFrame:lastViewFrame];
	}
	else
	{
		[sender adjustSubviews];
	}
}

@end

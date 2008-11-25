//
//  BWSplitView.m
//  BWToolkit
//
//  Created by Brandon Walkin (www.brandonwalkin.com)
//  All code is provided under the New BSD license.
//

#import "BWSplitView.h"
#import "NSColor+BWAdditions.h"

static NSGradient *gradient;
static NSImage *dimpleImageBitmap, *dimpleImageVector;
static NSColor *borderColor, *gradientStartColor, *gradientEndColor;
static float scaleFactor = 1.0f;

#define dimpleDimension 4.0f

@interface BWSplitView (BWSVPrivate)
- (void)drawDimpleInRect:(NSRect)aRect;
- (void)drawGradientDividerInRect:(NSRect)aRect;
@end

@interface BWSplitView ()
@property BOOL checkboxIsEnabled;
@end

@implementation BWSplitView

@synthesize color;
@synthesize colorIsEnabled;
@synthesize checkboxIsEnabled;

+ (void)initialize;
{
    borderColor        = [[NSColor colorWithCalibratedWhite:(165.0f / 255.0f) alpha:1] retain];
    gradientStartColor = [[NSColor colorWithCalibratedWhite:(253.0f / 255.0f) alpha:1] retain];
    gradientEndColor   = [[NSColor colorWithCalibratedWhite:(222.0f / 255.0f) alpha:1] retain];

    gradient           = [[NSGradient alloc] initWithStartingColor:gradientStartColor endingColor:gradientEndColor];

	NSBundle *bundle = [NSBundle bundleForClass:[BWSplitView class]];
	dimpleImageBitmap  = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"GradientSplitViewDimpleBitmap.tif"]];
	dimpleImageVector  = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"GradientSplitViewDimpleVector.pdf"]];
    [dimpleImageBitmap setFlipped:YES];
	[dimpleImageVector setFlipped:YES];
}

- (id)initWithCoder:(NSCoder *)decoder;
{
    if ((self = [super initWithCoder:decoder]) != nil)
	{
		[self setColor:[decoder decodeObjectForKey:@"BWSVColor"]];
		[self setColorIsEnabled:[decoder decodeBoolForKey:@"BWSVColorIsEnabled"]];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder*)coder
{
    [super encodeWithCoder:coder];
	
	[coder encodeObject:[self color] forKey:@"BWSVColor"];
	[coder encodeBool:[self colorIsEnabled] forKey:@"BWSVColorIsEnabled"];
}

- (void)awakeFromNib
{
	scaleFactor = [[NSScreen mainScreen] userSpaceScaleFactor];
}

- (void)drawDividerInRect:(NSRect)aRect
{	
    if ([self isVertical])
    {
		if (colorIsEnabled && color != nil)
			[color drawSwatchInRect:aRect];
		else
			[super drawDividerInRect:aRect];
    }
	else
	{
		if ([self dividerThickness] <= 1.01)
		{
			if (colorIsEnabled && color != nil)
				[color drawSwatchInRect:aRect];
			else
				[super drawDividerInRect:aRect];
		}
		else
		{
			[self drawGradientDividerInRect:aRect];
		}
	}
}

- (void)drawGradientDividerInRect:(NSRect)aRect
{	
	aRect = [self centerScanRect:aRect];
	
	// Draw gradient
	NSRect gradRect = NSMakeRect(aRect.origin.x,aRect.origin.y + 1 / scaleFactor,aRect.size.width,aRect.size.height - 1 / scaleFactor);
	[gradient drawInRect:gradRect angle:90];
	
	// Draw top and bottom borders
	[borderColor drawPixelThickLineAtPosition:0 withInset:0 inRect:aRect inView:self horizontal:YES flip:NO];
	[borderColor drawPixelThickLineAtPosition:0 withInset:0 inRect:aRect inView:self horizontal:YES flip:YES];
	
	[self drawDimpleInRect:aRect];
}

- (void)drawDimpleInRect:(NSRect)aRect
{
    float startY = aRect.origin.y + roundf((aRect.size.height / 2) - (dimpleDimension / 2));
    float startX = aRect.origin.x + roundf((aRect.size.width / 2) - (dimpleDimension / 2));
    NSRect destRect = NSMakeRect(startX,startY,dimpleDimension,dimpleDimension);
	
	// Draw at pixel bounds 
	destRect = [self convertRectToBase:destRect];
	destRect.origin.x = floor(destRect.origin.x);
	
	double param, fractPart, intPart;
	param = destRect.origin.y;
	fractPart = modf(param, &intPart);
	if (fractPart < 0.99)
		destRect.origin.y = floor(destRect.origin.y);
	destRect = [self convertRectFromBase:destRect];
	
	if (scaleFactor == 1)
	{
		NSRect dimpleRect = NSMakeRect(0,0,dimpleDimension,dimpleDimension);
		[dimpleImageBitmap drawInRect:destRect fromRect:dimpleRect operation:NSCompositeSourceOver fraction:1];
	}
    else
	{
		NSRect dimpleRect = NSMakeRect(0,0,[dimpleImageVector size].width,[dimpleImageVector size].height);
		[dimpleImageVector drawInRect:destRect fromRect:dimpleRect operation:NSCompositeSourceOver fraction:1];
	}
}

- (CGFloat)dividerThickness
{
	float thickness;
	
    if ([self isVertical])
	{
		thickness = 1;
	}
	else
	{
		if ([super dividerThickness] < 1.01)
			thickness = 1;
		else
			thickness = 10;
	}
	
    return thickness;
}

#pragma mark Force Vertical Splitters to Thin Appearance

// This class doesn't have an appearance for wide vertical splitters, so we force all vertical splitters to thin by overriding a private method and a public one
- (void)setDividerStyle:(int)aStyle
{
	if ([self isVertical])
		[super setDividerStyle:2];
	else
		[super setDividerStyle:aStyle];
}

- (void)setVertical:(BOOL)flag
{
	if (flag)
		[super setDividerStyle:2];
	
	[super setVertical:flag];
}

#pragma mark IB Inspector Support Methods

- (BOOL)checkboxIsEnabled
{
	if (![self isVertical] && [super dividerThickness] > 1.01)
		return NO;
	
	return YES;
}

- (void)setColorIsEnabled:(BOOL)flag
{
	colorIsEnabled = flag;
	
	[self setNeedsDisplay:YES];
}

- (void)setColor:(NSColor *)aColor
{
	if (color != aColor)
	{
		[color release];
		color = [aColor copy];
	}
	
	[self setNeedsDisplay:YES];
}

- (void)dealloc
{
	[color release];
	[super dealloc];
}

@end

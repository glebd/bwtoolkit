//
//  BWAnchoredButtonBarViewInspector.m
//  BWToolkit
//
//  Created by Brandon Walkin (www.brandonwalkin.com)
//  All code is provided under the New BSD license.
//

#import "BWAnchoredButtonBarInspector.h"

@implementation BWAnchoredButtonBarInspector

- (NSString *)viewNibName {
    return @"BWAnchoredButtonBarInspector";
}

- (void)refresh {
	// Synchronize your inspector's content view with the currently selected objects
	[super refresh];
}

- (IBAction)selectMode1:(id)sender
{
	float xOrigin = matrix.frame.origin.x-1;
	float deltaX = fabsf(xOrigin - selectionView.frame.origin.x);
	float doubleSpaceMultiplier = 1;
	
	if (deltaX > 65)
		doubleSpaceMultiplier = 1.5;
	
	float duration = 0.1*doubleSpaceMultiplier;
	
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:(duration)];
	[[selectionView animator] setFrameOrigin:NSMakePoint(xOrigin,selectionView.frame.origin.y)];
	[NSAnimationContext endGrouping];
	
	[self performSelector:@selector(resizeInspectorForMode:) withObject:[NSNumber numberWithInt:1] afterDelay:(duration)];
}

- (IBAction)selectMode2:(id)sender
{
	float xOrigin = matrix.frame.origin.x + NSWidth(matrix.frame) / matrix.numberOfColumns;
	float deltaX = fabsf(xOrigin - selectionView.frame.origin.x);
	float doubleSpaceMultiplier = 1;
	
	if (deltaX > 65)
		doubleSpaceMultiplier = 1.5;
	
	float duration = 0.1*doubleSpaceMultiplier;
	
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:(duration)];
	[[selectionView animator] setFrameOrigin:NSMakePoint(xOrigin,selectionView.frame.origin.y)];
	[NSAnimationContext endGrouping];
	
	[self performSelector:@selector(resizeInspectorForMode:) withObject:[NSNumber numberWithInt:2] afterDelay:(duration)];
}

- (IBAction)selectMode3:(id)sender
{
	float xOrigin = NSMaxX(matrix.frame) - NSWidth(matrix.frame) / matrix.numberOfColumns + matrix.numberOfColumns - 1;
	float deltaX = fabsf(xOrigin - selectionView.frame.origin.x);
	float doubleSpaceMultiplier = 1;
	
	if (deltaX > 65)
		doubleSpaceMultiplier = 1.5;
	
	float duration = 0.1*doubleSpaceMultiplier;
	
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:(duration)];
	[[selectionView animator] setFrameOrigin:NSMakePoint(xOrigin,selectionView.frame.origin.y)];
	[NSAnimationContext endGrouping];
	
	[self performSelector:@selector(resizeInspectorForMode:) withObject:[NSNumber numberWithInt:3] afterDelay:(duration)];
}

-(void)resizeInspectorForMode:(NSNumber *)aMode
{
	int mode = [aMode intValue];
	float animationDuration = 0.16;
	float smallHeight = 77;
	float largeHeight = 170;
	
	if (mode == 1 && contentView.frame.size.height == smallHeight)
	{
		NSSize frameSize = [contentView frame].size;
		frameSize.height = largeHeight;
		
		[NSAnimationContext beginGrouping];
		[[NSAnimationContext currentContext] setDuration:(animationDuration)];
		[[contentView animator] setFrameSize:frameSize];
		[NSAnimationContext endGrouping];
	}
	else if ((mode == 2 || mode == 3) && contentView.frame.size.height == largeHeight)
	{
		NSSize frameSize = [contentView frame].size;
		frameSize.height = smallHeight;
		
		[NSAnimationContext beginGrouping];
		[[NSAnimationContext currentContext] setDuration:(animationDuration)];
		[[contentView animator] setFrameSize:frameSize];
		[NSAnimationContext endGrouping];
	}
}

@end

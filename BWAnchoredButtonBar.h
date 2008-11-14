//
//  BWAnchoredButtonBar.h
//  BWToolkit
//
//  Created by Brandon Walkin (www.brandonwalkin.com)
//  All code is provided under the New BSD license.
//

#import <Cocoa/Cocoa.h>

@interface BWAnchoredButtonBar : NSView 
{
	BOOL isResizable;
	BOOL isAtBottom;
	int selectedIndex, selectedMinWidthUnit, selectedMaxWidthUnit;
	NSNumber *minWidth, *maxWidth;
}

@property BOOL isResizable;
@property BOOL isAtBottom;
@property int selectedIndex;
@property int selectedMinWidthUnit;
@property int selectedMaxWidthUnit;
@property (copy) NSNumber *minWidth;
@property (copy) NSNumber *maxWidth;

+ (BOOL)wasBorderedBar;

@end

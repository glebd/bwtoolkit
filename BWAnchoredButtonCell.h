//
//  BWAnchoredButtonCell.h
//  BWToolkit
//
//  Created by Brandon Walkin (www.brandonwalkin.com)
//  All code is provided under the New BSD license.
//

#import <Cocoa/Cocoa.h>

@interface BWAnchoredButtonCell : NSButtonCell 
{
	
}

- (void)drawTitleInFrame:(NSRect)cellFrame;
- (void)drawImageInFrame:(NSRect)cellFrame;

@end

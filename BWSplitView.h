//
//  BWSplitView.h
//  BWToolkit
//
//  Created by Brandon Walkin (www.brandonwalkin.com)
//  All code is provided under the New BSD license.
//

#import <Cocoa/Cocoa.h>

@interface BWSplitView : NSSplitView 
{
	NSColor *color;
	BOOL colorIsEnabled, checkboxIsEnabled;
}

@property (copy) NSColor *color;
@property BOOL colorIsEnabled;
@property BOOL checkboxIsEnabled;

@end

//
//  BWSplitViewInspector.m
//  BWToolkit
//
//  Created by Brandon Walkin (www.brandonwalkin.com)
//  All code is provided under the New BSD license.
//

#import "BWSplitViewInspector.h"

@implementation BWSplitViewInspector

- (NSString *)viewNibName {
    return @"BWSplitViewInspector";
}

- (void)refresh {
	// Synchronize your inspector's content view with the currently selected objects
	[super refresh];
}

@end

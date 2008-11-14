//
//  BWSelectableToolbar.h
//  BWToolkit
//
//  Created by Brandon Walkin (www.brandonwalkin.com)
//  All code is provided under the New BSD license.
//

#import <Cocoa/Cocoa.h>
#import "BWSelectableToolbarHelper.h"

@interface BWSelectableToolbar : NSToolbar {
	BWSelectableToolbarHelper *helper;
	
	NSMutableArray *itemIdentifiers;
	NSMutableDictionary *itemsByIdentifier;
	NSWindow *window;
	
	// For the IB inspector
	NSMutableArray *labels;
	int selectedIndex;
	BOOL isPreferencesToolbar;
	
	BOOL inIB;
}

@property(retain) BWSelectableToolbarHelper *helper;
@property(copy) NSMutableArray *labels;
@property BOOL isPreferencesToolbar;

- (void)selectItemAtIndex:(int)anIndex;
- (int)selectedIndex;
- (void)setSelectedIndex:(int)anIndex;
- (NSMutableArray *)labels;
- (void)setLabels:(NSMutableArray *)anArray;
- (void)setDocumentToolbar:(BWSelectableToolbar *)obj;
- (void)selectItemAtIndex:(int)anIndex;

@end

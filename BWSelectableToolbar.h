//
//  BWSelectableToolbar.h
//  BWToolkit
//
//  Created by Brandon Walkin (www.brandonwalkin.com)
//  All code is provided under the New BSD license.
//

#import <Cocoa/Cocoa.h>

@class BWSelectableToolbarHelper;

@interface BWSelectableToolbar : NSToolbar 
{
	BWSelectableToolbarHelper *helper;
	NSMutableArray *itemIdentifiers;
	NSMutableDictionary *itemsByIdentifier;
	BOOL inIB;
	
	// For the IB inspector
	NSMutableArray *labels;
	int selectedIndex;
	BOOL isPreferencesToolbar;
}

// Call one of these methods to set the active tab. 
- (void)setSelectedItemIdentifier:(NSString *)itemIdentifier; // Use if you want an action in the tabbed window to change the tab.
- (void)setSelectedItemIdentifierWithoutAnimation:(NSString *)itemIdentifier; // Use if you want to show the window with a certain item selected.

@end

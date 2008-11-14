//
//  BWSheetController.h
//  BWToolkit
//
//  Created by Brandon Walkin (www.brandonwalkin.com)
//  All code is provided under the New BSD license.
//

#import <Cocoa/Cocoa.h>

@interface BWSheetController : NSObject
{
	IBOutlet NSWindow *sheet;
	IBOutlet NSWindow *parentWindow;
	IBOutlet id delegate;
}

- (IBAction)openSheet:(id)sender;
- (IBAction)closeSheet:(id)sender;
- (IBAction)messageDelegateAndCloseSheet:(id)sender;

@end

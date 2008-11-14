//
//  BWAddRegularBottomBar.m
//  BWToolkit
//
//  Created by Brandon Walkin (www.brandonwalkin.com)
//  All code is provided under the New BSD license.
//

#import "BWAddRegularBottomBar.h"

@implementation BWAddRegularBottomBar

- (id)initWithCoder:(NSCoder *)decoder;
{
    if ((self = [super initWithCoder:decoder]) != nil)
	{
		if ([self respondsToSelector:@selector(ibDidAddToDesignableDocument:)])
			[self performSelector:@selector(addBottomBar) withObject:nil afterDelay:0];			
	}
	return self;
}

- (void)awakeFromNib
{
	[[self window] setContentBorderThickness:34	forEdge:NSMinYEdge];
}

- (NSRect)bounds
{
	return NSMakeRect(-10000,-10000,0,0);
}

@end

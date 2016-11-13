//
//  BaseControl.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 3/14/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import "BaseControl.h"


@implementation BaseControl

@synthesize enabled, visible;

// Init at Position with Width and Height
- (id) init
{
	self = [super init];
	if( self != nil)
	{
		// Set Behaviors
		[self setVisible:TRUE];
		[self setEnabled:TRUE];
	}
	return self;
}


@end

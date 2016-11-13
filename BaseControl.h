//
//  BaseControl.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 3/14/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BaseControl : NSObject 
{
	// Enabled, When true will respond to touch events and updates;
	BOOL enabled;
	
	// Visible, When true will be rendered
	BOOL visible;
}

@property (nonatomic) BOOL enabled, visible;

@end

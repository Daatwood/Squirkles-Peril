//
//  MultiAnimationActor.m
//  BadBadMonkey
//
//  Created by Dustin Atwood on 10/5/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

#import "MultiAnimationActor.h"


@implementation MultiAnimationActor

@synthesize enabled;

// Init
- (id) init
{
	self = [super init];
	if(self != nil)
	{
		actors = [[NSMutableArray alloc] initWithCapacity:1];
		selectedActorIndex = -1;
		sharedSettingManager = [SettingManager sharedSettingManager];
		[self setEnabled:YES];
	}
	return self;
}

// Add Actor based on UID
- (void) addAnimationActorByUID:(uint)uid
{
	
}

// Add Actor based on ImageName
- (void) addAnimationActorByImageName:(NSString*)imageName
{
	
}

// Removing Actor at index
- (void) removeAnimationActorAtIndex:(uint)index
{
	[actors removeObjectAtIndex:index];
}

// Remove All Actors
- (void) removeAllActors
{
	[actors removeAllObjects];
}

// Return Selected Index
- (int) returnSelectedAnimationActorIndex
{
	return selectedActorIndex;
}

// Lock All
- (void) lockAllAnimationActors
{
	[self setEnabled:NO];
	for (int i = 0; i < [actors count]; i++) 
	{
		[[actors objectAtIndex:i] setLocked:TRUE];
	}
}

// Unlock All
- (void) unlockAllAnimationActors
{
	[self setEnabled:YES];
	for (int i = 0; i < [actors count]; i++) 
	{
		[[actors objectAtIndex:i] setLocked:FALSE];
	}
}

// touch began
- (void) touchBeganAtPoint:(CGPoint)beginPoint
{
	if(![self enabled])
		return ;
	
	for(int i = 0; i < [actors count]; i++)
	{
		uint result = 0;
		[[actors objectAtIndex:i] touchBeganAtPoint:beginPoint];
		if(result != 0)
			return ;
	}
	return ;
}

// touch moved
- (void) touchMovedAtPoint:(CGPoint)newPoint
{
	if(![self enabled])
		return ;
	
	
	for(int i = 0; i < [actors count]; i++)
	{
		uint result = 0;
		[[actors objectAtIndex:i] touchMovedAtPoint:newPoint];
		if(result != 0)
			return ;
	}
	return ;
}

// touch ended
- (void) touchEndedAtPoint:(CGPoint)endPoint
{
	if(![self enabled])
		return ;
	
	selectedActorIndex = -1;
	for(int i = 0; i < [actors count]; i++)
	{
		uint result = 0;
		[[actors objectAtIndex:i] touchEndedAtPoint:endPoint];
		if(result != 0)
		{
			selectedActorIndex = i;
			return ;
		}
	}
	return ;
}

// render
- (void) render
{
	// This actor is drawn regardless of enabled/disabled
	
	for(int i = 0; i < [actors count]; i++)
	{
		[[actors objectAtIndex:i] render];
	}
}

// update
- (void) updateWithDelta:(GLfloat)delta
{
	// There is no need to run it while it is disabled
	if(![self enabled])
		return;
	
	for(int i = 0; i < [actors count]; i++)
	{
		[[actors objectAtIndex:i] updateWithDelta:delta];
	}
}

@end

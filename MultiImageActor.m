//
//  MultiImageActor.m
//  BadBadMonkey
//
//  Created by Dustin Atwood on 10/5/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

#import "MultiImageActor.h"


@implementation MultiImageActor

@synthesize enabled, actors, activated, selected;

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
		[self setActivated:NO];
		[self setSelected:NO];
		
	}
	return self;
}

// Add Actor based on UID
- (void) addImageActorByUID:(uint)uid
{
	[actors addObject:[[ImageActor alloc] initWithImageNamed: [sharedSettingManager get:ItemKey_Image withUID:uid] atPosition:CGPointMake(160, 240)]];
}

// Add Actor based on ImageName
- (void) addImageActorByImageName:(NSString*)imageName
{
	[actors addObject:[[ImageActor alloc] initWithImageNamed:imageName atPosition:CGPointMake(160, 240)]];
}

// Removing Actor at index
- (void) removeImageActorAtIndex:(uint)index
{
	[actors removeObjectAtIndex:index];
}

// Remove All Actors
- (void) removeAllActors
{
	[actors removeAllObjects];
}

// Return Selected Index
- (int) returnSelectedImageActorIndex
{
	return selectedActorIndex;
}

// Lock All, and dont become interactable
- (void) lockAllImageActors
{
	[self setEnabled:NO];
	for (int i = 0; i < [actors count]; i++) 
	{
		[[actors objectAtIndex:i] setLocked:TRUE];
	}
	selectedActorIndex = -1;
}

// Unlock All, and become interactable
- (void) unlockAllImageActors
{
	[self setEnabled:YES];
	for (int i = 0; i < [actors count]; i++) 
	{
		[[actors objectAtIndex:i] setLocked:FALSE];
	}
	selectedActorIndex = -1;
}

// touch began
- (void) touchBeganAtPoint:(CGPoint)beginPoint
{
	if(![self enabled])
		return;
	
	selectedActorIndex = -1;
	[self setActivated:NO];
	[self setSelected:NO];
	
	for(int i = 0; i < [actors count]; i++)
	{
		[[actors objectAtIndex:i] touchBeganAtPoint:beginPoint];
		if([[actors objectAtIndex:i] selected])
		{
			[self setSelected:YES];
			selectedActorIndex = i;
			return;
		}
	}
	return;
}

// touch moved
- (void) touchMovedAtPoint:(CGPoint)newPoint
{
	if(![self enabled])
		return;
	
	if(selectedActorIndex != -1)
	{
		[[actors objectAtIndex:selectedActorIndex] touchMovedAtPoint:newPoint];
		[self setSelected:[[actors objectAtIndex:selectedActorIndex] selected]];
	}
	else
		[self setSelected:NO];
}

// touch ended
- (void) touchEndedAtPoint:(CGPoint)endPoint
{
	if(![self enabled])
		return;
	
	if(selectedActorIndex != -1)
	{
		[[actors objectAtIndex:selectedActorIndex] touchEndedAtPoint:endPoint];
		[self setActivated:[[actors objectAtIndex:selectedActorIndex] activated]];
	}
	else
		[self setActivated:NO];
	
	/*
	for(int i = 0; i < [actors count]; i++)
	{
		[[actors objectAtIndex:i] touchEndedAtPoint:endPoint];
		if([[actors objectAtIndex:i] activated])
		{
			selectedActorIndex = i;
			[self setActivated:YES];
			return;
		}
	}
	return;*/
}
- (void) moveActorFrom:(uint)from to:(uint)to
{
	if (to != from) 
	{
		id obj = [actors objectAtIndex:from];
		[obj retain];
		[actors removeObjectAtIndex:from];
		if (to >= [actors count]) 
		{
			[actors addObject:obj];
		} 
		else 
		{
			[actors insertObject:obj atIndex:to];
		}
		[obj release];
	}	
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

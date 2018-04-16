//
//  JumpScrollerBackground.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 12/31/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

#import "JumpScrollerBackground.h"


@implementation JumpScrollerBackground

@synthesize timeLength;

- (id) init
{
	if(self = [super init])
	{
		currentStage = 2;
		currentLevel = 1;
		offset = 0;
		scrollingRate = 1;
		
		bottomBackground = [[Image alloc] initWithImageNamed:@"imageBackground1-3"];
		midBackground = [[Image alloc] initWithImageNamed:@"imageBackground1-1"];
		topBackground = [[Image alloc] initWithImageNamed:@"imageBackground1-2"];
	}
	return self;
}

- (void) reset
{
	currentStage = 2;
	currentLevel = 1;
	offset = 0;
	scrollingRate = 0;
	[bottomBackground release];
	bottomBackground = [[Image alloc] initWithImageNamed:@"imageBackground1-3"];
	[midBackground release];
	midBackground = [[Image alloc] initWithImageNamed:@"imageBackground1-1"];
	[topBackground release];
	topBackground = [[Image alloc] initWithImageNamed:@"imageBackground1-2"];
}

- (void) adjustScrollingRate:(float)newRate
{
	scrollingRate = newRate;
}

- (void) addScroll:(float)scrollAmount withDelta:(float)delta;
{
	if(timeLength == 0)
		timeLength = 1;
	
	offset += (scrollAmount) / scrollingRate; //(PointsPerSecond * timeLength);
	if (offset > [Director sharedDirector].screenBounds.size.height) 
	{
		offset = 0;
		currentStage++;
		if(currentStage > 3)
		{
			currentStage = 1;
			currentLevel++;
			if(currentLevel > 3)
			{
				currentLevel = 3;
				currentStage = 3;
			}
		}
		[bottomBackground release];
		bottomBackground = [midBackground retain];
		[midBackground release];
		midBackground = [topBackground retain];
		[topBackground release];
		topBackground = [bottomBackground retain];
	}
}

- (void) updateWithDelta:(float)delta
{
	
}

- (void) render
{
	[bottomBackground renderAtPoint:CGPointMake(0.0,-[Director sharedDirector].screenBounds.size.height - offset) centerOfImage:NO];
	[midBackground renderAtPoint:CGPointMake(0.0, -offset) centerOfImage:NO];
	[topBackground renderAtPoint:CGPointMake(0.0, [Director sharedDirector].screenBounds.size.height - offset) centerOfImage:NO];
}

@end

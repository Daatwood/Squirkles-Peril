//
//  JumpScrollerPlatformRow.m
//  BadBadMonkey
//
//  Created by Dustin Atwood on 12/27/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

#import "JumpScrollerPlatformRow.h"


@implementation JumpScrollerPlatformRow

@synthesize platform1;

// Initialize the platform
- (id) init
{
	if(self = [super init])
	{
		//NSLog(@"Platform Row Init.");
		platform1 = [[JumpScrollerPlatform alloc] init];
		platform2 = [[JumpScrollerPlatform alloc] init];
		platform3 = [[JumpScrollerPlatform alloc] init];
	}
	return self;
}

// Reset the platform with a new position and type
- (void) resetWithType:(int)newType position:(CGPoint)newPosition theme:(int)newTheme
{
	[platform1 resetWithType:newType position:newPosition theme:newTheme];
	[platform2 resetWithType:newType position:CGPointMake(newPosition.x - [Director sharedDirector].screenBounds.size.width , newPosition.y) theme:newTheme];
	[platform3 resetWithType:newType position:CGPointMake(newPosition.x + [Director sharedDirector].screenBounds.size.width, newPosition.y)  theme:newTheme];
}

// Update's the platform
- (void) updateWithDelta:(GLfloat)delta
{
	[platform1 updateWithDelta:delta];
	[platform2 updateWithDelta:delta];
	[platform3 updateWithDelta:delta];
}

// Applys accelerometer to the player.
- (void) applyAccelerometer:(GLfloat)data
{
	[platform1 applyAccelerometer:data];
	[platform2 applyAccelerometer:data];
	[platform3 applyAccelerometer:data];
}

// Applies velocity to the platform
- (void) applyVelocity:(float)velocity
{
	[platform1 applyVelocity:velocity];
	[platform2 applyVelocity:velocity];
	[platform3 applyVelocity:velocity];
}

// Collision Check Method, returns points earned for collision
- (int) hasCollidedWithPlayer:(JumpScrollerPlayer*)player withDelta:(GLfloat)delta;
{
	if([platform1 hasCollidedWithPlayer:player withDelta:delta])
		return [platform1 retrieveAwardPoints];
	else if([platform2 hasCollidedWithPlayer:player withDelta:delta])
		return [platform2 retrieveAwardPoints];
	else if([platform3 hasCollidedWithPlayer:player withDelta:delta])
		return [platform3 retrieveAwardPoints];
	
	return 0;
}

// Renders the platform object
- (void) render
{
	//NSLog(@"Rendering Platform witihn Row");
	[platform1 render];
	[platform2 render];
	[platform3 render];
	
}

- (CGPoint) position
{
	return [platform1 position];
}

- (void) setNewPosition:(CGPoint)newPosition
{
	[platform1 setPosition:newPosition];
	[platform2 setPosition:CGPointMake(newPosition.x - [Director sharedDirector].screenBounds.size.width, newPosition.y)];
	[platform3 setPosition:CGPointMake(newPosition.x + [Director sharedDirector].screenBounds.size.width, newPosition.y)];
}

- (BOOL) isAlive
{
	return [platform1 isAlive];
}

@end

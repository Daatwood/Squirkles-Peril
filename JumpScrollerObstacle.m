//
//  JumpScrollerObstacle.m
//  BadBadMonkey
//
//  Created by Dustin Atwood on 11/21/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

#import "JumpScrollerObstacle.h"

@implementation JumpScrollerObstacle

@synthesize isAlive, movementDirection, offset, bounceOffset;

// Initialize the platform
- (id) initWithTheme:(int)theme
{
	if(self = [super init])
	{
		if (theme == PlatformTheme_Cloud) 
		{
			obstacleImageLeft = [[Image alloc] initWithImageNamed:@"CloudCivilianLeft"];
			obstacleImageRight = [[Image alloc] initWithImageNamed:@"CloudCivilianRight"];
		}
		else if (theme == PlatformTheme_Space) 
		{
			obstacleImageLeft = [[Image alloc] initWithImageNamed:@"RockPersonLeft"];
			obstacleImageRight = [[Image alloc] initWithImageNamed:@"RockPersonRight"];
		}
		isAlive = TRUE;
		offset = 0;
		isMoving = FALSE;
		movementDirection = RANDOM(2);
		changeAction = 0.5 + RANDOM_0_TO_1();
		
		bounceUp = TRUE;
		bounceOffset = 0;
	}
	return self;
}

// Update's the platform
- (void) updateWithDelta:(GLfloat)delta
{
	if (!isAlive) 
		return;
	
	changeAction -= delta;
	
	if(changeAction <= 0)
	{
		// Random Facing Direction; 0Left, 1Right
		movementDirection = RANDOM(2);
		
		// Moving or Not Moving
		if (RANDOM(2)) 
			isMoving = TRUE;
		else
			isMoving = FALSE;
		
		// Timer for next Action
		changeAction = 0.5 + RANDOM_0_TO_1();
	}
	
	if(isMoving)
	{
		if(movementDirection == 0)
			offset -= delta * 13;
		else if(movementDirection == 1)
			offset += delta * 13;
	}
	
	
	
	// ANIMATION BOUNCE
	if(bounceUp)
		bounceOffset += delta * 12;
	else
		bounceOffset -= delta * 12;
	
	if (bounceOffset > 2.5) 
		bounceUp = FALSE;
	else if (bounceOffset < -2.5) 
		bounceUp = TRUE;
}

// Renders the platform object
- (void) renderAtPosition:(CGPoint)position;
{
	if (!isAlive) 
		return;
	
	if(movementDirection == 0)
		[obstacleImageLeft renderAtPoint:CGPointMake(position.x + offset - 10, position.y + 20 + bounceOffset) centerOfImage:FALSE];
	else if(movementDirection == 1)
		[obstacleImageRight renderAtPoint:CGPointMake(position.x + offset - 10, position.y + 20 + bounceOffset) centerOfImage:FALSE];
	
	
}

- (void) dealloc
{
	[super dealloc];
}

@end

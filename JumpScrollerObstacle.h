//
//  JumpScrollerObstacle.h
//  BadBadMonkey
//
//  Created by Dustin Atwood on 11/21/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

// The JumpScrollerObstacle is the Obstacle for the player
// They some how inhibit the player's progress.

// There are many different types of obstacles:
// 1. Simple - Simple creature sits on platfom
// (Rectangluar cloud creature)
// 2. Space Alien - Simple creature that doesnt float on platform
// (Alien on hovering spaceship with a claw)
// 3. 

#import <Foundation/Foundation.h>
#import "Image.h"
#import "Common.h"
#import "JumpScrollerPlayer.h"

@interface JumpScrollerObstacle : NSObject 
{
	BOOL isAlive;
	
	// The image of the obstacle
	Image *obstacleImageLeft;
	Image *obstacleImageRight;
	
	// the X offset from origin
	float offset;
	
	// Direction of movement
	short movementDirection;
	BOOL isMoving;
	
	// Time before it moves: left, right or stops
	float changeAction;
	
	// SFAP
	// Animation Walking Bounce
	BOOL bounceUp;
	float bounceOffset;
}

@property(nonatomic) BOOL isAlive;
@property(nonatomic) short movementDirection;
@property(nonatomic) float offset, bounceOffset;

// Initialize the platform
- (id) initWithTheme:(int)theme;

// Update's the platform
- (void) updateWithDelta:(GLfloat)delta;

// Renders the platform object
- (void) renderAtPosition:(CGPoint)position;

@end

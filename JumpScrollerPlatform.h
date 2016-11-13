//
//  JumpScrollerPlatform.h
//  BadBadMonkey
//
//  Created by Dustin Atwood on 11/21/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

// The JumpScrollerPlatform is the land points of the player
// They provide a place to land and to jump higher.
// There are many different types of platforms:

/*

 [Level 1]
 Normal: Normal Platfom.
 Fake: Not an actual platform.
 Dissolve: Only lasts for 1 hit.
 [Level 2]
 H.Moving: Moves right and left.
 Bouncy: Provides a higher than normal jump.
 M.Fake: Fake H Moving platform.
 [Level 3]
 Ship: Provides a long constant boost
 V.Moving: Moves up and down.
 Explosive: Timed usable platform.
 
*/


// Starter-3 - These are used in the beginning their width is longer than the average platform
// (Large Smoke Clouds) 
// Basic-5 - These are the average platforms, each varies in width
// (Normal Clouds) 
// Fake-0 - These will dissappearing instantly upon landing and do not provide a jump.
// (Normal Clouds that look like as if they have been boarded to the background)
// Dissolve-8 - These will provide a jump before dissappearing
// (A Thin Cloud that disperses upon jump)
// Moving-6 - These are basic platforms that will change their horizontal position continously.
// (A Normal looking cloud)
// Ghost-10 - Thses platforms will fade from usuable to unusable
// (A Normal looking cloud)
// Boost-5 - Basic platforms that provide a much bigger than normal jump.
// (A Hovering Empty Spaceship)

// There are many different types of obstacles:
// 1. Platform - Creature appears on platforms
// (Rectangluar cloud creature)
// 2. Space Alien - Creature may appear in spaceship, once knocked out user may use it.
// (Alien on hovering spaceship)

#import <Foundation/Foundation.h>
#import "Common.h"
#import "Image.h"
#import "JumpScrollerPlayer.h"
//#import "MGSkyObstacle.h"
#import "ParticleEmitter.h"

@interface JumpScrollerPlatform : NSObject 
{
	ParticleEmitter* emitter;
	
	// The top left position of the platform
	CGPoint position;
	// The width and height of the platform
	CGSize size;
	// The type of the platform
	int platformType, platformTheme;
	// Platform Image
	Image* platformImage;
	Image* platformImageSecondary;
	// Determines if the platform needs a new placement
	BOOL isAlive;
	// Determines if the platform is no longer usable
	BOOL isUsable;
	
	//Type Dependant Variables
	// Determines which way the platform moves
	int movementDirection;
	// How far the platform has moved. Only for Vertical
	float movementOffset;
	// Timer used for various platforms
	float coutdownTimer;
	
	// Determines how many points the platfrom can award.
	// After a successful jump platforms dont reward anymore points;
	float awardPoints;
	
	// Bounce Animation Properties
	int currentBounce; 
	
	//MGSkyObstacle* obstacle;
}

@property(nonatomic) CGPoint position;
@property(nonatomic) CGSize size;
@property(nonatomic) int platformType, movementDirection, platformTheme;
@property(nonatomic) BOOL isUsable, isAlive;

// Initialize the platform
- (id) init;

- (void) createCloudPerson;

// Reset the platform with a new position and type
- (void) resetWithType:(int)newType position:(CGPoint)newPosition theme:(int)newTheme;

// Update's the platform
- (void) updateWithDelta:(GLfloat)delta;

// Applys accelerometer to the player.
- (void) applyAccelerometer:(GLfloat)data;

// Applies velocity to the platform
- (void) applyVelocity:(float)velocity;

// Collision Check Method
- (BOOL) hasCollidedWithPlayer:(JumpScrollerPlayer*)player withDelta:(GLfloat)delta;

// Renders the platform object
- (void) render;

- (int) retrieveAwardPoints;

@end

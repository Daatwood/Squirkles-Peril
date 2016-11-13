//
//  MGSkyEnemy.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 3/2/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

/*
 Enemey Powers:
 Circle: Collision Response
 Triangle: Death
 Square: Leader + Collision Response
 Octagon: Shrink all Current Platforms
 Honeycomb: Shield all Enemys
 Diamond: Slow Player
 Star: Explosion
 Oddity: (Square) + (Honeycomb) + Summon Shapes
*/

#import <Foundation/Foundation.h>
#import "ParticleEmitter.h"
#import "Image.h"
#import "Common.h"
#import "Director.h"
#import "MGSkyPlayer.h"
#import "MGSkyPlatform.h"
#import "SettingManager.h"

@interface MGSkyEnemy : NSObject 
{	
	// (true) Will be removed from game
	BOOL readyForDeletion;
	// (true) Will be updated and rendered
	BOOL isAlive;
	// (true) Will move Randomly or at Player.
	BOOL isLeader;
	
	// (true) Will move at Leader
	MGSkyEnemy* leaderEnemy;
	
	// Current Shape of the Enemy
	Shape_Level shapeCurrent;
	
	// The Body Image
	Image *imageBody;
	// The Eye Images
	Image *imageEyes;

	// Current Position
	CGPoint positionCurrent;
	
	// Current Acceleration
	CGPoint accelerationCurrent;
	
	// Current Velocity
	CGPoint velocityCurrent;
	
	// Position Enemy is moving towards
	CGPoint positionTarget;
	
	// Time until the Enemy will change its target position
	float tillTargetChange;
}

@property(nonatomic) CGPoint positionCurrent, velocityCurrent, accelerationCurrent, positionTarget;
@property(nonatomic) BOOL readyForDeletion, isAlive, isLeader;

// Initialize the Obstacle
- (id) initAsShape:(Shape_Level)shape;

// Update method with the owning game scene
- (void) updateWithDelta:(GLfloat)delta withNeighbors:(NSMutableArray*)neighbors andPlayer:(MGSkyPlayer*)player;

// Collision Check Method
- (int) hasCollidedWithPlayer:(MGSkyPlayer*)player withDelta:(GLfloat)delta;

// Applys accelerometer to the player.
- (void) applyAccelerometer:(GLfloat)data;

// Applies velocity to the platform
- (void) applyVelocity:(float)velocity;

// Renders the Obstacle
- (void) render;

- (void) flocking:(NSArray*)neighbors;

- (CGPoint) flockingSeperate:(NSArray*)neighbors;

- (CGPoint) flockingAlignment:(NSArray*)neighbors;

- (CGPoint) flockingCohesion:(NSArray*)neighbors;

- (CGPoint) steerTowardPosition:(CGPoint)positionTarget;

- (void) assignLeader:(MGSkyEnemy*)newLeader;

@end

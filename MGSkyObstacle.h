//
//  MGSkyObstacle.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 2/15/11.
//  Copyright 2011 Dustin Atwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParticleEmitter.h"
#import "Image.h"
#import "Common.h"
#import "Director.h"
#import "MGSkyPlayer.h"
#import "MGSkyPlatform.h"
/*
 
 Obstacles can be two main types, Harmful or Harmless.
 All Obstacles can be killed by landing ontop of.
 Harmful obstacles will kill the player if touched from underneath.
 They will also try and stay above the player. 
 Both will have a different Appearance.
 
 When a player kills the platform the obstacle is on
	it will become angered and turn harmful!
 
 When Harmful the Obstacle will emit small Lightning bolts at a slow
	pace around its top half of its body.
 
*/

@interface MGSkyObstacle : NSObject 
{
	BOOL readyForDeletion;
	BOOL isAlive;
	BOOL isHarmful;
	CGPoint positionObstacle;
	ParticleEmitter *emitter;
	int themeObstacle;
	Color4f colorObstacle;
	
	// Platform Creator, may be nil
	MGSkyPlatform* owner;
	
	// Images
	NSMutableArray *imagesObstacle;
	
	// Harmful Properties
	CGPoint direction;
	
	// Harmless Properties
	short movementDirection;
	BOOL isMoving;
	float timeBeforeActionChange;

	// Animation Properties
	BOOL bounceUp;
	float bounceOffset;
}

@property(nonatomic) CGPoint positionObstacle;
@property(nonatomic) BOOL readyForDeletion;

// Initialize the Obstacle
- (id) initWithTheme:(int)theme withOwner:(MGSkyPlatform*)platformOwner;

// Turn to Harmful
- (void) turnHarmful;

// Flips Direction
- (void) flipDirection;

// Kills the Obstacle
- (void) die;

// Update's the Obstacle
- (void) updateWithDelta:(GLfloat)delta givenPlayer:(MGSkyPlayer*)player;

// Applys accelerometer to the player.
- (void) applyAccelerometer:(GLfloat)data;

// Applies velocity to the platform
- (void) applyVelocity:(float)velocity;

// Collision Check Method
- (int) hasCollidedWithPlayer:(MGSkyPlayer*)player withDelta:(GLfloat)delta;

// Renders the Obstacle
- (void) render;

@end

//
//  MGSkyPlatform.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 2/15/11.
//  Copyright 2011 Dustin Atwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParticleEmitter.h"
#import "Common.h"
#import "MGSkyPlayer.h"
/*
 MGSkyPlatform is the new generation of platform. The older
 generation was limited on its ability to preform.The Newer
 version can handle destruction of various objects creation
 and removal better. Should help to eliminate the need for
 a platform row and also will be able to animate.
 
 Platforms now have a degrades factor.
 After a repeated number of jumps the platform will begin to
 degrade and eventually pop like dissolve platforms.
 
 The different type of platforms are:
 Normal - Standard platform.
 Dissolve - Allow for only one jump.
 Fake - Does not support any weight and will break away on touch.
 Bouncy - Allows for a large jump and degrades fast.
 Moving - Standard platform that moves in 1 direction.
 Net - Large Standard Platform and degrades slowly.
 Ship - Turns into a Player's Spaceship
 Explosive - ????
 Star - Increases player's speed reguardless of velocity direction
*/

@interface MGSkyPlatform : NSObject 
{
	// Emitter
	ParticleEmitter *emitter;
	
	// Images
	NSMutableArray *imagesPlatform;
	
	// Properties
	// If the platform is ready to be deleted
	BOOL readyForDeletion;
	// If the platform is Usable
	BOOL isUsable;
	// The Platform's Position
	CGPoint positionPlatform;
	// The Platform's Position
	CGSize sizePlatform;
	// The Platform's Theme
	int themePlatform;
	// The Platform's Type
	int typePlatform;
	// The Platform's Color
	Color4f colorPlatform;
	// Direction of Movement [(-1) - None,0 - Left,1 - Right] 
	short movementDirection;
	// Number of Supported Jumps
	short supportedJumps;
	// Number of Points Awarded on first jump
	float awardPoints;
	// Points Active
	BOOL earnedPoints;
	
	//Animation
	int animationBounce;
	float animationTimer;
	int imageIndex;
}
@property(nonatomic) BOOL readyForDeletion;
@property(nonatomic) BOOL isUsable;
@property(nonatomic) BOOL earnedPoints;
@property(nonatomic) int typePlatform;
@property(nonatomic) CGPoint positionPlatform;
@property(nonatomic) CGSize sizePlatform;

// Initialize the Platform
- (id) initWithTheme:(int)theme andType:(int)type atPosition:(CGPoint)pos;

// Kills the Platform
- (void) die;

// Returns the reward points
- (int) rewardPoints;

// Update's the Platform
- (void) updateWithDelta:(GLfloat)delta givenPlayer:(MGSkyPlayer*)player;

// Applys accelerometer to the Platform.
- (void) applyAccelerometer:(GLfloat)data;

// Applies velocity to the Platform
- (void) applyVelocity:(float)velocity;

// Collision Check Method
- (void) hasCollidedWithPlayer:(MGSkyPlayer*)player withDelta:(GLfloat)delta;

// Renders the Platform
- (void) render;

@end

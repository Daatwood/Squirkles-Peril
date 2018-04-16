//
//  MGSkyPlayer.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 2/16/11.
//  Copyright 2011 Dustin Atwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "ParticleEmitter.h"
#import "Image.h"

@interface MGSkyPlayer : NSObject 
{
	// Emitter for basic Needs: Jump, Die, Ship Explosion
	ParticleEmitter* emitter;
	
	// Emitter for Ship Thrust
	ParticleEmitter* emitterShip;
	
	// Quick Reference for player's color
	Color4f playerColor;
	
	// Array of Body Images
	NSMutableArray* imagesBody;
	// Array of Eyes Images
	NSMutableArray* imagesEyes;
	// Array of Antenna Images
	NSMutableArray* imagesAntenna;
	// Ship Images
	NSMutableArray* imagesShip;
	Image* imageShipFront;
	Image* imageShipBack;
	
	// Current Antenna Image Index
	int imageIndexAntenna;
	// Current Body Image Index
	int imageIndexBody;
	// Current Eyes Image Index
	int imageIndexEyes;
	
	// Player Tilt
	float tiltPlayer;
	// The current position of the player
	CGPoint positionPlayer;
	// The current velocity of the player
	CGPoint velocityPlayer;
	// The Player Width n Height for collisions
	CGSize sizePlayer;
	
	// Determines if the Player Object has reached EOF
	BOOL readyForDeletion;
	// Determines if the Player Object can accept Input
	BOOL isAlive;
	// Determines if the Player Object is in Ship
	BOOL inShip;
	// The Time of Life Left on ship
	float shipTimer;
	// Distance before Death.
	float fallingDistanceLeft;
}
@property(nonatomic) CGSize sizePlayer;
@property(nonatomic) CGPoint positionPlayer, velocityPlayer;
@property(nonatomic) BOOL readyForDeletion, isAlive, inShip;

// Initializes the player
- (id) init;

// Antenna, Eyes, Colors
- (void) adjustImagesBodyStyle:(NSString*)bodyStyleImage
					 BodyPattern:(NSString*)bodyPatternImage
					 Antenna:(NSString*)antennaImage 
						eyes:(NSString*)eyesImage 
					   color:(NSString*)colorString;

// Resets the player back to starting variables;
- (void) reset;

// Spawns Jumping Effect
- (void) createJumpEffect;

// Initiates a normal jump;
- (BOOL) applyJump;

// Initiates a Small jump
- (BOOL) applySmallJump;

// Initiates a Super jump
- (BOOL) applySuperJump;

// Initiates a Ship
- (BOOL) applyShip;

// Boost provides speed reguardless of velocity
- (BOOL) applyBoost;

// Kills the player
- (void) die;

// Update's the player
- (void) updateWithDelta:(GLfloat)delta;

// Applys accelerometer to the player.
- (BOOL) applyAccelerometer:(GLfloat)data;

// Applys velocity to the platform
- (void) applyVelocity:(float)velocity;

// Render's the player
- (void) render;

@end

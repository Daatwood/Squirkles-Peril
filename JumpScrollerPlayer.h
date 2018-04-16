//
//  JumpScrollerPlayer.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 11/21/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

/*

 The pet image itself will be broken into small parts.
 Body, Feet, Eyes, Mouth, Antennas.
 The pet may have animations for each part.
 Feet animating in facing direction and jumps.
 Eyes animating in facing direction and jumps.
 Body animating in facing direction.
 Mouth animating in facing direction.
 Antenna animating in facing direction.
 
 
*/

#import <Foundation/Foundation.h>
#import "Common.h"
#import "Image.h"
#import "ParticleEmitter.h"

@interface JumpScrollerPlayer : NSObject 
{
	BOOL readyForDeletion;
	
	ParticleEmitter* emitterJumping;
	Color4f playerColor;
	ParticleEmitter* emitter;
	ParticleEmitter* emitterBoost;
	ParticleEmitter* emitterBoostMax;
	NSMutableArray* petImageBody;
	int currentBodyIndex;
	NSMutableArray* petImageEyes;
	int currentEyesIndex;
	NSMutableArray* petImageAntenna;
	int currentAntennaIndex;
	
	Image* imageShipFront;
	Image* imageShipBack;
	
	float rotation;
	// The current position of the player
	CGPoint position;
	// The current velocity of the player
	CGPoint velocity;
	// Once this is mark as false the game will restart
	BOOL isAlive;
	
	BOOL inShip;
	float shipTimer;
	
	float fallingDistanceLeft;
	
}
@property(nonatomic) CGPoint position, velocity;
@property(nonatomic) BOOL isAlive, inShip;

// Initializes the player
- (id) init;

// Antenna, Eyes, Colors
- (void) adjustImagesAntenna:(NSString*)antennaImage 
						eyes:(NSString*)eyesImage color:(NSString*)colorString;

// Resets the player back to starting variables;
- (void) reset;

- (void) createJumpEffect;

// Initiates a jump;
- (BOOL) applyJump;

// Initiates a Small jump!
- (BOOL) applySmallJump;

// Initiates a Super jump!
- (BOOL) applySuperJump;

- (BOOL) applyShip;

// Boost provides speed reguardless of velocity
- (BOOL) applyBoost;

// Applies Jump Velocity;
- (void) applyVelocityWithDelta:(GLfloat)delta;

// Update's the player
- (void) updateWithDelta:(GLfloat)delta;

// Applys accelerometer to the player.
- (BOOL) applyAccelerometer:(GLfloat)data;

// Render's the player
- (void) render;

@end

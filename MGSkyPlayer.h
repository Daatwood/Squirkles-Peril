//
//  MGSkyPlayer.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 2/16/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "ParticleEmitter.h"
#import "Image.h"
#import "SoundManager.h"

typedef struct 
{
	CGPoint		playerPosition;
    CGPoint     playerVelocity;
    Float32       playerTilt;
    
} PlayerInfo;

typedef struct {
    Color4f playerColor;
    NSString* playerBody; // The selected Body Image Name
    NSString* playerAntenna; // The selected Antenna Image Name
    NSString* playerEyes; // The selected Eyes Image Name
} PlayerSetup;

static const CGSize sizePlayer = {16,16};

@interface MGSkyPlayer : NSObject 
{
    // Shared Information
    // ----
    // Position, Velocity, Tilt
    PlayerInfo playerInfo;
    // Color, Body, Antenna, Eyes
    PlayerSetup playerSetup;
    
    
    // Effects
    // ----
	// Emitter for basic Needs: Jump, Die, Ship Explosion
	ParticleEmitter* emitter;
	
    // Animations
    // ----
	// Array of Body Images
	NSMutableArray* imagesBody;
	// Array of Eyes Images
	NSMutableArray* imagesEyes;
	// Array of Antenna Images
	NSMutableArray* imagesAntenna;
	// Ship Images
	NSMutableArray* imagesShip;
	// Current Antenna Image Index
	int imageIndexAntenna;
	// Current Body Image Index
	int imageIndexBody;
	// Current Eyes Image Index
	int imageIndexEyes;
	
    // Internal
    // ----
	// Determines if the Player Object has reached EOF
	BOOL readyForDeletion;
	// Determines if the Player Object can accept Input
	BOOL isAlive;
	// Determines if the Player Object currently has boost active
	BOOL isBoosting;
	// The Time of Life Left on boost duration
	float boostTimer;
	// Distance before Death.
	float fallingDistanceLeft;
}
@property(nonatomic) PlayerInfo playerInfo;
@property(nonatomic) PlayerSetup playerSetup;

@property(nonatomic) BOOL readyForDeletion, isAlive, isBoosting;

@property(nonatomic) CGSize sizePlayer;

// Initializes the player
- (id) init;

// Antenna, Eyes, Colors
- (void) adjustImagesBodyType:(NSString*)bodyType
                      Antenna:(NSString*)antennaImage 
                         eyes:(NSString*)eyesImage 
                        color:(NSString*)colorString;

- (void) adjustImages;

// Resets the player back to starting variables;
- (void) reset;

- (void) setVelocityTo:(CGPoint)newVelocity;

- (void) setPositionTo:(CGPoint)newPosition;

// Spawns Jumping Effect
- (void) createJumpEffect;

// Initiates a normal jump;
- (BOOL) applyJump;

// Initiates a Small jump
- (BOOL) applySmallJump;

// Initiates a Super jump
- (BOOL) applySuperJump;

// Boost provides speed capped at a max velocity
- (BOOL) applyFlyingJump;

// Initiates a Boost
- (BOOL) applyBoost;

// Kills the player
- (void) die;

// Update's the player
- (void) updateWithDelta:(GLfloat)delta;

// Applys accelerometer to the player.
- (BOOL) applyAccelerometer:(GLfloat)data;

// Applys velocity to the player
- (void) applyVelocity:(float)velocity;

// Render's the player
- (void) render;

@end

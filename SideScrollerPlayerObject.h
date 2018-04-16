//
//  SideScrollerPlayerObject.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 11/5/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "Image.h"

#define accelerationBasic 0.1
#define heightAcceleration 3
#define heightMaximum 50
#define gravity 1.5

@interface SideScrollerPlayerObject : NSObject 
{
	NSMutableArray* petImageBody;
	int currentBodyIndex;
	NSMutableArray* petImageEyes;
	int currentEyesIndex;
	NSMutableArray* petImageAntenna;
	int currentAntennaIndex;
	
	/*
	Image* petImageHopStart;
	Image* petImageHopEnd;
	Image* petImageJump;
	Image* petImageFall;
	 
	
	Image* petEyes;
	Image* petSmile;
	 */
	
	// Animation hopping
	BOOL bounceUp;
	float bounceOffset;
	float runningTimer;
	
	// The player's image
	//Image* petImage;
	// The current position of the player
	CGPoint position;
	// The current velocity of the player
	CGPoint velocity;
	// Determines if the player can jump.
	BOOL onGround;
	// Determines if the player can doubleJump
	BOOL canDoubleJump;
	// Once this is mark as false the game will restart
	BOOL isAlive;
	// When the player is flying he is position at a set height and will increase its speed to max x2
	// for a period of time, once it is over the pet will begin slowing down, when hitting the ground
	// he will be at speed 200.
	BOOL isFlying;
	// For the flying timer, 20% of the initial time reaching height and speed, 60% of the time flying
	// another 20% for landing.
	float timerFlying;
}

//@property(nonatomic) float totalPoints;
//@property(nonatomic) float speedCurrent, fallAcceleration;
@property(nonatomic) CGPoint position, velocity;
@property(nonatomic) BOOL onGround, canDoubleJump, isAlive, isFlying;
@property(nonatomic) float timerFlying;

// Initializes the player
- (id) init;

// Antenna, Eyes, Colors
- (void) adjustImagesAntenna:(NSString*)antennaImage 
						eyes:(NSString*)eyesImage color:(NSString*)colorString;

// Resets the player back to starting variables;
- (void) reset;

// Initiates a jump;
- (void) jump;

// Update's the player
- (void) updateWithDelta:(GLfloat)delta;

// Applys the player's velocity
- (void) applyVelocity;

// Render's the player
- (void) render;


@end

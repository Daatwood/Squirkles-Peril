//
//  SideScrollerGroundObject.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 11/5/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Common.h"
#import "Image.h"
#import "SideScrollerPlayerObject.h"

@interface SideScrollerGroundObject : NSObject 
{
	// The top left position of the ground object
	CGPoint position;
	// The width and height of the ground object
	CGSize size;
	// The type of ground object
	int islandType;
	// An array of images
	NSMutableArray* imageBlocks;
	// Determines if the ground object needs to be reset
	BOOL isAlive;
	// Determines if the ground has began collasping
	BOOL isCollasping;
	// How fast the ground is collasping
	float collaspingSpeed;
	// The position of the bomb, if there is one
	float bombPosition;
	// Position of the obstacle if it has spawned
	float obstaclePosition;
	// Amount of resets needed to spawn.
	float obstacleTimer;
	// Position of the obstacle if it has spawned
	float boostPosition;
	// Amount of resets needed to spawn.
	float boostTimer;
}

@property(nonatomic) CGPoint position;
@property(nonatomic) CGSize size;
@property(nonatomic) int islandType;
@property(nonatomic) BOOL isAlive, isCollasping;

// Initialize the ground
- (id) init;

// Reset the ground with a new position, size and type
- (void) resetWithType:(int)newType position:(CGPoint)newPosition size:(CGSize)newSize;

// Applies velocity to the ground
- (void) applyVelocity:(CGPoint)velocity;

// Collision Check Method
- (BOOL) hasCollidedWithPlayer:(SideScrollerPlayerObject*)player;

// Renders the ground object
- (void) render;

@end

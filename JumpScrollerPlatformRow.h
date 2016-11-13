//
//  JumpScrollerPlatformRow.h
//  BadBadMonkey
//
//  Created by Dustin Atwood on 12/27/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JumpScrollerPlatform.h"
#import "Director.h"

@interface JumpScrollerPlatformRow : NSObject 
{
	JumpScrollerPlatform* platform1;
	
	JumpScrollerPlatform* platform2;
	
	JumpScrollerPlatform* platform3;
}

@property(nonatomic, readonly) JumpScrollerPlatform* platform1;

// Initialize the platform
- (id) init;

// Reset the platform with a new position and type
- (void) resetWithType:(int)newType position:(CGPoint)newPosition theme:(int)newTheme;

// Update's the platform
- (void) updateWithDelta:(GLfloat)delta;

// Applys accelerometer to the player.
- (void) applyAccelerometer:(GLfloat)data;

// Applies velocity to the platform
- (void) applyVelocity:(float)velocity;

// Collision Check Method, returns points earned for collision
- (int) hasCollidedWithPlayer:(JumpScrollerPlayer*)player withDelta:(GLfloat)delta;

// Renders the platform object
- (void) render;

- (CGPoint) position;

- (void) setNewPosition:(CGPoint)newPosition;

- (BOOL) isAlive;

@end

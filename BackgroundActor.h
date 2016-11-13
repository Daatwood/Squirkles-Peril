//
//  BackgroundActor.h
//  BadBadMonkey
//
//  Created by Dustin Atwood on 10/27/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

// Background Actor is responsible for displaying the background stage image
// and for transitioning to a new stage image.
// Each Background is 960 by 480. This is to allow for a 


#import <Foundation/Foundation.h>
#import "Image.h"
#import "Common.h"
#import "SettingManager.h"
#import "Director.h"
#import "SoundManager.h"

@interface BackgroundActor : NSObject 
{
	// The Offset of the current Image([X]Min/Max +/-512),([Y]Min/Max -240/+720)
	CGPoint position;
	
	// Enabled, When true will respond to touch events.
	BOOL enabled;
	
	// Touched, Returns if the control is being performed upon.
	BOOL touched;
	
	// Locked, Prevents the control from entering editing state.
	BOOL locked;
	
	// The current state of the actor
	// Normal=0, Moving: Up1, Down2, Left3, Right4.
	uint state;
	
	// reference to settings manager
	SettingManager* sharedSettingManager;
	
	// reference to sound manager
	SoundManager* sharedSoundManager;
	
	// Current Background Image
	Image* currentImage;
	
	// Next Background Image
	Image* nextImage;
	
	// Lock Image
	Image* lockImage;
	
	// The index of the current stage
	int index;
	
	float xDifference;
}
@property (nonatomic) uint state;
@property (nonatomic) BOOL enabled, touched, locked;
@property (nonatomic) CGPoint position;

// Init at Position with Width and Height
- (id) initWithImageName:(NSString*)imageName;

// Begins loading the next stage
- (void) nextStage;

// Begins loading the previous stage
- (void) previousStage;

// resets the actor states
- (void) resetStates;

// checks the bounding box
- (BOOL) checkBoundingBox:(CGPoint)point;

// touch began
- (void) touchBeganAtPoint:(CGPoint)beginPoint;

// touch moved
- (void) touchMovedAtPoint:(CGPoint)newPoint;

// touch ended
- (void) touchEndedAtPoint:(CGPoint)endPoint;

// render
- (void) render;

// update
- (void) updateWithDelta:(GLfloat)delta;

@end

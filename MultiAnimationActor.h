//
//  MultiAnimationActor.h
//  BadBadMonkey
//
//  Created by Dustin Atwood on 10/5/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationActor.h"
#import "Common.h"
#import "SettingManager.h"


@interface MultiAnimationActor : NSObject 
{
	// Contains all AnimationActors, mutable to allow for growth and shrink.
	NSMutableArray* actors;
	
	// Selected index of the actor
	int selectedActorIndex;
	
	// Instance of sharedSettingManager
	SettingManager* sharedSettingManager;
	
	// When actor is enabled the actors are interactable
	BOOL enabled;
}

@property (nonatomic) BOOL enabled;

// Init
- (id) init;

// Add Actor based on UID
- (void) addAnimationActorByUID:(uint)uid;

// Add Actor based on ImageName
- (void) addAnimationActorByImageName:(NSString*)imageName;

// Removing Actor at index
- (void) removeAnimationActorAtIndex:(uint)index;

// Remove All Actors
- (void) removeAllActors;

// Return Selected Index
- (int) returnSelectedAnimationActorIndex;

// Lock All
- (void) lockAllAnimationActors;

// Unlock All
- (void) unlockAllAnimationActors;

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
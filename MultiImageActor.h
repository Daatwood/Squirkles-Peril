//
//  MultiImageActor.h
//  BadBadMonkey
//
//  Created by Dustin Atwood on 10/5/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

// An Actor that contains many independant ImageActors.
// By Containing many ImagActors in a single class it allows
//  for each ImageActor easily by calling a single class.

#import <Foundation/Foundation.h>
#import "ImageActor.h"
#import "Common.h"
#import "SettingManager.h"

@interface MultiImageActor : NSObject 
{
	// Contains all ImageActors, mutable to allow for growth and shrink.
	NSMutableArray* actors;
	
	// Selected index of the actor
	int selectedActorIndex;
	
	// Instance of sharedSettingManager
	SettingManager* sharedSettingManager;

	// When actor is enabled the actors are interactable
	BOOL enabled;
	// When actor contains a successfull touch
	BOOL activated, selected;
}

@property (nonatomic) BOOL enabled,activated,selected;
@property (nonatomic, copy) NSMutableArray* actors;

// Init
//- (id) init;

// Add Actor based on UID
- (void) addImageActorByUID:(uint)uid;

// Add Actor based on ImageName
- (void) addImageActorByImageName:(NSString*)imageName;

// Removing Actor at index
- (void) removeImageActorAtIndex:(uint)index;

// Remove All Actors
- (void) removeAllActors;

// Return Selected Index
- (int) returnSelectedImageActorIndex;

// Lock All
- (void) lockAllImageActors;

// Unlock All
- (void) unlockAllImageActors;

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

// Move an actor from a position to another
- (void) moveActorFrom:(uint)from to:(uint)to;

@end

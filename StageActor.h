//
//  StageActor.h
//  BadBadMonkey
//
//  Created by Dustin Atwood on 9/20/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

/*
	Stage Actor is responsible for holding 3 main actors,
 two of them can house an infinite number of sub actors.
 The actor has 2 modes: normal, a mode where the stage
 menu can be shown; editing, a mode where the background
 can be moved and the other 2 actors can add, remove,
 scale and rotate the subactors. While in editing mode
 a banner is displayed at the top of the screen. Once
 clicked editing mode ends.
 
*/

#import <Foundation/Foundation.h>
#import "AnimationActor.h"
#import "ImageActor.h"
#import "MultiImageActor.h"
#import "MultiAnimationActor.h"
#import "SettingManager.h"
#import "BackgroundActor.h"

@interface StageActor : NSObject 
{
	//ImageActor* backgroundActor;
	BackgroundActor* backgroundActor;
	MultiImageActor* foregroundActor;
	MultiImageActor* displayItemActor;
	
	// While in preview Mode each actor must be set manually
	// otherwise they are automatically set by SettingManager
	BOOL previewMode;
	
	BOOL locked;
	BOOL editing;
	SettingManager* sharedSettingManager;
	
	Image* deletionBar;
}

@property(nonatomic) BOOL locked, editing;

- (id) initAsPreview:(BOOL)preview;

// Load Background Actor
- (void) loadBackgroundActor;

// Load Foreground Actor
- (void) loadForegroundActor;

// Load DisplayItem Actor
- (void) loadDisplayItemActor;

// Set Background Actor 
- (void) setBackgroundActor;

- (void) nextBackgroundImage;

- (void) previousBackgroundImage;

// Add Foreground Actor Item
- (void) addItemToForegroundActor:(uint)uid;

// Add Foreground Actor image
- (void) addItemImageToForegroundActor:(NSString*)imageName;

// Add DisplayItem Actor Item
- (void) addItemToDisplayItemActor:(uint)uid;

// Clear all actors
- (void) clearActors;

// Return Selected Index Type
- (int) returnSelectedItemType;

// Lock Foreground
- (void) lockForeground;

// Unlock Foreground
- (void) unlockForeground;

// Lock DisplayItem
- (void) lockDisplayItem;

// Unlock DisplayItem
- (void) unlockDisplayItem;

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

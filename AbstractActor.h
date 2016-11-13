//
//  AbstractActor.h
//  PetGame
//
//  Created by Dustin Atwood on 9/20/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

/* AbstractObject
  This class is responsible for changing the various state of
 the actor and it behaves differently depending on the mode it
 may be in. It has sprite point properties associated to it.
 
 This is the base class for Button Class and Actor Class.
 Button Class expands upon by adding a background/foreground 
 image and performing on a target and selector. 
 
 Actor Class expands by adding an image or animation and
 possible a new rule defintions.
 
*/ 
#import <Foundation/Foundation.h>
#import "Common.h"
#import "SettingManager.h"
#import "Director.h"

@interface AbstractActor : NSObject 
{
	// Position, the X,Y Coordinates of the button
	CGPoint position;
	// State; Normal, Highlighted, Disabled, Selected
	uint state;
	// Enabled, When true will respond to touch events.
	BOOL enabled;
	// Selected, True when the actor was succesfully touched.
	BOOL selected;
	// Highlighted, Shows the actor is being succesfully touched.
	BOOL highlighted;
	// Touched, holds if the item was orinally first touch down successfully
	BOOL touched;
	// Locked, When false the item can be moved once a successful press has been done
	BOOL locked;
	// Moved, When an item is first moved it will be flagged for movement and therefore a menu cannot popup.
	BOOL moved;
	// Size, The width and height of the control
	CGPoint size;
	// reference to settings manager
	SettingManager* sharedSettingManager;
	// reference to director manager
	// Mode defines how the actor becomes selected: Touch, Hold
	uint mode;
}

@property (nonatomic) BOOL enabled, selected, highlighted, touched, locked, moved;
@property (nonatomic) uint state, mode;
@property (nonatomic) CGPoint position, size;

// Init at Position with Width and Height
- (id) initAtPosition:(CGPoint)newPosition withSize:(CGPoint)newSize;

// touch inside
- (bool) isTouchInside:(CGPoint)touchPoint;

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

- (CGRect) boundingBox;

@end

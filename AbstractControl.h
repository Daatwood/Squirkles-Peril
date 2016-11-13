//
//  AbstractControl.h
//  PetGame
//
//  Created by Dustin Atwood on 9/20/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

/* AbstractControl
 This class is responsible for changing the various state of
 the actor and it behaves differently depending on the mode it
 may be in. It has sprite point properties associated to it.
 
 This is the base class for Button Class and Actor Class.
 Button Class expands upon by adding a background/foreground 
 image and performing on a target and selector. 
 
 Actor Class expands by adding an image or animation and
 possible a new rule defintions.
 
 
 Initially touching the button it will become highlighted.
 When the finger moves out of range of the button it will become unhighlighted and untouched.
 When released the button will become activated and perform.
 After holding the button down for a second the button will cause a BUZZ then unhighlight, then
 enlarge. The button has entered a editing state and can be moved. The button 
 will then follow the touch. When released the button will be stationed in that spot.
 
 Activated = The button was successfully touched.
 Editing = The button is being moved around.
 Selected = The button is being pressed down.
 Touched = The button was pressed down by a touch.
 
 Locked = Prevents control from entering editing.
 
 */ 

#import <Foundation/Foundation.h>
#import "Common.h"
#import "SettingManager.h"
#import "Director.h"
#import "SoundManager.h"
#import "BaseControl.h"

@interface AbstractControl : BaseControl 
{
	// When added to an array this will allow for identification
	uint identifier;
	
	// Contains the position and size of the control
	//The position is Percentage based.
	CGRect boundingBox;
	
	// Activated, True when the actor was succesfully touched.
	BOOL activated;
	
	// Selected, Shows the actor is being succesfully touched.
	BOOL selected;
	
	// Sticky, Prevents the control from altering selected state 
	BOOL sticky;
	
	// Touched, Returns if the control is being performed upon.
	BOOL touched;
	
	// Locked, Prevents the control from entering editing state.
	BOOL locked;
	
	// Editing, Flags if the control is being editing.
	BOOL editing;
}
@property (nonatomic) uint identifier;
@property (nonatomic) BOOL activated, selected, touched, locked, editing,sticky;
@property (nonatomic) CGRect boundingBox;

// Init at Position with Width and Height
- (id) initWithCGRect:(CGRect)rect;

- (void) resetStates;

- (BOOL) checkBoundingBox:(CGPoint)point;

- (BOOL) touchable;

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

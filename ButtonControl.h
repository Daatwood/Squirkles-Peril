//
//  ButtonControl.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 9/20/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

// Button class is a simple control class that performs an
// action when it is pressed.

/* Buttons have many states. 
 
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
 
 A button foreground and background image can be defined.
 
*/
#import <Foundation/Foundation.h>
#import "AbstractControl.h"
#import "AbstractActor.h"
#import "Image.h"
#import "AngelCodeFont.h"

@interface ButtonControl : AbstractControl 
{
	AngelCodeFont* font;
	NSString* text;
	
	CGPoint textPosition;
	
	// Normal Image, the image when the button is idle
	Image* buttonImage;
	// Selected Image, the image when the button is selected
	Image* buttonImageSelect;
	
	Image* imageSubButton;
	
	// Image Scale
	float scale;
	
	// Set Button Rotation;
	float rotation;
	
	// Target, the id for the action that will be called
	id target;
	// Action, the action that will be called within the target
	SEL action;
	// Determines if a lock icon is drawn on the control
	BOOL drawLock;
}
@property (nonatomic, retain) AngelCodeFont* font;
@property (nonatomic) BOOL drawLock; 
@property (nonatomic) float scale, rotation;

- (id) initAsButtonImageNamed:(NSString*)imageName withText:(NSString*)buttonText selectionImage:(BOOL)sel atPosition:(CGPoint)pos;
- (id) initAsButtonImageNamed:(NSString*)imageName withSubImageNamed:(NSString*)subImageName atScreenPercentage:(CGPoint)screenPercentage isRotated:(BOOL)rotated;
- (id) initAsButtonImageNamed:(NSString*)imageName withText:(NSString*)buttonText atScreenPercentage:(CGPoint)screenPercentage isRotated:(BOOL)rotated;
- (id) initAsButtonImageNamed:(NSString*)imageName selectionImage:(BOOL)sel atPosition:(CGPoint)pos;

- (void) setFontColourFilterRed:(float)red green:(float)green  blue:(float)blue alpha:(float)alpha; 

- (void) setButtonColourFilterRed:(float)red green:(float)green  blue:(float)blue alpha:(float)alpha; 

- (void) setSubImageColourFilterRed:(float)red green:(float)green  blue:(float)blue alpha:(float)alpha; 

- (void) setButtonColourWithString:(NSString*)colorString;

- (void) setButtonImage:(NSString*)newImage withSelectionImage:(BOOL)sel;

- (void) setButtonImageNamed:(NSString*)imageName withSubImageNamed:(NSString*)subImageName;

- (void) setText:(NSString*)newText;

- (void) setTarget:(id)newTarget andAction:(SEL)newAction;

- (void) performAction;

@end

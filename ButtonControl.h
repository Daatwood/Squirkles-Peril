//
//  ButtonControl.h
//  BadBadMonkey
//
//  Created by Dustin Atwood on 9/20/10.
//  Copyright 2010 Litlapps. All rights reserved.
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
	Image* imageButton;
	Image* imageSubButton;
	Image* imageLock;
	
	// Image Scale
	float scale;
	
	// Set Button Rotation;
	float rotation;
	
	// Target, the id for the action that will be called
	id target;
	// Action, the action that will be called within the target
	SEL action;
}
@property (nonatomic, retain) AngelCodeFont* font;
@property (nonatomic) float scale, rotation;

// Init Variables
- (id) initAsButtonImageNamed:(NSString*)imageName withSubImageNamed:(NSString*)subImageName atScreenPercentage:(CGPoint)screenPercentage;
- (id) initAsButtonImageNamed:(NSString*)imageName withText:(NSString*)buttonText withFontName:(NSString*)fontName atScreenPercentage:(CGPoint)screenPercentage;
- (id) initAsAtlasButtonImageNamed:(NSString*)imageName withSubImageNamed:(NSString*)subImageName atScreenPercentage:(CGPoint)screenPercentage;
- (id) initAsAtlasButtonImageNamed:(NSString*)imageName withText:(NSString*)buttonText withFontName:(NSString*)fontName atScreenPercentage:(CGPoint)screenPercentage;

// Alter Color
- (void) setFontColourFilterRed:(float)red green:(float)green  blue:(float)blue alpha:(float)alpha; 
- (void) setButtonColourFilterRed:(float)red green:(float)green  blue:(float)blue alpha:(float)alpha; 
- (void) setButtonColourWithString:(NSString*)colorString;
- (void) setImageColourFilterRed:(float)red green:(float)green  blue:(float)blue alpha:(float)alpha; 

// Setup Button Images
- (void) setButtonImageNamed:(NSString*)imageName withSubImageNamed:(NSString*)subImageName;
- (void) setAtlasButtonImageNamed:(NSString*)imageName withSubImageNamed:(NSString*)subImageName;

// Changes the Text
- (void) setText:(NSString*)newText;

// Changes the Action
- (void) setTarget:(id)newTarget andAction:(SEL)newAction;
- (void) performAction;

// Changes the Position
- (void) setAtScreenPercentage:(CGPoint)screenPercentage;

@end

//
//  SliderControl.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 1/19/11.
//  Copyright 2011 Dustin Atwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"
#import "AbstractControl.h"

@interface SliderControl : AbstractControl 
{
	Image* imageButton;
	Image* imageBar;

	float value;
	int offset;
	
	// Target, the id for the action that will be called
	id target;
	// Action, the action that will be called within the target
	SEL action;
}

- (id) initAtPosition:(CGPoint)pos;

- (void) setButtonColourFilterRed:(float)red green:(float)green  blue:(float)blue alpha:(float)alpha; 

- (float) returnButtonPosition;

- (void) setButtonPosition:(float)valueFloat;

- (void) setTarget:(id)newTarget andAction:(SEL)newAction;

- (void) performAction;

@end

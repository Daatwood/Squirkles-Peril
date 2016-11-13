//
//  OptionsScene.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 1/31/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ButtonControl.h"
#import "Image.h"
#import "Common.h"
#import "LabelControl.h"
#import "SynthesizeSingleton.h"

@interface OptionsControl : BaseControl 
{
	Image* imageBackground;
	
	ButtonControl* buttonClose;
	ButtonControl* buttonSound;
	ButtonControl* buttonMusic;
	
	ButtonControl* buttonTwitter;
	ButtonControl* buttonFacebook;
	ButtonControl* buttonGameCenter;
	ButtonControl* buttonOpenFeint;
}

+ (OptionsControl*) sharedOptionsControl;

- (void) showOptions;

- (void) hideOptions;

- (void) toggleEffects;

- (void) toggleMusic;

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

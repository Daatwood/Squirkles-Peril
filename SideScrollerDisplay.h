//
//  SideScrollerDisplay.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 11/7/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

// Operates the buttons in the side scroller and the various values.
#import <Foundation/Foundation.h>
#import "Common.h"
#import "ButtonControl.h"
#import "Image.h"
#import "AngelCodeFont.h"
@interface SideScrollerDisplay : NSObject 
{
	// Drawing Elements
	Image* currentBoost;
	Image* currentBoostBackground;
	ButtonControl* pauseButton;
	AngelCodeFont* font;
	
	// Variables
	float totalPoints;
	
	// Gameover screen Elements;
	// Coin Image
	Image* coinImage;
	// Treat Image
	Image* treatImage;
	// Highscore Text Image
	Image* highscoreImage;
	// Score Text Image
	Image* scoreImage;
	// Distance Text Image
	Image* distanceImage;
	// Back Button
	ButtonControl* backButton;
	// Play Button
	ButtonControl* playButton;
}

- (id) init;

- (void) pauseScene;

- (void) unpauseScene;

- (void) setCurrentBoost:(int)boostType;

- (void) setTotalPoints:(float)points;

- (NSString*) returnItemBoostName:(int)type;

// Update
- (void) updateWithDelta:(GLfloat)delta;

// touch began
- (void) touchBeganAtPoint:(CGPoint)beginPoint;

// touch moved
- (void) touchMovedAtPoint:(CGPoint)newPoint;

// touch ended
- (void) touchEndedAtPoint:(CGPoint)endPoint;

// Render
- (void) render;

@end

//
//  BoostIndicator.h
//  BadBadMonkey
//
//  Created by Dustin Atwood on 1/18/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

/*
 Boost Indicator will display how much boost the player currently has.
 It is contained in a black display button. 
 
 Animation:
 When the value is increased boost will set aside the amount needed to increase.
 The boost emblem will increase in size when boost is increased. 
 The size is for a moment. The number will change to yellow.
 The boost emblem will decrease in size when boost is decreased. 
 the size is for a moment. The number will change to red.
 */

#import <Foundation/Foundation.h>
#import "Common.h"
#import "AngelCodeFont.h"
#import "Image.h"
#import "Director.h"

@interface BoostIndicator : NSObject 
{
	// Font Tool
	AngelCodeFont* font;
	// Amount waiting to be added
	int amountAddition;
	// Current amount shown
	int amountTotal;
	// The cooldown time between additions and animations
	float cooldownTimer;
	// The emblem image
	Image* imageEmblem;
	// the indicator background
	Image* imageIndicatorBackground;
	// Indicator Position
	CGPoint positionText;
}

- (id) initBoost:(int)boost atScreenPercentage:(CGPoint)screenPercentage;

- (void) changeInitialBoost:(int)boost;

- (void) addBoost:(int)boost;

- (void) updateWithDelta:(GLfloat)delta;

- (void) render;

@end

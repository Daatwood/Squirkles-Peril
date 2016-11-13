//
//  PointIndicator.h
//  BadBadMonkey
//
//  Created by Dustin Atwood on 1/18/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "AngelCodeFont.h"
#import "Image.h"
@interface PointIndicator : NSObject 
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

- (id) initAtScreenPercentage:(CGPoint)screenPercentage;

- (void) changeInitialValue:(int)value;

- (void) addValue:(int)value;

- (int) returnTotalPoints;

- (void) updateWithDelta:(GLfloat)delta;

- (void) render;

@end

//
//  LargeIndicator.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 2/8/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

// Large Indicator with an extremely high number limit.

#import <Foundation/Foundation.h>
#import "Common.h"
#import "AngelCodeFont.h"
#import "Image.h"

@interface Indicator : NSObject 
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
	BOOL isEnabled;
}

@property(nonatomic) BOOL isEnabled;

- (id) initAtScreenPercentage:(CGPoint)screenPercentage withSize:(int)size currencyType:(int)type leftsideIcon:(BOOL)leftside;

- (void) setAtScreenPercentage:(CGPoint)screenPercentage leftsideIcon:(BOOL)leftside;

- (void) changeInitialValue:(int)value;

- (void) addValue:(int)value;

- (int) returnTotalPoints;

- (void) updateWithDelta:(GLfloat)delta;

- (void) render;

@end

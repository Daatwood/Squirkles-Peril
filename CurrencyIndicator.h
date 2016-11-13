//
//  CurrencyIndicator.h
//  BadBadMonkey
//
//  Created by Dustin Atwood on 1/18/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "AngelCodeFont.h"
#import "Image.h"
#import "Director.h"

@interface CurrencyIndicator : NSObject 
{
	// Font Tool
	AngelCodeFont* font;
	// the indicator background
	Image* imageIndicatorBackground;
	
	// Coin Properties
	// Amount waiting to be added
	int additionCoins;
	// Current amount shown
	int totalCoins;
	// The cooldown time between additions and animations
	float cooldownTimerCoins;
	// The emblem image
	Image* imageEmblemCoins;
	// Indicator Position
	CGPoint positionTextCoins;
	
	// Treat Properties
	// Amount waiting to be added
	int additionTreats;
	// Current amount shown
	int totalTreats;
	// The cooldown time between additions and animations
	float cooldownTimerTreats;
	// The emblem image
	Image* imageEmblemTreats;
	// Indicator Position
	CGPoint positionTextTreats;
	
	BOOL isEnabled;
}

@property(nonatomic) BOOL isEnabled;

- (id) initAtScreenPercentage:(CGPoint)screenPercentage;

- (void) setInitialCoins:(int)coins;

- (int) infoCoins;

- (int) infoTreats;

- (void) addCoins:(int)coins;

- (void) setInitialTreats:(int)treats;

- (void) addTreats:(int)treats;

- (void) updateWithDelta:(GLfloat)delta;

- (void) render;

@end

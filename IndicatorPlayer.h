//
//  IndicatorPlayer.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 3/8/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

/*
 The player indicator contains a bulk of player information.
 
 Shows how many coins and boost points the player has.
 Also shows the current power level of the selected pet 
 and its current experience points.
 
*/

#import <Foundation/Foundation.h>
#import "Common.h"
#import "AngelCodeFont.h"
#import "Image.h"
#import "SettingManager.h"

@interface IndicatorPlayer : NSObject 
{
	// Font Tool
	AngelCodeFont* font;
	
	// Coin Amount waiting to be added
	int additionCoin;
	// Current Coin amount shown
	int totalCoin;
	
	// Boost Amount waiting to be added
	int additionBoost;
	// Current Boost amount shown
	int totalBoost;
	
	// Exp Amount waiting to be added
	float additionExperience;
	// Current Exp amount shown
	int totalExperience;
	
	// Current Power Level
	int currentLevel;
	
	// The cooldown time between additions and animations
	float cooldownTimer;
	
	// The emblem image
	Image* imageIndicator;
	// the indicator background
	Image* imageIndicatorFill;
	Image* imageIndicatorFillBackground;
	
	// Indicator Position
	CGPoint positionIndicator;
	
	CGPoint positionLevelString;
	CGPoint positionCoinString;
	CGPoint positionBoostString;
	
	BOOL isEnabled;
}
@property(nonatomic) BOOL isEnabled;

- (id) init;

- (void) setAtScreenPercentage:(CGPoint)screenPercentage;

- (void) refresh;

- (void) refreshWithCharacterIndex:(uint)index;

- (void) addCoinValue:(int)value;

- (void) addBoostValue:(int)value;

- (void) addExpValue:(int)value;

- (int) returnTotalCoins;

- (int) returnTotalBoost;

- (int) returnTotalExp;

- (void) updateWithDelta:(GLfloat)delta;

- (void) render;

@end

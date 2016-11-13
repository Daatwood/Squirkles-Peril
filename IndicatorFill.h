//
//  IndicatorFill.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 3/10/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "Image.h"

@interface IndicatorFill : NSObject 
{
	uint fillDirection;
	
	// Max Level
	int levelMax;
	
	// The emblem image
	Image* imageIndicator;
	// the indicator background
	Image* imageIndicatorFill;
	Image* imageIndicatorFillBackground;
	
	// Indicator Position
	CGPoint positionIndicator;
	
	BOOL isEnabled;
}
@property(nonatomic) BOOL isEnabled;
@property(nonatomic) int levelMax;

- (id) initAtScreenPercentage:(CGPoint)screenPercentage withDirection:(uint)direction;

- (void) setAtScreenPercentage:(CGPoint)screenPercentage;

- (void) setLevelCurrent:(float)currentLevel;

- (void) render;

@end

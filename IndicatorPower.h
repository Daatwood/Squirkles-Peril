//
//  IndicatorPower.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 3/9/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "AngelCodeFont.h"
#import "Image.h"
#import "SettingManager.h"

@interface IndicatorPower : NSObject 
{
	// Font Tool
	AngelCodeFont* font;
	
	// Current Power Level
	NSString* currentLevel;
	
	// The emblem image
	Image* imageIndicator;
	
	// Indicator Position
	CGPoint positionIndicator;
	
	BOOL isEnabled;
}
@property(nonatomic) BOOL isEnabled;

- (id) initAtScreenPercentage:(CGPoint)screenPercentage;

- (void) setAtScreenPercentage:(CGPoint)screenPercentage;

- (void) refresh;

- (void) refreshWithCharacterIndex:(uint)index;

- (void) render;

@end

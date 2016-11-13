//
//  JumpScrollerBackground.h
//  BadBadMonkey
//
//  Created by Dustin Atwood on 12/31/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

/*
 Moons, Suns and Planets are randomly added to the background and scroll at a quicker pace
 then the background. 1.5x the speed.
 The Additional Items will stay on screen until their Y reaches -200, at which they may be
 removed and another will spawn on the screen.
*/

#import <Foundation/Foundation.h>
#import "Image.h"
#import "Director.h"
#import "Common.h"
#import "SettingManager.h"

@interface JumpScrollerBackground : NSObject 
{
    Shape_Level level;
    
	// Background image
	Image* imageBackground;
    
    Image* imageOverlay;
	
	// Max Distance
	float offsetMax;
	// Current Distance
	float offsetCurrent;
	// Distance that is awaiting to be added
	float offsetAdditional;
	
	float cooldownTimer;
	
	// Interal Background Offset
	float offset;

	Color4f colorTop;
	Color4f colorBottom;
}

@property(nonatomic) float offsetMax, offsetCurrent, offsetAdditional, offset;
@property(nonatomic) Shape_Level level;
@property(nonatomic) Color4f colorTop, colorBottom;

- (id) init;

- (void) reset;

- (void) changeBackgroundColor;

- (void) increaseBy:(float)amount;

- (void) updateWithDelta:(float)delta;

- (void) render;

@end

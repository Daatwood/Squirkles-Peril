//
//  JumpScrollerBackground.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 12/31/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"
#import "Director.h"
#import "Common.h"

@interface JumpScrollerBackground : NSObject 
{
	Image* topBackground;
	Image* midBackground;
	Image* bottomBackground;
	
	float timeLength;
	
	// How much of the scrollAmount is added to the offset.
	float scrollingRate;
	
	//How far down to scroll the bottom background
	float offset;
	
	int currentLevel;
	
	int currentStage;
}

@property(nonatomic) float timeLength;
- (id) init;

- (void) reset;

- (void) adjustScrollingRate:(float)newRate;

- (void) addScroll:(float)scrollAmount withDelta:(float)delta;

- (void) updateWithDelta:(float)delta;

- (void) render;

@end

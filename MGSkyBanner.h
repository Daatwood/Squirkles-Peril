//
//  MGSkyBanner.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 2/6/11.
//  Copyright 2011 Dustin Atwood. All rights reserved.
//

// A Banner is object that spawns in minigames that provides 
// a visual marker for when you are about to achieve something
// Like beat a your own highscore, your friends highscore or unlock a new level

#import <Foundation/Foundation.h>
#import "Common.h"
#import "Image.h"
#import "JumpScrollerPlayer.h"
#import "ParticleEmitter.h"
#import "LabelControl.h"

@interface MGSkyBanner : NSObject 
{
	ParticleEmitter* emitterBanner;
	
	// Platform Image
	Image* imageBanner;
	
	LabelControl* labelBanner;
}

- (id) initAtScreenHeight:(float)height withText:(NSString*)label andColorFilterRed:(GLfloat)aRed green:(GLfloat)aGreen blue:(GLfloat)aBlue;

- (void) updateWithDelta:(float)aDelta;

- (BOOL) hasCollidedWithPlayer:(JumpScrollerPlayer*)player withDelta:(GLfloat)delta;

- (void) applyVelocity:(float)velocity;

- (void) render;

@end

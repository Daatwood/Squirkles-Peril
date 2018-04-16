//
//  SideScrollerDisplay.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 11/7/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

#import "SideScrollerDisplay.h"


@implementation SideScrollerDisplay

- (id) init
{
	if(self = [super init])
	{
		currentBoostBackground = [[Image alloc] initWithImageNamed:@"CurrentBoost"];
		[currentBoostBackground setRotation:90];
		[currentBoostBackground setPosition:CGPointPortraitToLandscape(CGPointMake(240, 295))];
		pauseButton = [[ButtonControl alloc] initAsButtonImageNamed:@"PauseButton" selectionImage:NO 
														 atPosition:CGPointPortraitToLandscape(CGPointMake(460, 20))];
		[pauseButton setTarget:self andAction:@selector(pauseScene)];
		[pauseButton setRotation:90];
		
		font = [[AngelCodeFont alloc] initWithFontImageNamed:@"GillSans16" controlFile:@"GillSans16" scale:1.0f filter:GL_LINEAR];
		[font setRotation:90];
		[self setTotalPoints:0];
		
		// Gameover Elements
		//coinImage = [[Image alloc] initWithImageNamed:@"Nothing"];
		//treatImage = [[Image alloc] initWithImageNamed:@"Nothing"];
		//highscoreImage = [[Image alloc] initWithImageNamed:@"Nothing"];
		//scoreImage = [[Image alloc] initWithImageNamed:@"Nothing"];
		//distanceImage = [[Image alloc] initWithImageNamed:@"Nothing"];
		//backButton = [[ButtonControl alloc] initAsButtonImageNamed:@"CloseMenuButton" selectionImage:TRUE 
		//												atPosition:CGPointPortraitToLandscape(CGPointMake(90, 25))];
		//[backButton setRotation:90];
		//playButton = [[ButtonControl alloc] initAsButtonImageNamed:@"GameButton" selectionImage:TRUE 
		//												atPosition:CGPointPortraitToLandscape(CGPointMake(390, 25))];
		//[playButton setRotation:90];
	}
	return self;
}

- (NSString*) returnItemBoostName:(int)type
{
	switch (type) 
	{
		case ItemEffectNone:
			return @"Nothing";
		case ItemEffectPoint:
			return @"IconPoint";
		case ItemEffectDeath:
			return @"IconDeath";
		case ItemEffectDebuff:
			return @"IconDebuff";
		case ItemEffectInvulnerable:
			return@"IconDeath";
		case ItemEffectJumpDecrease:
			return @"IconJumpLimit";
		case ItemEffectJumpIncrease:
			return @"IconJumpBoost";
		case ItemEffectProtect:
			return @"IconShield";
		case ItemEffectRunDecrease:
			return @"IconSpeedLimit";
		case ItemEffectRunIncrease:
			return @"IconSpeedBoost";
		default:
			return @"Nothing";
	}
}

- (void) setCurrentBoost:(int)boostType
{
	[currentBoost release];
	currentBoost = [[Image alloc] initWithImageNamed:[self returnItemBoostName:boostType]];
	[currentBoost setRotation:90];
	[currentBoost setPosition:CGPointPortraitToLandscape(CGPointMake(240, 295))];
}

- (void) setTotalPoints:(float)points
{
	totalPoints = points;
}

- (void) pauseScene
{
	[[Director sharedDirector] setCurrentSceneState:SceneState_Paused];
	NSLog(@"Pausing");
}

- (void) unpauseScene
{
	[[Director sharedDirector] setCurrentSceneState:SceneState_Running];
}

// Update
- (void) updateWithDelta:(GLfloat)delta
{
	
}

// touch began
- (void) touchBeganAtPoint:(CGPoint)beginPoint
{
	[pauseButton touchBeganAtPoint:beginPoint];
}

// touch moved
- (void) touchMovedAtPoint:(CGPoint)newPoint
{
	[pauseButton touchMovedAtPoint:newPoint];
}

// touch ended
- (void) touchEndedAtPoint:(CGPoint)endPoint
{
	[pauseButton touchEndedAtPoint:endPoint];
}

// Render
- (void) render
{
	[currentBoost render];
	[currentBoostBackground render];
	[pauseButton render];
	//[font drawStringAt:CGPointPortraitToLandscape(CGPointMake(380, 300)) text:[NSString stringWithFormat:@"Distance: %1.0f", totalPoints]];
	[font drawStringAt:CGPointPortraitToLandscape(CGPointMake(20, 300)) text:[NSString stringWithFormat:@"FPS: %1.0f", [[Director sharedDirector] averageFramesPerSecond]]];

}

@end

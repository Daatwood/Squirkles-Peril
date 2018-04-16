//
//  SideScrollerScene.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 11/5/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

// Island Runner, is a game where your pet crashlands on an island and then an evil alien
// robot beams down and begins chasing your pet. Your pet must make its getaway by running and jumping
// onto a series of islands, whales and sinking ships. The pet must not fall or it may drown. Also 
// there are inactive geysers scatter on islands; if trip though, may sprout lava incinerating your pet! 
// There is the occasional boost that may enchance or hinder your pet's excape!

#import <Foundation/Foundation.h>
#import "AbstractScene.h"
#import "Common.h"
#import "SideScrollerGroundObject.h"
#import "SideScrollerPlayerObject.h"
#import "SideScrollerDisplay.h"
#import "PointIndicator.h"
#import "BoostIndicator.h"
#import "LabelControl.h"
#import "CurrencyIndicator.h"
#import	"Image.h"
#import "ButtonControl.h"

@interface SideScrollerScene : AbstractScene
{
	// An Array of Visible Ground Objects
	NSMutableArray* groundObjects;
	
	// the player variable
	SideScrollerPlayerObject* player;
	
	// The amount of islands before a special one is created
	int islandSpecialCounter;
	
	// Display Elements
	// Pauses the game
	ButtonControl* pauseButton;
	// Required for any writing
	AngelCodeFont* font;
	// The current running high score
	float highscorePoints;
	// Points Earned by the player
	float totalPoints;
	// The total Distance traveled by the player;
	float totalDistance;
	
	
	// Bonus Elements
	float bonusAmount;
	// Uses profile keys to identify
	int bonusType;
	
	// Interface Elements: Gameplay
	PointIndicator* pointIndicator;
	BoostIndicator* boostIndicator;
	LabelControl* labelLevel;
	LabelControl* labelStage;
	
	
	// Interface Elements: GameOver
	LabelControl* labelGameover;
	LabelControl* labelEarned;
	LabelControl* labelBonus;
	LabelControl* labelScore;
	LabelControl* labelHiScore;
	LabelControl* labelHeight;
	Image* imageCoin;
	Image* imageBonus;
	Image* imageBackground;
	Image* imageOverlayMask;
	
	// Interface Elements: Basic
	CurrencyIndicator* currencyIndicator;
	ButtonControl* buttonRestart;
	ButtonControl* buttonArcade;
	ButtonControl* buttonPause;
	
}

// Initialize
- (id) init;

- (void) togglePause;

- (void) loadArcadeScene;

- (void) calculateBonus;

// Reset the gameplay
- (void) reset;

// Update
- (void) updateWithDelta:(GLfloat)delta;

// Reuses an old island for new
- (void) generateNextIsland;

// Render
- (void) render;
@end

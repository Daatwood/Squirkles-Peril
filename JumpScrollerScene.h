//
//  JumpScrollerScene.h
//  BadBadMonkey
//
//  Created by Dustin Atwood on 11/21/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "Image.h"
#import "ButtonControl.h"
#import "CurrencyIndicator.h"
#import "AbstractScene.h"
#import "JumpScrollerBackground.h"
#import "BoostIndicator.h"
#import "Indicator.h"
#import "LabelControl.h"
#import "MGSkyPlatformManager.h"
#import "MGSkyPlayer.h"
#import "MGSkyEnemy.h"
#import "MGSkyPlatform.h"
#import "IndicatorPlayer.h"
#import "IndicatorFill.h"
#import "MultiplayerManager.h"


@interface JumpScrollerScene : AbstractScene <MultiplayerManagerLobbyDelegate, UIAlertViewDelegate>
{
	//---- INTERFACE
	// Required for quick On-Screen Writing
	AngelCodeFont* font;
	
	IndicatorPlayer* indicatorPlayer;

	// Displays the current Level
	LabelControl* labelLevel;
	// Displays the current Stage
	LabelControl* labelStage;
	
	//---- INTERALS
	// An Array of platforms
	NSMutableArray* platforms;
	// A Class that determines which type of platform to place
	MGSkyPlatformManager* platformManager;
	// An Array of Obstacles
	NSMutableArray* obstacles;
	// The current Scene Color
	Color4f stageColor;
	
	// The player
	MGSkyPlayer* player1;
    MGSkyPlayer* player2;
	// Background
	JumpScrollerBackground* background;
    
    UIAlertView *alertView;
    
    float timer;
	
	// Points Earned by the player
	int pointsPlayer;
	// Distance until next stage.
	float distanceRequired;
	// Distance until hostile spawn.
	float distanceHostile;
	// Distance until alien spawn.
	float distanceAlien;
	// Bonus Amount won by the player
	int bonusPlayer;
	
	// The type of bonus earned
	int bonusType;
	// Current Playing Level
	int gameLevel;
	// Current Difficulty of the Level
	int gameStage;
    // Current Sub-Stage
    int gameDistance;

	// The amount of platforms in a single column
	uint platformsPerColumn;
	// Platform Cooldowns
	int lastMovingDirection;
    
	float averageDelta;
	
	float gameScale;
	float gameScaleTarget;
}

// 
// === BASIC
// 

// Initialize
- (id) init;

// Update
- (void) updateWithDelta:(GLfloat)delta;

// Render
- (void) render;

// 
// === TRANSITIONS AND SETUPS
// 

// Go back to the Arcade
- (void) loadMenuScene;

// Show/Setup Startup Screen
- (void) showStartScreen;

// Show/Setup Running Screen
- (void) showRunningScreen;

// Show/Setup Pause Screen
- (void) showPauseScreen;

// Notification Reponse, Sets the Game's Level
- (void) responseSetGameLevel:(NSNotification*)newLevel;

// 
// === GAME MECHANICS
// 

// Reset the gameplay
- (void) reset;

// Adjust Game Parameters based on Level and Difficulty
- (void) setGameParameters;

// Reuse a platform when one has died.
- (void) generateNextPlatform:(NSArray*)reusePlatforms;

// Creates a new platform when one has died.
- (void) generateNewPlatform;

// Attempts to use boost
- (void) useBoost;

@end

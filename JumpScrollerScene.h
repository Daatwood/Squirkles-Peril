//
//  JumpScrollerScene.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 11/21/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "Image.h"
#import "ButtonControl.h"
#import "CurrencyIndicator.h"
//#import "JumpScrollerPlayer.h"
//#import "JumpScrollerObstacle.h"
#import "AbstractScene.h"
#import "JumpScrollerBackground.h"
#import "InformativeControl.h"
#import "BoostIndicator.h"
#import "Indicator.h"
#import "LabelControl.h"
#import "MGSkyPlatformManager.h"
#import "MGSkyBanner.h"
#import "MGSkyPlayer.h"
#import "MGSkyObstacle.h"
#import "MGSkyPlatform.h"

@interface JumpScrollerScene : AbstractScene //<NSCoding>
{
	//---- INTERFACE
	// Required for quick On-Screen Writing
	AngelCodeFont* font;
	// Displays the User's Coins
	Indicator* coinIndicator;
	// Displays the User's Treats
	Indicator* treatIndicator;
	// Displays the User's Points
	Indicator* pointIndicator;
	// Displays the User's Boost
	Indicator* boostIndicator;
	// Displays the current Level
	LabelControl* labelLevel;
	// Displays the current Stage
	LabelControl* labelStage;
	// Displays Gameover Text
	LabelControl* labelGameover;
	// Displays Informative Earnings
	LabelControl* labelEarned;
	// Displays Bonus Information
	LabelControl* labelBonus;
	// Displays Ending Score
	LabelControl* labelScore;
	// Displays HiScore
	LabelControl* labelHiScore;
	// Displays HiScore
	LabelControl* labelNextLevel;
	// Coin Winnings Image
	Image* imageCoin;
	// Bonus Winnings Image
	Image* imageBonus;
	// Earnings Background
	Image* imageBackground;
	// Restart Button
	ButtonControl* buttonRestart;
	// Back Button
	ButtonControl* buttonArcade;
	// Pause Button
	ButtonControl* buttonPause;
	// Resume Button
	ButtonControl* buttonResume;
	// Boost Button
	ButtonControl* buttonBoost;
	// Boost Button
	ButtonControl* buttonNextLevel;
	
	//---- INTERALS
	// An Array of platforms
	NSMutableArray* platforms;
	// A Class that determines which type of platform to place
	MGSkyPlatformManager* platformManager;
	// An Array of Obstacles
	NSMutableArray* obstacles;
	
	// The player
	MGSkyPlayer* player;
	// Background
	JumpScrollerBackground* background;
	
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

	// The amount of platforms in a single column
	uint platformsPerColumn;
	// Platform Cooldowns
	uint platformBouncyCD;
	uint platformDissolveCD;
	uint platformFakeCD;
	uint platformNetCD;
	uint platformShipCD;
	uint platformExplosiveCD;
	uint platformStarCD;
	
	//Debug Information
	float _pointsPerSecond;
	float _timePlayed;
	float _pointsPerSecondUpdate;
	float averageDelta;
}

// Initialize
- (id) init;

// Go back to the Arcade
- (void) loadArcadeScene;

// Transition to next level;
- (void) loadNextLevel;

// Pause/Unpause Game
- (void) togglePause;

// Pause Game
- (void) pause;

// Saves the current game state to allow to user to pickup where they left off
- (void) saveGameState;

- (void) loadGameState;

// Attempts to use boost
- (void) useBoost;

// Notification Reponse, Sets the Game's Level
- (void) responseSetGameLevel:(NSNotification*)newLevel;

// Reset the gameplay
- (void) reset;

// Adjust Game Parameters based on Level and Difficulty
- (void) setGameParameters;

// Creates a new platform when one has died.
- (void) generateNextPlatform;

// Calculates the Winnings
- (void) calculateWinnings;

// Update
- (void) updateWithDelta:(GLfloat)delta;

// Render
- (void) render;

@end

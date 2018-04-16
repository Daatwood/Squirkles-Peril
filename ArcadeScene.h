//
//  ArcadeScene.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 1/3/11.
//  Copyright 2011 Dustin Atwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ButtonControl.h"
#import "CurrencyIndicator.h"
#import "Indicator.h"
#import "Image.h"
#import "AbstractScene.h"
#import "ParticleEmitter.h"
#import "LabelControl.h"

@interface ArcadeScene : AbstractScene
{
	// Instructs player to choose a game
	LabelControl* labelInstructGame;
	// Instructs player to choose a level
	LabelControl* labelInstructLevel;
	// Label telling the player why it has been locked
	LabelControl* labelInstructLock;
	// The current Level
	LabelControl* labelLevel;
	
	// Changes Screen to Menu
	ButtonControl* buttonBack;
	// Shows Previous Minigame
	ButtonControl* buttonPrevGame;
	// Shows Next Minigame
	ButtonControl* buttonNextGame;
	// Shows Previous Level
	ButtonControl* buttonPrevLevel;
	// Shows Next Level
	ButtonControl* buttonNextLevel;
	// Starts or Unlocks the Level
	ButtonControl* buttonAction;
	
	// The player's currency
	Indicator* coinIndicatorUser;
	Indicator* treatIndicatorUser;
	// The player's boost
	Indicator* boostIndicatorUser;
	// The unlocking cost
	CurrencyIndicator* currencyIndicatorCost;
	
	// The current Minigame Image
	Image* imageCurrentPreview;
	
	// Interal Management
	NSMutableArray* itemsMinigames;
	int currentIndexGame;
	NSMutableArray* itemsMinigameLevels;
	int currentIndexLevel;
}

- (void) loadMenuScene;
- (void) loadSelectedGame;
- (void) unlockSelectedLevel;

- (void) showPrevGame;
- (void) showNextGame;

- (void) showPrevLevel;
- (void) showNextLevel;

- (void) updateWithSelectedGame;
- (void) updateWithSelectedLevel;

@end

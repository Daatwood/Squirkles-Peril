//
//  CharacterScene.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 3/8/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractScene.h"
#import "Common.h"
#import "Image.h"
#import "PetActor.h"
#import "SettingManager.h"
#import "IndicatorPlayer.h"
#import "IndicatorPower.h"
#import "Indicator.h"

@interface CharacterScene : AbstractScene 
{
	PetActor* characterPreview;
	IndicatorPlayer* indicatorPlayer;
	IndicatorPower* indicatorPower;
	Indicator* indicatorCost;
	
	int currentIndex;
	
	Image* imageLock;
	
	// Tutorial Elements
	BOOL tutorialOn;
	Image* imageTutorial;
	LabelControl* labelTutorial;
	ButtonControl* buttonTutorial;
}

// Loads the Menu Scene
- (void) loadMenuScene;

// Loads the Stylize Scene
- (void) loadStylizeScene;

// Loads the Next Character
- (void) showNextCharacter;

// Loads the Previous Character
- (void) showPreviousCharacter;

// Refreshes the Screen with current Character;
- (void) refresh;

// Set as Selected Character
- (void) setAsSelectedCharacter;

// Attempts to Purchase the Selected Character
- (void) buySelectedCharacter;
@end

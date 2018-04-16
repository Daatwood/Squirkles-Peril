//
//  StageScene.h
//  BadBadMonkey
//
//  Created by Dustin Atwood on 9/20/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractScene.h"
#import "Common.h"
#import "StageActor.h"
#import "PetActor.h"
#import "CurrencyIndicator.h"
#import "Image.h"
#import "ButtonControl.h"
#import "AngelCodeFont.h"
#import "OptionControl.h"

@interface StageScene : AbstractScene 
{
	// Font Control
	AngelCodeFont* font;
	// Stage Actor
	StageActor* stage;
	// Pet Actor
	PetActor* pet;
	
	// HUD
	// Mini Display Image
	Image* imageMiniHUD;
	
	// User Point Display
	CurrencyIndicator* indicatorUserPoints;
	// User Treat Display
	CurrencyIndicator* indicatorUserTreats;
	// FxSound Button
	ButtonControl* buttonSound;
	// Music Button
	ButtonControl* buttonMusic;
	// Vibrate Button
	ButtonControl* buttonVibrate;

	// Option Control panel
	OptionControl* optionControl;
	
	// Editing State
	BOOL editing;
	// Glowing Border
	Image* glowingBorder;
	// Stop Editing Button
	ButtonControl* stopEditingButton;
	// Quick Access Add Item
	ButtonControl* addItemEditingButton;
}
// Toggles the editing state
- (void) toggleEditing;

// Adds an item to the scene
- (void) optionControlShowItems;

- (void) optionControlShowTreats;

// Toggles sound effects
- (void) toggleSound;

// Toggles background music
- (void) toggleMusic;

// Toggles vibration
- (void) toggleVibrate;

// Displays the setting controls
- (void) toggleSettings;

// Displays Option Control for the background
- (void) displayOptionControl;

// Performs the Option Control
- (void) performOptionControl:(int)index;

@end

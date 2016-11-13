//
//  MenuScene.h
//  BadBadMonkey
//
//  Created by Dustin Atwood on 1/3/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ButtonControl.h"
#import "Image.h"
#import "AngelCodeFont.h"
#import "PetActor.h"
#import "Common.h"
#import "AbstractScene.h"
#import "LabelControl.h"
#import "ParticleEmitter.h"
#import "NetworkManager.h"
#import "IndicatorPower.h"

@interface MenuScene : AbstractScene <SKPaymentTransactionObserver, UIAlertViewDelegate>
{
	NetworkManager* sharedNetworkManager;
	
	//IndicatorPower* indicatorPower;
	
	// Application Title Image
	Image* sceneHeader;
	// Pet Background Image
	Image* imagePetBackground;
	// Star Power Level
	Image* imagePowerLevel;
	// Player's Pet
	PetActor* playerPet;
    
    int selectedCharacter;
}

// Loads the Character Selection Scene
- (void) loadCharacterScene;

// Loads the Stylize Scene
- (void) loadStylizeScene;

// Load Game Scene
- (void) loadGameScene;

// Shows the game's Options
- (void) showOptions;

- (void) showNextProfile;

- (void) showPreviousProfile;

- (BOOL) updateSelection;

@end

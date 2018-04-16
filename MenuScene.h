//
//  MenuScene.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 1/3/11.
//  Copyright 2011 Dustin Atwood. All rights reserved.
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

@interface MenuScene : AbstractScene 
{
	NetworkManager* sharedNetworkManager;
	
	ParticleEmitter* emitter;
	
	// The Scene Header
	LabelControl* labelSceneHeader;
	LabelControl* labelSceneSubHeader;
	LabelControl* labelUserName;
	// The Scene Header
	Image* sceneHeader;
	// Change Save File
	ButtonControl* buttonChangeSaveFile;
	// Stylize Button
	ButtonControl* buttonStylize;
	// Begin/Continue Story Mode Button
	ButtonControl* buttonStoryMode;
	// Arcade Mode Button
	ButtonControl* buttonArcadeMode;
	// Store Button
	ButtonControl* buttonStore;
	// Options Button
	ButtonControl* buttonOptions;
	// Pet Background Image
	Image* imagePetBackground;
	// Player's Pet
	PetActor* playerPet;
	// News Feed Information
	LabelControl* labelNewsFeed;
	// News Feed Background
	Image* imageNewsFeedBackground;
}

// Loads the Stylize Scene
- (void) loadStylizeScene;

// Load Arcade Minigame Selection Scene
- (void) loadMinigameScene;

// Loads the store Scene
- (void) loadStoreScene;

// Shows the game's Options
- (void) showOptions;

- (void) setNewsFeed;

@end

//
//  MenuScene.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 1/3/11.
//  Copyright 2011 Dustin Atwood. All rights reserved.
//

#define indicatorUserCurrencyX 80
#define indicatorUserCurrencyY 300
#define infoFileNameX 80
#define infoFileNameY 365.5
#define buttonChangeSaveFileX 42.5
#define buttonChangeSaveFileY 235
#define buttonStylizeX 236.5
#define buttonStylizeY 240
#define buttonStoryModeX 160
#define buttonStoryModeY 150
#define buttonArcadeModeX 236.5
#define buttonArcadeModeY 336
#define buttonStoreX 46
#define buttonStoreY 33
#define buttonOptionsX 274
#define buttonOptionsY 33
#define imagePetBackgroundX 88.5
#define imagePetBackgroundY 288
#define playerPetX 88.5
#define playerPetY 268

#import "MenuScene.h"

@implementation MenuScene

- (id) init
{
	self = [super init];
	if (self != nil) 
	{
		NSLog(@"Menu Scene Initializing...");
		sharedNetworkManager = [NetworkManager sharedNetworkManager];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNewsFeed) name:@"NEWS_FEED_LOADED" object:nil];
	}
	return self;
}

- (void) startLoadScene
{
	NSLog(@"Menu Scene Loading...");
	
	labelSceneHeader = [[LabelControl alloc] initWithFontName:FONT21];
	[labelSceneHeader setText:APP_TITLE atSceenPercentage:CGPointMake(50, 93)];
	
	labelSceneSubHeader = [[LabelControl alloc] initWithFontName:FONT16];
	[labelSceneSubHeader setText:APP_SUBTITLE atSceenPercentage:CGPointMake(50, 88)];
	
	labelUserName = [[LabelControl alloc] initWithFontName:FONT21];
	
	labelNewsFeed = [[LabelControl alloc] initWithFontName:FONT16];
	
	imageNewsFeedBackground = [[Image alloc] initWithImageNamed:@"imageNewsBackground"];
	[imageNewsFeedBackground setPositionAtScreenPrecentage:CGPointMake(50, 25) isRotated:NO];
	[imageNewsFeedBackground setAlpha:0.0];

	buttonStylize = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonExtended" withText:@"Stylize" selectionImage:NO
													   atPosition:CGPointMake(buttonStylizeX, buttonStylizeY)];
	[buttonStylize setTarget:self andAction:@selector(loadStylizeScene)];
	[buttonStylize setButtonColourFilterRed:1.0 green:1.0 blue:0.0 alpha:1.0];
	
	buttonArcadeMode = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonExtended" withText:@"Play" selectionImage:NO
														  atPosition:CGPointMake(buttonArcadeModeX, buttonArcadeModeY)];
	[buttonArcadeMode setTarget:self andAction:@selector(loadMinigameScene)];
	[buttonArcadeMode setButtonColourFilterRed:0.0 green:1.0 blue:0.0 alpha:1.0];
	
	buttonStore = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" withSubImageNamed:@"buttonSubImageStore" 
											   atScreenPercentage:CGPointMake(12.5, 8) isRotated:NO];
	[buttonStore setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
	[buttonStore setTarget:self andAction:@selector(loadStoreScene)];
	
	buttonOptions = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" withSubImageNamed:@"buttonSubImageOptions" 
											   atScreenPercentage:CGPointMake(87.5, 8) isRotated:NO];
	[buttonOptions setTarget:self andAction:@selector(showOptions)];
	[buttonOptions setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
	
	imagePetBackground = [[Image alloc] initWithImageNamed:@"imageBackgroundPet"];
	[imagePetBackground setPosition:CGPointMake(imagePetBackgroundX, imagePetBackgroundY)];

	playerPet = [[PetActor alloc] initWithState:0];
	
	[self finishLoadScene];
}

- (void) finishLoadScene
{
	NSLog(@"Finish Loading...");
	[self setIsInitialized:TRUE];
	[self transitioningToCurrentScene];
	[[Director sharedDirector] stopLoading];
}

// Loads the Stylize Scene
- (void) loadStylizeScene
{
	//[emitter setActive:FALSE];
	[[Director sharedDirector] setCurrentSceneToSceneWithKey:SCENEKEY_STYLIZE];
}

// Load Arcade Minigame Selection Scene
- (void) loadMinigameScene
{
	//[emitter setActive:FALSE];
	[[Director sharedDirector] setCurrentSceneToSceneWithKey:SCENEKEY_ARCADE];
}

// Loads the store Scene
- (void) loadStoreScene
{
	//[emitter setActive:FALSE];
	[[Director sharedDirector] setCurrentSceneToSceneWithKey:SCENEKEY_STORE];
}

// Shows the game's Options
- (void) showOptions
{
	[[Director sharedDirector] setCurrentSceneToSceneWithKey:SCENEKEY_OPTIONS];
}

- (void) setNewsFeed
{
	[[labelNewsFeed font] setMaxLength:300];
	[labelNewsFeed setText:[sharedNetworkManager latestNewsFeed] atSceenPercentage:CGPointMake(52, 32)];
	[imageNewsFeedBackground setAlpha:1.0];
}

- (void)transitioningToCurrentScene
{
	if(!isInitialized)
	{
		[[Director sharedDirector] startLoading];
		[self startLoadScene];
	}
	[labelUserName setText:[sharedSettingManager forProfileGet:ProfileKey_Name] atSceenPercentage:CGPointMake(28, 78)];
	[playerPet adjustImages];
	[playerPet setBoundingBox:CGRectMake(playerPetX, playerPetY, 120, 122)];
	[playerPet adjustScale:0.5f];
}

- (void)updateWithDelta:(GLfloat)aDelta 
{
	if(!isInitialized)
		return;
	
	[super updateWithDelta:aDelta];
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
			[buttonStylize updateWithDelta:aDelta];
			[buttonArcadeMode updateWithDelta:aDelta];
			[buttonStore updateWithDelta:aDelta];
			[buttonOptions updateWithDelta:aDelta];
			[playerPet updateWithDelta:aDelta];
	
			break;
		}
			// The scene is phasing out.
		case SceneState_TransitionOut:
		{
			break;
		}
			// The scene is phasing in.
		case SceneState_TransitionIn:
		{
			break;
		}
		default:
		{
			NSLog(@"ERROR: StylizeScene has no valid state.");
			break;
		}
	}
}

- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	if(!isInitialized)
		return;
	
	[super updateWithTouchLocationBegan:touches withEvent:event view:aView];
	
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
			[buttonStylize touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[buttonArcadeMode touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[buttonStore touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[buttonOptions touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
		}
			// The scene is phasing out.
		case SceneState_TransitionOut:
		{
			break;
		}
			// The scene is phasing in.
		case SceneState_TransitionIn:
		{
			break;
		}
		default:
		{
			NSLog(@"ERROR: StylizeScene has no valid state.");
			break;
		}
	}
}

- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	if(!isInitialized)
		return;
	
	[super updateWithTouchLocationMoved:touches withEvent:event view:aView];
	
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
			[buttonStylize touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[buttonArcadeMode touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[buttonStore touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[buttonOptions touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			break;
		}
			// The scene is phasing out.
		case SceneState_TransitionOut:
		{
			break;
		}
			// The scene is phasing in.
		case SceneState_TransitionIn:
		{
			break;
		}
		default:
		{
			NSLog(@"ERROR: StylizeScene has no valid state.");
			break;
		}
	}
}

- (void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	if(!isInitialized)
		return;
	
	[super updateWithTouchLocationEnded:touches withEvent:event view:aView];
	
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
			[buttonStylize touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[buttonArcadeMode touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[buttonStore touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[buttonOptions touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			break;
		}
			// The scene is phasing out.
		case SceneState_TransitionOut:
		{
			break;
		}
			// The scene is phasing in.
		case SceneState_TransitionIn:
		{
			break;
		}
		default:
		{
			NSLog(@"ERROR: StylizeScene has no valid state.");
			break;
		}
	}
}

- (void)updateWithAccelerometer:(UIAcceleration*)aAcceleration 
{
	if(!isInitialized)
		return;
	
	[super updateWithAccelerometer:aAcceleration];
}

- (void)render 
{
	//if(!isInitialized)
	//	return;
	
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
			[imageNewsFeedBackground render];
			[labelNewsFeed render];
			[labelSceneHeader render];
			[labelSceneSubHeader render];
			[buttonStylize render];
			[buttonArcadeMode render];
			[buttonStore render];
			[buttonOptions render];
			[imagePetBackground render];
			[playerPet render];
			[labelUserName render];
			break;
		}
			// The scene is phasing out.
		case SceneState_TransitionOut:
		{
			break;
		}
			// The scene is phasing in.
		case SceneState_TransitionIn:
		{
			break;
		}
		default:
		{
			NSLog(@"ERROR: StylizeScene has no valid state.");
			break;
		}
	}
}

@end

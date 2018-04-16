//
//  ArcadeScene.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 1/3/11.
//  Copyright 2011 Dustin Atwood. All rights reserved.
//

#define buttonBackX 60
#define buttonBackY 449
#define buttonPrevItemX 30
#define buttonPrevItemY 280
#define buttonNextItemX 290
#define buttonNextItemY 280
#define buttonSubmodeRaceX 70
#define buttonSubmodeRaceY 118
#define buttonSubmodeSurvivalX 250
#define buttonSubmodeSurvivalY 118
#define buttonPlayX 160
#define buttonPlayY 51
#define imageLockX 160
#define imageLockY 190
#define sceneHeaderX 160
#define sceneHeaderY 440
#define imageCurrentPreviewX 160
#define imageCurrentPreviewY 280
#define indicatorUserCurrencyX 222.5
#define indicatorUserCurrencyY 449

#import "ArcadeScene.h"

@implementation ArcadeScene
- (id) init
{
	self = [super init];
	if (self != nil) 
	{
		NSLog(@"Arcade Scene Initializing...");
	}
	return self;
}

- (void) startLoadScene
{
	NSLog(@"Arcade Scene Loading...");
	
	NSLog(@"Loading Labels...20");
	labelInstructGame = [[LabelControl alloc] initWithFontName:FONT21];
	[labelInstructGame setText:@"Select a Game" atSceenPercentage:CGPointMake(50, 80)];
	labelInstructLevel = [[LabelControl alloc] initWithFontName:FONT16];
	[labelInstructLevel setText:@"Choose the Difficulty" atSceenPercentage:CGPointMake(50, 34.375)];
	labelLevel = [[LabelControl alloc] initWithFontName:FONT21];
	[labelLevel setText:@"0" atSceenPercentage:CGPointMake(50, 26)];
	
	NSLog(@"Loading Indicators...40");
	coinIndicatorUser = [[Indicator alloc] initAtScreenPercentage:CGPointMake(71.5625, 96) withSize:2 
														 currencyType:CurrencyType_Coin leftsideIcon:YES];
	treatIndicatorUser = [[Indicator alloc] initAtScreenPercentage:CGPointMake(89.84375, 87.8125) withSize:0 
															  currencyType:CurrencyType_Treat leftsideIcon:NO];
	boostIndicatorUser = [[Indicator alloc] initAtScreenPercentage:CGPointMake(60, 87.8125) withSize:0 
															  currencyType:CurrencyType_Boost leftsideIcon:YES];
	currencyIndicatorCost = [[CurrencyIndicator alloc] initAtScreenPercentage:CGPointMake(50, 16.13)];
	
	NSLog(@"Loading Buttons...60");
	buttonBack = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" withText:@"Back" 
											atScreenPercentage:CGPointMake(18.75, 93.54) isRotated:NO];
	[buttonBack setTarget:self andAction:@selector(loadMenuScene)];
	[buttonBack setButtonColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	
	buttonPrevGame = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" withSubImageNamed:@"buttonPreviousArrow" 
												atScreenPercentage:CGPointMake(10.5, 56.67) isRotated:NO];
	[buttonPrevGame setTarget:self andAction:@selector(showNextGame)];
	[buttonPrevGame	setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
	CGRect newSize = [buttonPrevGame boundingBox];
	newSize.size = CGSizeMake(67.5, 185);
	buttonPrevGame.boundingBox = newSize;
	
	buttonNextGame = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" withSubImageNamed:@"buttonNextArrow" 
												atScreenPercentage:CGPointMake(89.5, 56.67) isRotated:NO];
	[buttonNextGame setTarget:self andAction:@selector(showPrevGame)];
	[buttonNextGame	setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
	newSize = [buttonNextGame boundingBox];
	newSize.size = CGSizeMake(67.5, 185);
	buttonNextGame.boundingBox = newSize;
	NSLog(@"Loading Buttons...70");
	buttonPrevLevel = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" withSubImageNamed:@"buttonPreviousArrow" 
												atScreenPercentage:CGPointMake(25, 26) isRotated:NO];
	[buttonPrevLevel setTarget:self andAction:@selector(showPrevLevel)];
	[buttonPrevLevel	setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
	newSize = [buttonPrevLevel boundingBox];
	newSize.size = CGSizeMake(160, 50);
	buttonPrevLevel.boundingBox = newSize;
	
	buttonNextLevel = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" withSubImageNamed:@"buttonNextArrow" 
												atScreenPercentage:CGPointMake(75, 26) isRotated:NO];
	[buttonNextLevel setTarget:self andAction:@selector(showNextLevel)];
	[buttonNextLevel	setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
	newSize = [buttonNextLevel boundingBox];
	newSize.size = CGSizeMake(160, 50);
	buttonNextLevel.boundingBox = newSize;
	
	buttonAction = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonExtended" withText:@"Play" 
											  atScreenPercentage:CGPointMake(50, 7) isRotated:NO];
	[buttonAction setTarget:self andAction:@selector(loadSelectedGame)];
	[buttonAction setButtonColourFilterRed:0.0 green:1.0 blue:0.0 alpha:1.0];
	
	NSLog(@"Loading Images...80");
	imageCurrentPreview = [[Image alloc] initWithImageNamed:@"EscapePreview"];
	[imageCurrentPreview setPositionAtScreenPrecentage:CGPointMake(50, 56.67) isRotated:NO];

	NSLog(@"Loading Varibles...100");
	currentIndexGame = 0;
	currentIndexLevel = 1;
	
	itemsMinigames = [[NSMutableArray alloc] initWithArray:[sharedSettingManager getItemsInBin:ItemBin_All ofType:ItemType_Minigame]];
	
	[self finishLoadScene];
}

- (void) finishLoadScene
{
	NSLog(@"...Done");
	[self updateWithSelectedGame];
	[self updateWithSelectedLevel];
	[self setIsInitialized:TRUE];
	[self transitioningToCurrentScene];
	[[Director sharedDirector] stopLoading];
}

- (void)transitioningToCurrentScene
{
	if(!isInitialized)
	{
		[[Director sharedDirector] startLoading];
		[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(startLoadScene) userInfo:nil repeats:NO];
	}
	[coinIndicatorUser changeInitialValue:[[sharedSettingManager forProfileGet:ProfileKey_Coins]intValue]];
	[treatIndicatorUser changeInitialValue:[[sharedSettingManager forProfileGet:ProfileKey_Treats]intValue]];
	[boostIndicatorUser changeInitialValue:[[sharedSettingManager forProfileGet:ProfileKey_Boost]intValue]];
	
	if([itemsMinigames count] <= 1)
	{
		[buttonPrevGame setEnabled:FALSE];
		[buttonNextGame setEnabled:FALSE];
	}
	else
	{
		[buttonPrevGame setEnabled:TRUE];
		[buttonNextGame setEnabled:TRUE];
	}
}

- (void) loadMenuScene
{
	[[Director sharedDirector] setCurrentSceneToSceneWithKey:SCENEKEY_MENU];
}

- (void) loadSelectedGame
{
	int uid = [[itemsMinigames objectAtIndex:currentIndexGame] intValue];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"GAME_LEVEL_CHANGE" 
														object:[NSNumber numberWithInt:currentIndexLevel+1]];
	[[Director sharedDirector] setCurrentSceneToSceneWithKey:[sharedSettingManager get:ItemKey_Text withUID:uid]];
}

- (void) unlockSelectedLevel
{
	if(![[[SettingManager sharedSettingManager] forProfileGet:((currentIndexGame * 6) + ProfileKey_Sky_Level1 + currentIndexLevel)] boolValue])
	{
		if([[SettingManager sharedSettingManager] modifyCoinsBy:(-1500 * (currentIndexLevel + 1)) andTreatsBy:-(currentIndexLevel + 1)])
		{
			[[SettingManager sharedSettingManager] forProfileSet:((currentIndexGame * 6) + ProfileKey_Sky_Level1 + currentIndexLevel) 
															  to:@"1"];
			[self updateWithSelectedLevel];
			[treatIndicatorUser addValue:-(currentIndexLevel + 1)];
			[coinIndicatorUser addValue:-1500 * (currentIndexLevel + 1)];
		}
	}
}

- (void) showNextGame
{
	if([itemsMinigames count] <= 1)
		return;
	
	// Increases the selected item index by 1, loops if needed
	currentIndexGame++;
	if (currentIndexGame > [itemsMinigames count] - 1) 
		currentIndexGame = 0;
	
	[self updateWithSelectedGame];
}
- (void) showPrevGame
{
	if([itemsMinigames count] <= 1)
		return;
	
	// Decreases the selected item index by 1, loops if needed
	currentIndexGame--;
	if (currentIndexGame < 0) 
		currentIndexGame = [itemsMinigames count] - 1;
	
	[self updateWithSelectedGame];
}	

- (void) showNextLevel
{
	// Increases the selected item index by 1, loops if needed
	currentIndexLevel++;
	if (currentIndexLevel > 2) 
		currentIndexLevel = 0;
	
	[self updateWithSelectedLevel];
}
- (void) showPrevLevel
{
	// Decreases the selected item index by 1, loops if needed
	currentIndexLevel--;
	if (currentIndexLevel < 0) 
		currentIndexLevel = 2;
	
	[self updateWithSelectedLevel];
}

- (void) updateWithSelectedGame
{
	int uid = [[itemsMinigames objectAtIndex:currentIndexGame] intValue];
		
	[imageCurrentPreview release];
	imageCurrentPreview = [[Image alloc] initWithImageNamed:[NSString stringWithFormat:@"%@Preview", [sharedSettingManager get:ItemKey_Image withUID:uid]]];
	
	[imageCurrentPreview setPositionAtScreenPrecentage:CGPointMake(50, 56.67) isRotated:NO];
	
	[itemsMinigameLevels release];
	itemsMinigameLevels = [[NSMutableArray alloc] initWithArray:[sharedSettingManager getItemsInBin:ItemBin_All ofType:ItemType_Sky_Level]];
	currentIndexLevel = 0;
	[self updateWithSelectedLevel];
}

- (void) updateWithSelectedLevel
{
	// Check to see if the selected level of the minigame is locked in user settings.
	// Set the level lable to the level
	// If the minigame is locked set action button to unlock minigame, change the
	//	text to unlock, set indicator costs
	// Else set the action button to play, change text to play and disable indicator costs
	
	[labelLevel setText:[NSString stringWithFormat:@"Level %D", currentIndexLevel+1] atSceenPercentage:CGPointMake(50, 26)];
	
	if([[[SettingManager sharedSettingManager] forProfileGet:((currentIndexGame * 6) + ProfileKey_Sky_Level1 + currentIndexLevel)] boolValue])
	{
		[buttonAction setText:@"Play"];
		[buttonAction setButtonColourFilterRed:0.0 green:1.0 blue:0.0 alpha:1.0];
		[buttonAction setTarget:self andAction:@selector(loadSelectedGame)];
		[currencyIndicatorCost setIsEnabled:FALSE];
		[buttonAction setSticky:FALSE];
	}
	else
	{
		[buttonAction setText:@"Unlock"];
		[buttonAction setTarget:self andAction:@selector(unlockSelectedLevel)];
		[currencyIndicatorCost setInitialTreats:(currentIndexLevel + 1)];
		[currencyIndicatorCost setInitialCoins:1500 * (currentIndexLevel + 1)];
		if([[[SettingManager sharedSettingManager] forProfileGet:ProfileKey_Treats] intValue] >= (currentIndexLevel + 1) && 
		   [[[SettingManager sharedSettingManager] forProfileGet:ProfileKey_Coins] intValue] >= 1500 * (currentIndexLevel + 1))
		{
			[buttonAction setButtonColourFilterRed:0.0 green:1.0 blue:0.0 alpha:1.0];
			[buttonAction setSticky:FALSE];
		}
		else
		{
			[buttonAction setButtonColourFilterRed:1.0 green:1.0 blue:1.0 alpha:1.0];
			[buttonAction setSticky:TRUE];
		}
	}	
}

- (void)updateWithDelta:(GLfloat)aDelta 
{
	[super updateWithDelta:aDelta];
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
			[treatIndicatorUser updateWithDelta:aDelta];
			[coinIndicatorUser updateWithDelta:aDelta];
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
			NSLog(@"ERROR: ArcadeScene has no valid state.");
			break;
		}
	}
}

- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	[super updateWithTouchLocationBegan:touches withEvent:event view:aView];
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
			[buttonPrevGame touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[buttonNextGame touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[buttonPrevLevel touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[buttonNextLevel touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			// Updates Tab Bar
			[buttonBack touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[buttonAction touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
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
			NSLog(@"ERROR: ArcadeScene has no valid state.");
			break;
		}
	}
}

- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	[super updateWithTouchLocationMoved:touches withEvent:event view:aView];
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
			// Scroll Buttons
			[buttonPrevGame touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[buttonNextGame touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[buttonPrevLevel touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[buttonNextLevel touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			// Updates Tab Bar
			[buttonBack touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[buttonAction touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
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
			NSLog(@"ERROR: ArcadeScene has no valid state.");
			break;
		}
	}
}

- (void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	[super updateWithTouchLocationEnded:touches withEvent:event view:aView];
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
			// Scroll Buttons
			[buttonPrevGame touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[buttonNextGame touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[buttonPrevLevel touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[buttonNextLevel touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			// Updates Tab Bar
			[buttonBack touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[buttonAction touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
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
			NSLog(@"ERROR: ArcadeScene has no valid state.");
			break;
		}
	}
}

- (void)updateWithAccelerometer:(UIAcceleration*)aAcceleration 
{
	[super updateWithAccelerometer:aAcceleration];
}

- (void)render 
{
	if(!isInitialized)
		return;
	
	glPushMatrix();
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
			[imageCurrentPreview render];
			[coinIndicatorUser render];
			[treatIndicatorUser render];
			[currencyIndicatorCost render];
			[boostIndicatorUser render];
			[buttonPrevGame render];
			[buttonNextGame render];
			[buttonPrevLevel render];
			[buttonNextLevel render];
			[labelInstructGame render];
			[labelInstructLevel render];
			[labelInstructLock render];
			[labelLevel render];
			[buttonBack render];
			[buttonAction render];
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
			NSLog(@"ERROR: ArcadeScene has no valid state.");
			break;
		}
	}
	glPopMatrix();
}


@end

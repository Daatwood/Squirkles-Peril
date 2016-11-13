//
//  ArcadeScene.m
//  BadBadMonkey
//
//  Created by Dustin Atwood on 1/3/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

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
	[labelInstructLevel setText:@"Choose a Difficulty Level" atSceenPercentage:CGPointMake(50, 34.375)];
	labelLevel = [[LabelControl alloc] initWithFontName:FONT_LARGE];
	[labelLevel setText:@"0" atSceenPercentage:CGPointMake(50, 27.5)];
	
	NSLog(@"Loading Indicators...40");
	coinIndicatorUser = [[Indicator alloc] initAtScreenPercentage:CGPointMake(71.5625, 96) withSize:2 
														 currencyType:CurrencyType_Coin leftsideIcon:YES];
	treatIndicatorUser = [[Indicator alloc] initAtScreenPercentage:CGPointMake(89.84375, 87.8125) withSize:0 
															  currencyType:CurrencyType_Treat leftsideIcon:NO];
	boostIndicatorUser = [[Indicator alloc] initAtScreenPercentage:CGPointMake(60, 87.8125) withSize:0 
															  currencyType:CurrencyType_Boost leftsideIcon:YES];
	currencyIndicatorCost = [[CurrencyIndicator alloc] initAtScreenPercentage:CGPointMake(50, 16.13)];
	
	NSLog(@"Loading Buttons...60");
	ButtonControl* buttonBack = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" 
																	 withText:@"Back"  withFontName:FONT21
														   atScreenPercentage:CGPointMake(18.75, 93.54)];
	[buttonBack setTarget:self andAction:@selector(loadMenuScene)];
	[buttonBack setButtonColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	[buttonBack setIdentifier:Button_Cancel];
	[[super sceneControls] addObject:buttonBack];
	[buttonBack release];
	
	ButtonControl* buttonPrevGame = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" withSubImageNamed:@"buttonPreviousArrow" 
												atScreenPercentage:CGPointMake(10.5, 56.67)];
	[buttonPrevGame setTarget:self andAction:@selector(showNextGame)];
	[buttonPrevGame	setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
	CGRect newSize = [buttonPrevGame boundingBox];
	newSize.size = CGSizeMake(67.5, 185);
	buttonPrevGame.boundingBox = newSize;
	[buttonPrevGame setIdentifier:Button_Game_Prev];
	[[super sceneControls] addObject:buttonPrevGame];
	[buttonPrevGame release];
	
	ButtonControl* buttonNextGame = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" withSubImageNamed:@"buttonNextArrow" 
												atScreenPercentage:CGPointMake(89.5, 56.67)];
	[buttonNextGame setTarget:self andAction:@selector(showPrevGame)];
	[buttonNextGame	setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
	newSize = [buttonNextGame boundingBox];
	newSize.size = CGSizeMake(67.5, 185);
	buttonNextGame.boundingBox = newSize;
	[buttonNextGame setIdentifier:Button_Game_Next];
	[[super sceneControls] addObject:buttonNextGame];
	[buttonNextGame release];
	
	ButtonControl* buttonPrevLevel = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" withSubImageNamed:@"buttonPreviousArrow" 
												atScreenPercentage:CGPointMake(25, 26)];
	[buttonPrevLevel setTarget:self andAction:@selector(showPrevLevel)];
	[buttonPrevLevel	setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
	newSize = [buttonPrevLevel boundingBox];
	newSize.size = CGSizeMake(160, 50);
	buttonPrevLevel.boundingBox = newSize;
	[buttonPrevLevel setIdentifier:Button_Level_Prev];
	[[super sceneControls] addObject:buttonPrevLevel];
	[buttonPrevLevel release];
	
	ButtonControl* buttonNextLevel = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" withSubImageNamed:@"buttonNextArrow" 
												atScreenPercentage:CGPointMake(75, 26)];
	[buttonNextLevel setTarget:self andAction:@selector(showNextLevel)];
	[buttonNextLevel	setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
	newSize = [buttonNextLevel boundingBox];
	newSize.size = CGSizeMake(160, 50);
	buttonNextLevel.boundingBox = newSize;
	[buttonNextLevel setIdentifier:Button_Level_Next];
	[[super sceneControls] addObject:buttonNextLevel];
	[buttonNextLevel release];
	
	ButtonControl* buttonAction = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonLarge" withText:@"Play" withFontName:FONT_LARGE
											  atScreenPercentage:CGPointMake(50, 7)];
	[buttonAction setTarget:self andAction:@selector(loadSelectedGame)];
	[buttonAction setButtonColourFilterRed:0.0 green:1.0 blue:0.0 alpha:1.0];
	[buttonAction setIdentifier:Button_Action];
	[[super sceneControls] addObject:buttonAction];
	[buttonAction release];
	
	NSLog(@"Loading Images...80");
	imageCurrentPreview = [[Image alloc] initWithImageNamed:@"EscapePreview"];
	[imageCurrentPreview setPositionAtScreenPrecentage:CGPointMake(50, 56.67)];
	
	imageCurrentLevel = [[ResourceManager sharedResourceManager] getImageWithImageNamed:NSStringFromShapeLevel(Shape_Circle) withinAtlasNamed:@"ShapesAtlas"];
	[imageCurrentLevel setPositionAtScreenPrecentage:CGPointMake(50, 26)];
	[imageCurrentLevel setScale:2.0];
	
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
	else
	{
		[coinIndicatorUser changeInitialValue:[[sharedSettingManager for:FileType_Player get:ProfileKey_Coins]intValue]];
		
		//[coinIndicatorUser changeInitialValue:[[sharedSettingManager forProfileGet:ProfileKey_Coins]intValue]];
		[treatIndicatorUser changeInitialValue:0];
		[boostIndicatorUser changeInitialValue:0];
		
		if([itemsMinigames count] <= 1)
		{
			[[super control:Button_Game_Prev] setEnabled:FALSE];
			[[super control:Button_Game_Next] setEnabled:FALSE];
		}
		else
		{
			[[super control:Button_Game_Prev] setEnabled:TRUE];
			[[super control:Button_Game_Next] setEnabled:TRUE];
		}
	}
}

- (void) loadMenuScene
{
	[[Director sharedDirector] setCurrentSceneToSceneWithKey:SCENEKEY_MENU];
}

- (void) loadSelectedGame
{
	//NSString* uid = [itemsMinigames objectAtIndex:currentIndexGame];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"GAME_LEVEL_CHANGE" 
														object:[NSNumber numberWithInt:currentIndexLevel+1]];
	//[[Director sharedDirector] setCurrentSceneToSceneWithKey:[sharedSettingManager get:ItemKey_Text withUID:[itemsMinigames objectAtIndex:currentIndexGame]]];
}
/*
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
*/
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
	if (currentIndexLevel > 7) 
		currentIndexLevel = 0;
	
	[self updateWithSelectedLevel];
}
- (void) showPrevLevel
{
	// Decreases the selected item index by 1, loops if needed
	currentIndexLevel--;
	if (currentIndexLevel < 0) 
		currentIndexLevel = 7;
	
	[self updateWithSelectedLevel];
}

- (void) updateWithSelectedGame
{
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
	
	[imageCurrentLevel release];
	imageCurrentLevel = [[ResourceManager sharedResourceManager] getImageWithImageNamed:NSStringFromShapeLevel(currentIndexLevel+1) withinAtlasNamed:@"ShapesAtlas"];
	[imageCurrentLevel setPositionAtScreenPrecentage:CGPointMake(50, 26)];
	[imageCurrentLevel setScale:1.5];
	[imageCurrentLevel setColourWithColor4f:Color4fFromShapeLevel(currentIndexLevel+1)];
	
	[labelLevel setText:[NSString stringWithFormat:@"%D", currentIndexLevel+1] atSceenPercentage:CGPointMake(50, 26.8)];
	
	[[super control:Button_Action] setText:@"Play"];
	[[super control:Button_Action] setTarget:self andAction:@selector(loadSelectedGame)];
	/*
	if([[[SettingManager sharedSettingManager] forProfileGet:((currentIndexGame * 6) + ProfileKey_Sky_Level1 + currentIndexLevel)] boolValue])
	{
		[[super control:Button_Action] setText:@"Play"];
		[[super control:Button_Action] setTarget:self andAction:@selector(loadSelectedGame)];
		[currencyIndicatorCost setIsEnabled:FALSE];
	}
	else
	{
		[[super control:Button_Action] setText:@"Unlock"];
		[[super control:Button_Action] setTarget:self andAction:@selector(unlockSelectedLevel)];
		
		[currencyIndicatorCost setInitialTreats:(currentIndexLevel + 1)];
		[currencyIndicatorCost setInitialCoins:1500 * (currentIndexLevel + 1)];
	}	
	*/
	// Setup image Preview
	//int uid = [itemsMinigames objectAtIndex:currentIndexGame];
	[imageCurrentPreview release];
	//imageCurrentPreview = [[Image alloc] initWithImageNamed:[NSString stringWithFormat:@"Preview%@%D", [sharedSettingManager get:ItemKey_Image withUID:[itemsMinigames objectAtIndex:currentIndexGame]], 1 ]];
	[imageCurrentPreview setPositionAtScreenPrecentage:CGPointMake(50, 56.67)];
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
			//[buttonPrevGame touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			//[buttonNextGame touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			//[buttonPrevLevel touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			//[buttonNextLevel touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			// Updates Tab Bar
			//[buttonAction touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
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
			//[buttonPrevGame touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			//[buttonNextGame touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			//[buttonPrevLevel touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			//[buttonNextLevel touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			// Updates Tab Bar
			//	[buttonBack touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			//[buttonAction touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
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

- (BOOL)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	BOOL touched = [super updateWithTouchLocationEnded:touches withEvent:event view:aView];
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
			// Scroll Buttons
			//[buttonPrevGame touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			//[buttonNextGame touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			//[buttonPrevLevel touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			//[buttonNextLevel touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			// Updates Tab Bar
			//[buttonBack touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			//[buttonAction touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
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
	return touched;
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
			[imageCurrentLevel render];
			[coinIndicatorUser render];
			[treatIndicatorUser render];
			[currencyIndicatorCost render];
			[boostIndicatorUser render];
			[labelInstructGame render];
			[labelInstructLevel render];
			[labelInstructLock render];
			[labelLevel render];
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
	
	[super render];
	
	glPopMatrix();
}


@end

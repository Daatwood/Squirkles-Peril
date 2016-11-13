//
//  CharacterScene.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 3/8/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#define Button_Next 10
#define Button_Previous 20
#define Image_Mark 30
#define Tutorial_Button 50
#define Tutorial_Label 51
#define Tutorial_Image 52

#import "CharacterScene.h"


@implementation CharacterScene

- (id) init
{
	self = [super init];
	if (self != nil) 
	{
		NSLog(@"Menu Scene Initializing...");
	}
	return self;
}

- (void) startLoadScene
{
	NSLog(@"Menu Scene Loading...");
	
	indicatorPlayer = [[IndicatorPlayer alloc] init];
	indicatorPower = [[IndicatorPower alloc] initAtScreenPercentage:CGPointMake(32, 78)];
	
	indicatorCost = [[Indicator alloc] initAtScreenPercentage:CGPointMake(50, 45.20) 
														 withSize:1 
													 currencyType:CurrencyType_Coin 
													 leftsideIcon:YES];	
	
	characterPreview = [[PetActor alloc] init];
	
	ButtonControl* aButton;
	aButton = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" 
														withText:@"Back" 
													withFontName:FONT21
											  atScreenPercentage:CGPointMake(15, 93.54)];
	[aButton setTarget:self andAction:@selector(loadMenuScene)];
	[aButton setButtonColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	[aButton setIdentifier:Button_Cancel];
	[[super sceneControls] addObject:aButton];
	[aButton release];
	
	aButton = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonNormal" 
														withText:@"" 
													withFontName:FONT21
											  atScreenPercentage:CGPointMake(50.0, 36.5)];
	[aButton setEnabled:TRUE];
	[aButton setIdentifier:Button_Action];
	[[super sceneControls] addObject:aButton];
	[aButton release];
	
	aButton = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" 
											   withSubImageNamed:@"InterfaceArrowLeft"
											  atScreenPercentage:CGPointMake(14, 62.5)];
	[aButton setTarget:self andAction:@selector(showNextCharacter)];
	[aButton setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
	[aButton setIdentifier:Button_Previous];
	[[super sceneControls] addObject:aButton];
	[aButton release];
	
	aButton = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall"
											   withSubImageNamed:@"InterfaceArrowRight" 
											  atScreenPercentage:CGPointMake(86, 62.5)];
	[aButton setTarget:self andAction:@selector(showPreviousCharacter)];
	[aButton setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
	[aButton setIdentifier:Button_Next];
	[[super sceneControls] addObject:aButton];
	[aButton release];
	
	imageLock = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"InterfaceLock" withinAtlasNamed:@"InterfaceAtlas"];
	[imageLock setPositionAtScreenPrecentage:CGPointMake(50, 78)];
	[imageLock setColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	
	Image* anImage;
	anImage = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"InterfacePortrait" withinAtlasNamed:@"InterfaceAtlas"];
	[anImage setPositionAtScreenPrecentage:CGPointMake(50, 62.5)];
	[[super sceneImages] addObject:anImage];
	[anImage release];
	
	anImage = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"InterfaceMark" withinAtlasNamed:@"InterfaceAtlas"];
	[anImage setPositionAtScreenPrecentage:CGPointMake(68, 78)];
	[anImage setColourFilterRed:0.0 green:1.0 blue:0.5 alpha:1.0];
	[anImage setIdentifier:Image_Mark];
	[anImage setAlpha:0.0];
	[[super sceneImages] addObject:anImage];
	[anImage release];
	
	// Show Pet Description Box
	anImage = [[Image alloc] initWithImageNamed:@"InterfaceDescription"];
	[anImage setPositionAtScreenPrecentage:CGPointMake(50, 16.7)];
	[anImage setColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
	[[super sceneImages] addObject:anImage];
	[anImage release];
	// Show Pet Description Label
	LabelControl* aLabel;
	aLabel = [[LabelControl alloc] initWithFontName:FONT16];
	[aLabel setText:@"Squirkle the Alien, loves\nto Jump and feels at\nhome while in space." 
  atSceenPercentage:CGPointMake(52, 26)];
	[[super sceneLabels] addObject:aLabel];
	[aLabel release];
	// Show Boost Label
	aLabel = [[LabelControl alloc] initWithFontName:FONT16];
	[aLabel setText:@"Summon a spaceship!" 
  atSceenPercentage:CGPointMake(56, 10)];
	[[super sceneLabels] addObject:aLabel];
	[aLabel release];
	// Show Boost Image
	anImage = [[Image alloc] initWithImageNamed:@"InterfaceBoost"];
	[anImage setPositionAtScreenPrecentage:CGPointMake(12.5, 10)];
	[anImage setColourFilterRed:1.0 green:1.0 blue:1.0 alpha:1.0];
	[[super sceneImages] addObject:anImage];
	[anImage release];
	
	tutorialOn = FALSE;
	
	[self finishLoadScene];
}

- (void) finishLoadScene
{
	NSLog(@"Finish Loading...");
	[self setIsInitialized:TRUE];
	[self transitioningToCurrentScene];
	[[Director sharedDirector] stopLoading];
}

// Loads Stylize Scene
- (void) loadStylizeScene
{	
	[[Director sharedDirector] setCurrentSceneToSceneWithKey:SCENEKEY_STYLIZE];
}

// Load Menu Scene
- (void) loadMenuScene
{
	[[Director sharedDirector] setCurrentSceneToSceneWithKey:SCENEKEY_MENU];
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
		[indicatorPlayer refresh];
		[self refresh];
	}
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
			[indicatorPlayer updateWithDelta:aDelta];
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

- (BOOL)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	if(!isInitialized)
		return FALSE;
	
	BOOL touched = [super updateWithTouchLocationEnded:touches withEvent:event view:aView];
	
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
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
	return touched;
}

- (void)updateWithAccelerometer:(UIAcceleration*)aAcceleration 
{
	if(!isInitialized)
		return;
	
	[super updateWithAccelerometer:aAcceleration];
}

- (void)render 
{
	glPushMatrix();
	[indicatorPlayer render];
	
    [super render];
    [characterPreview render];
    [indicatorPower render];
    
	[imageLock render];
	[indicatorCost render];
	
	glPopMatrix();
}

// Loads the Next Character
- (void) showNextCharacter
{
	currentIndex++;
	
	if(currentIndex > [[[SettingManager sharedSettingManager] settingsCharacters] count] - 1)
		currentIndex = 0;
	
	[self refresh];
}

// Loads the Previous Character
- (void) showPreviousCharacter
{
	currentIndex--;
	
	if(currentIndex < 0)
		currentIndex = [[[SettingManager sharedSettingManager] settingsCharacters] count] - 1;
	
	[self refresh];
}

// Refreshes the Screen with current Character;
- (void) refresh
{
	// Load up the current character
	[characterPreview loadPartsFrom:currentIndex];
	[indicatorPower refreshWithCharacterIndex:currentIndex];
	
	if([[super control:Button_Action] enabled])
	{
		[[super image:Image_Mark] setAlpha:0.0];
		int characterCost = [[[[[SettingManager sharedSettingManager] settingsCharacters] objectAtIndex:currentIndex] objectAtIndex:ProfileKey_Cost] intValue];
		// The Character is not unlocked yet.
		if(characterCost > 0)
		{
			[imageLock setAlpha:1.0];
			[indicatorCost changeInitialValue:characterCost];
			[indicatorCost setIsEnabled:TRUE];
			[indicatorPower setIsEnabled:FALSE];
			// Unlock Button
			// Set Color
			[[super control:Button_Action] setButtonColourFilterRed:0.0 green:1.0 blue:0.0 alpha:1.0];
			// Set Target
			[[super control:Button_Action] setTarget:self andAction:@selector(buySelectedCharacter)];
			// Set Text
			[[super control:Button_Action] setText:@"Create"];
		}
		else
		{
			[indicatorPower setIsEnabled:TRUE];
			[indicatorCost setIsEnabled:FALSE];
			[imageLock setAlpha:0.0];
			
			if(currentIndex == [[[SettingManager sharedSettingManager] for:FileType_Player get:ProfileKey_Character] intValue])
			{
				[[super image:Image_Mark] setAlpha:1.0];
				// Stylize Button
				// Set Color
				[[super control:Button_Action] setButtonColourFilterRed:1.0 green:1.0 blue:0.0 alpha:1.0];
				// Set Target
				[[super control:Button_Action] setTarget:self andAction:@selector(loadStylizeScene)];
				// Set Text
				[[super control:Button_Action] setText:@"Stylize"];
			}
			else
			{
				[indicatorPower setIsEnabled:TRUE];
				// Select Button
				// Set Color
				[[super control:Button_Action] setButtonColourFilterRed:0.0 green:1.0 blue:0.0 alpha:1.0];
				// Set Target
				[[super control:Button_Action] setTarget:self andAction:@selector(setAsSelectedCharacter)];
				// Set Text
				[[super control:Button_Action] setText:@"Select"];	
			}
		}
	}
}

// Set as Selected Character
- (void) setAsSelectedCharacter
{
	[[SettingManager sharedSettingManager] for:FileType_Player 
										   set:ProfileKey_Character 
										    to:[[NSNumber numberWithInt:currentIndex] stringValue]];
	[self refresh];
	[indicatorPlayer refresh];}

// Attempts to Purchase the Selected Character
- (void) buySelectedCharacter
{	
	int cost = [[[[[SettingManager sharedSettingManager] settingsCharacters] 
				  objectAtIndex:currentIndex] objectAtIndex:ProfileKey_Cost] intValue];
	
	if([[SettingManager sharedSettingManager] forPlayerAdjustCoinsBy:-cost])
	{
		[[[[SettingManager sharedSettingManager] settingsCharacters] 
		  objectAtIndex:currentIndex] replaceObjectAtIndex:ProfileKey_Cost withObject:@"0"];
		
		[indicatorPlayer addCoinValue:-[[[[[SettingManager sharedSettingManager] settingsCharacters] 
										  objectAtIndex:currentIndex] objectAtIndex:ProfileKey_Cost] intValue]];
	
		[self setAsSelectedCharacter];
	}
	[self refresh];
}

@end

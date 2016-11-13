//
//  StageScene.m
//  BadBadMonkey
//
//  Created by Dustin Atwood on 9/20/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

#import "StageScene.h"


@implementation StageScene

- (id) init
{
	self = [super init];
	if (self != nil) 
	{
		NSLog(@"Stage Scene Initializing...");
		font = [[AngelCodeFont alloc] initWithFontImageNamed:@"Komikandy16" controlFile:@"Komikandy16" scale:1.0f filter:GL_LINEAR];
		
		imageMiniHUD = [[Image alloc] initWithImageNamed:@"MiniDisplay"];
		[imageMiniHUD setPosition:CGPointMake(246, 452.5)];
		[imageMiniHUD setColourFilterRed:0.7 green:0.7 blue:0.7 alpha:1.0];
		//indicatorUserPoints = [[CurrencyIndicator alloc] initAtPosition:CGPointMake(278.75, 465) asType:0];
		//indicatorUserTreats = [[CurrencyIndicator alloc] initAtPosition:CGPointMake(278.75, 440) asType:1];
		//indicatorPet = [[LightIndicator alloc] initAtPosition:CGPointMake(220, 452.5)];
		// Starting at 1 and above Red will be shown
		//[indicatorPet addColor:[UIColor redColor] byValue:1];
		// Starting at 0 to 199 will be blue
		//[indicatorPet addColor:[UIColor blueColor] byValue:0];
		// From 200 to 399, Green
		//[indicatorPet addColor:[UIColor greenColor] byValue:200];
		// From 400 to 500(Max) White
		//[indicatorPet addColor:[UIColor whiteColor] byValue:400];
		
		editing = NO;
		
		stopEditingButton = [[ButtonControl alloc] initAsButtonImageNamed:@"CustomStopButton" selectionImage:YES atPosition:CGPointMake(80, 456)];
		[stopEditingButton setTarget:self andAction:@selector(toggleEditing)];
		addItemEditingButton = [[ButtonControl alloc] initAsButtonImageNamed:@"ObjectButton" selectionImage:YES atPosition:CGPointMake(240, 456)];
		[addItemEditingButton setTarget:self andAction:@selector(optionControlShowItems)];
		
		//buttonSound = [[ButtonControl alloc] initAtPosition:CGPointMake(ButtonSoundX, ButtonSoundY) withSize:CGPointMake(20, 20)];
		//buttonSound = [[ButtonControl alloc] initAsButtonImageNamed:@"SoundIndicator" withSelectedColor:[UIColor whiteColor].CGColor 
		//												 atPosition:CGPointMake(ButtonSoundX, ButtonSoundY)];
		//buttonMusic = [[ButtonControl alloc] initAtPosition:CGPointMake(ButtonMusicX, ButtonMusicY) withSize:CGPointMake(20, 20)];
		//buttonMusic = [[ButtonControl alloc] initAsButtonImageNamed:@"MusicIndicator" withSelectedColor:[UIColor whiteColor].CGColor 
		//												 atPosition:CGPointMake(ButtonMusicX, ButtonMusicY)];
		///buttonVibrate = [[ButtonControl alloc] initAtPosition:CGPointMake(ButtonVibrateX, ButtonVibrateY) withSize:CGPointMake(20, 20)];
		//buttonVibrate = [[ButtonControl alloc] initAsButtonImageNamed:@"VibrateIndicator" withSelectedColor:[UIColor whiteColor].CGColor 
		//												 atPosition:CGPointMake(ButtonVibrateX, ButtonVibrateY)];
		stage = [[StageActor alloc] initAsPreview:YES];
		
		pet = [[PetActor alloc] initWithState:0];
		
		optionControl = [[OptionControl alloc] initAsType:ControlType_Menu];
		
		glowingBorder = [[Image alloc] initWithImageNamed:@"GlowingBorder"];
	}
	return self;
}

- (void)transitioningToCurrentScene
{
	[stage setBackgroundActor];
	[pet adjustImages];
}

// Toggles sound effects
- (void) toggleSound
{
	// Toggle sound within settings
}

// Toggles background music
- (void) toggleMusic
{
	// Toggle background music within settings
}

// Toggles vibration
- (void) toggleVibrate
{
	// toggle vibrate within settings
}

// Displays the setting controls
- (void) toggleSettings
{
	// toggle the settings buttons
	[buttonSound setEnabled:NO];
	[buttonMusic setEnabled:NO];
	[buttonVibrate setEnabled:NO];
}

- (void) toggleEditing
{
	if(editing)
	{
		editing = NO;
		[stage lockForeground];
		[stage lockDisplayItem];
	}
	else
	{
		editing = YES;
		[stage unlockForeground];
		[stage unlockDisplayItem];
	}
}

- (void) optionControlShowItems
{
	// This will display the option control
	// and fill it with the users bought items
	// that are currently in storage.
	[self setSceneMode:SceneMode_AddItem];
	[optionControl removeAllItems];
	[optionControl setControlType:ControlType_Hybrid];
	[optionControl addItemWithImage:@"BuyItemButton" setSelected:NO hasSelect:YES hidesOnClick:YES];
	[optionControl addItemWithImage:@"CloseMenuButton" setSelected:NO hasSelect:YES hidesOnClick:YES];
	
	NSArray* storedItems = [[NSArray alloc] initWithArray:
							[sharedSettingManager getItemsInBin:ItemBin_Stored ofType:ItemType_Foreground]];
	
	for (int i = 0; i < 10; i++) 
	{
		if([storedItems count] == 0)
			[optionControl addItemWithImage:@"EmptyIcon" setSelected:NO hasSelect:NO hidesOnClick:NO];
		else if([storedItems count] - 1 < i)
			[optionControl addItemWithImage:@"EmptyIcon" setSelected:NO hasSelect:NO hidesOnClick:NO];
		else
			[optionControl addUID:[[storedItems objectAtIndex:i] intValue] setSelected:NO];
	}
	[optionControl show];
}

- (void) optionControlShowTreats
{
	// This will display the option control
	// and fill it with the users bought items
	// that are currently in storage.
	[self setSceneMode:SceneMode_AddTreat];
	[optionControl removeAllItems];
	[optionControl setControlType:ControlType_Hybrid];
	[optionControl addItemWithImage:@"BuyTreatButton" setSelected:NO hasSelect:YES hidesOnClick:YES];
	[optionControl addItemWithImage:@"CloseMenuButton" setSelected:NO hasSelect:YES hidesOnClick:YES];
	
	NSArray* storedItems = [[NSArray alloc] initWithArray:
							[sharedSettingManager getItemsInBin:ItemBin_Stored ofType:ItemType_Treat]];
	
	for (int i = 0; i < 10; i++) 
	{
		if([storedItems count] == 0)
			[optionControl addItemWithImage:@"EmptyIcon" setSelected:NO hasSelect:NO hidesOnClick:NO];
		else if([storedItems count] - 1 < i)
			[optionControl addItemWithImage:@"EmptyIcon" setSelected:NO hasSelect:NO hidesOnClick:NO];
		else
			[optionControl addUID:[[storedItems objectAtIndex:i] intValue] setSelected:NO];
	}
	[storedItems release];
	[optionControl show];
}

// Displays Option Control for the background
- (void) displayOptionControl
{
	switch (sceneMode) 
	{
		case SceneMode_Idle:
		{
			// The scene is not in a special mode

		}
		case SceneMode_SelectMenu:
		{
			// The scene is awaiting the user to select a menu item
			
			// [NYI] The Scene must figure out if the menu is for the PET or STAGE 
			// [NYI] Stage menu contains: 
			// Browse Rooms: Opens Browsing Scene with Mode set to Stages
			// Browse Improvements: Opens Browsing Scene with Mode set to Improvements
			// Lock/Unlock: Toggles Global Lock/Unlock
			// Add Item: Fills OptionControl with improvements for the scene and Browse All
		
			[optionControl removeAllItems];
			[optionControl setControlType:ControlType_Menu];
			
			[optionControl addItemWithImage:@"CustomStartButton" setSelected:NO hasSelect:YES hidesOnClick:YES];
			[optionControl addItemWithImage:@"CloseMenuButton" setSelected:NO hasSelect:YES hidesOnClick:YES];
			[optionControl addItemWithImage:@"StoreButton" setSelected:NO hasSelect:YES hidesOnClick:YES];
			[optionControl addItemWithImage:@"StylizeButton" setSelected:NO hasSelect:YES hidesOnClick:YES];
			[optionControl addItemWithImage:@"ObjectButton" setSelected:NO hasSelect:YES hidesOnClick:YES];
			[optionControl addItemWithImage:@"TreatButton" setSelected:NO hasSelect:YES hidesOnClick:YES];
			[optionControl show];
			
			break;
		}
		case SceneMode_AddItem:
		{
			// The scene is awaiting the user to add a item to the scene
			[self optionControlShowItems];
			break;
		}
		case SceneMode_AddTreat:
		{
			// The scene is awaiting the user to add a item to the scene
			[self optionControlShowTreats];
			break;
		}
		default:
			break;
	}
}

// Performs the Option Control
- (void) performOptionControl:(int)index
{
	switch (sceneMode) 
	{
		case SceneMode_SelectMenu:
		{
			// The scene is awaiting the user to select a menu item
			switch (index) 
			{
				case 1:
				{
					// Close Menu: Do Nothing
					[self setSceneMode:SceneMode_Idle];
					break;
				}
				case 0:
				{
					// Start Customization
					[self setSceneMode:SceneMode_Idle];
					[self toggleEditing];
					break;
				}
				case 3:
				{
					// Open Mini Games
					// Close the Scene
					// Switch scene to Stylize
					[self setSceneMode:SceneMode_Idle];
					[[Director sharedDirector] setCurrentSceneToSceneWithKey:SCENEKEY_STYLIZE];
					break;
				}
				case 2:
				{
					// Open Stages
					// Close the Scene
					// Switch scene to Store
					[self setSceneMode:SceneMode_Idle];
					[[Director sharedDirector] setCurrentSceneToSceneWithKey:SCENEKEY_MENU];
					break;
				}
				case 5:
				{
					// Display Treats
					//Open the option control filled with userowned treats.
					[self setSceneMode:SceneMode_AddTreat];
					[self displayOptionControl];
					break;
				}
				case 4:
				{
					// Display Add Items
					// Open the option control filled with userowned objects.
					[self setSceneMode:SceneMode_AddItem];
					[self displayOptionControl];
					break;
				}
				default:
				{
					// Unknown Option
					[self setSceneMode:SceneMode_Idle];
					break;
				}
			}
			break;
		}
		case SceneMode_AddItem:
		{
			switch (index) 
			{
					// Buy more Items
				case 0:
				{
					// Close the scene and open foreground browse scene
					[self setSceneMode:SceneMode_Idle];
					[[Director sharedDirector] setCurrentSceneToSceneWithKey:SCENEKEY_STORE];
					break;
				}
					// Close; Do Nothing
				case 1:
				{
					[self setSceneMode:SceneMode_Idle];
					break;
				}
					// Try and add the item to the scene
				default:
				{
					[self setSceneMode:SceneMode_Idle];
					// Add to the stage the item in storage located at index-2;
					// Once added to the cente of the stage, the stage will then
					// enter customization mode.
					NSArray* storedItems = [[NSArray alloc] initWithArray:
											[sharedSettingManager getItemsInBin:ItemBin_Stored ofType:ItemType_Foreground]];
					
					[stage addItemToForegroundActor:[[storedItems objectAtIndex:index-2]intValue]];
					[stage unlockForeground];
					editing = YES;
					[storedItems release];
					break;
				}
			}
 			break;
		}
		case SceneMode_AddTreat:
		{
			switch (index) 
			{
					// Buy more Treats
				case 0:
				{
					// Close the scene and open Treat browse
					[self setSceneMode:SceneMode_Idle];
					[[Director sharedDirector] setCurrentSceneToSceneWithKey:SCENEKEY_STORE];
					break;
				}
					// Close; Do Nothing
				case 1:
				{
					[self setSceneMode:SceneMode_Idle];
					break;
				}
					// Try and feed the pet the selected treat
				default:
				{
					[self setSceneMode:SceneMode_Idle];
					// Feed the pet the item in treat storage located at index-2;
					break;
				}
			}
 			break;
		}
			// Idling also ends here because it was never switch to optioncontrol mode
		default:
			break;
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
			[optionControl updateWithDelta:aDelta];
			if(editing)
			{
				[stopEditingButton updateWithDelta:aDelta];
				[addItemEditingButton updateWithDelta:aDelta];
			}
			else 
			{
				[buttonSound updateWithDelta:aDelta];
				[buttonMusic updateWithDelta:aDelta];
				[buttonVibrate updateWithDelta:aDelta];
				//[indicatorPet setValue:[pet retrieveEmotionLevel]];
				//[indicatorPet updateWithDelta:aDelta];
				[indicatorUserPoints updateWithDelta:aDelta];
				[indicatorUserTreats updateWithDelta:aDelta];
			}
			[stage updateWithDelta:aDelta];
			[pet updateWithDelta:aDelta];
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
			NSLog(@"ERROR: StageScene has no valid state.");
			break;
		}
	}
}

- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	[super updateWithTouchLocationBegan:touches withEvent:event view:aView];
	
	switch ([optionControl state]) 
	{
		case ControlState_Normal:
		{
			[optionControl touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			break;
		}
		case ControlState_Disabled:
		{
			if (editing) 
			{
				[stopEditingButton touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
				[addItemEditingButton touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			}
			[stage touchBeganAtPoint:[[Director sharedDirector] eventArgs].startPoint];
			break;
		}
		default:
			break;
	}
}

- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	[super updateWithTouchLocationMoved:touches withEvent:event view:aView];
	
	switch ([optionControl state]) 
	{
		case ControlState_Normal:
		{
			[optionControl touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			break;
		}
		case ControlState_Disabled:
		{
			if (editing) 
			{
				[stopEditingButton touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
				[addItemEditingButton touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			}
			else 
			{
				[stage touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			}
			break;
		}
		default:
			break;
	}
}

- (void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	[super updateWithTouchLocationEnded:touches withEvent:event view:aView];
	
	switch ([optionControl state]) 
	{
		case ControlState_Normal:
		{
			
			[optionControl touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			int result = [optionControl returnSelectedItem];
			if(result != -1)
			{
				[self performOptionControl:result];
			}
			else if(!CGRectContainsPoint(CGRectMake(0, 0, 320, 216), [Director sharedDirector].eventArgs.endPoint))
				[optionControl hide];
			 
			break;
		}
		case ControlState_Disabled:
		{
			/*
			uint result = 0;
			[stage touchEndedAtPoint:[Director sharedDirector] eventArgs].endPoint];
			if(result == Touch_Successful)	
			{
				[self setSceneMode:SceneMode_SelectMenu];
				[self displayOptionControl];
			}
			 */
			[stage touchEndedAtPoint:[[Director sharedDirector] eventArgs].endPoint];
			if (editing) 
			{
				[stopEditingButton touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
				[addItemEditingButton touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			}
			else
			{
				// Since we are no editing nor have the option control present lets check if
				// the gesture is a swipe
				// If the swipe tracks correctly. 
				
				int HORIZ_SWIPE_DRAG_MIN = -1;
				int VERT_SWIPE_DRAG_MAX = 120;
				int MAX_DIFFERENCE = 10;
				
				float xDifference = fabsf([Director sharedDirector].eventArgs.startPoint.x - [Director sharedDirector].eventArgs.endPoint.x);
				float yDifference = fabsf([Director sharedDirector].eventArgs.startPoint.y - [Director sharedDirector].eventArgs.endPoint.y);
				
				// Has Exceeded a Quick Tap Requirement
				if(xDifference >= MAX_DIFFERENCE || yDifference >= MAX_DIFFERENCE)
				{
					// Maybe a flick or swipe
					if(xDifference != HORIZ_SWIPE_DRAG_MIN && yDifference >= VERT_SWIPE_DRAG_MAX)
					{						
						// A  Swipe is detected now define the direction and Touch Count
						if ([Director sharedDirector].eventArgs.startPoint.y < [Director sharedDirector].eventArgs.endPoint.y) 
						{
							// A Two Finger Swipe Up
							[self setSceneMode:SceneMode_Idle];
							[stage nextBackgroundImage];
						}
						else
						{
							// A Two Finger Swipe Down
							[self setSceneMode:SceneMode_Idle];
							[stage previousBackgroundImage];
						}
					}
				}
				else 
				{
					// Is Considered a Quick Tap
					[self setSceneMode:SceneMode_SelectMenu];
					[self displayOptionControl];
				}	
			}
			break;
		}
		default:
			break;
	}
}

- (void)updateWithAccelerometer:(UIAcceleration*)aAcceleration 
{
	[super updateWithAccelerometer:aAcceleration];
}

- (void)transitionToSceneWithKey:(NSString*)aKey 
{
	
}

- (void)render 
{
	glPushMatrix();
	[stage render];
	[pet render];
	
	if(editing)
	{
		[stopEditingButton render];
		[addItemEditingButton render];
		[glowingBorder renderAtPoint:CGPointMake(160, 240) centerOfImage:YES];
	}
	else 
	{
		[imageMiniHUD render];
		[indicatorUserPoints render];
		[indicatorUserTreats render];
		//[indicatorPet render];
		//[buttonSound render];
		//[buttonMusic render];
		//[buttonVibrate render];
	}

	[optionControl render];
	glPopMatrix();
	[font drawStringAt:CGPointMake(10, 450) text:[NSString stringWithFormat:@"FPS: %1.0f", [[Director sharedDirector] framesPerSecond]]];
}

@end

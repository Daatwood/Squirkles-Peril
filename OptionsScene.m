//
//  OptionsScene
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 1/31/11.
//  Copyright 2011 Dustin Atwood. All rights reserved.
//

#import "OptionsScene.h"


@implementation OptionsScene

- (id) init
{
	self = [super init];
	if (self != nil) 
	{
		NSLog(@"Option Scene Initializing...");
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNewProfileName) name:@"PROFILE_NAME_CHANGE" object:nil];
	}
	return self;
}

- (void) startLoadScene
{
	NSLog(@"Option Scene Loading...");
	
	labelVersion = [[LabelControl alloc] initWithFontName:FONT16];
	[labelVersion setText:[NSString stringWithFormat:@"v%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]
	   atSceenPercentage:CGPointMake(92, 98)];
	
	labelTitle = [[LabelControl alloc] initWithFontName:FONT21];
	[labelTitle setText:@"Options" atSceenPercentage:CGPointMake(60, 90)];
	labelProfile = [[LabelControl alloc] initWithFontName:FONT21];
	[labelProfile setText:@"Profile" atSceenPercentage:CGPointMake(25, 75)];
	labelEffects = [[LabelControl alloc] initWithFontName:FONT21];
	[labelEffects setText:@"Sound Fx" atSceenPercentage:CGPointMake(25, 55)];
	labelMusic = [[LabelControl alloc] initWithFontName:FONT21];
	[labelMusic setText:@"Music" atSceenPercentage:CGPointMake(25, 35)];
	
	labelReset = [[LabelControl alloc] initWithFontName:FONT21];
	[labelReset setText:@"Reset? Are you sure?" atSceenPercentage:CGPointMake(50, 20)];
	
	buttonBack = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" withText:@"Back" 
											atScreenPercentage:CGPointMake(18.75, 93.54) isRotated:NO];
	[buttonBack setTarget:self andAction:@selector(loadMenuScene)];
	[buttonBack setButtonColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	
	
	buttonProfile = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonExtended" withText:@"Profile" 
											atScreenPercentage:CGPointMake(75.0, 75) isRotated:NO];
	[buttonProfile setButtonColourFilterRed:0.0 green:0.0 blue:0.0 alpha:1.0];
	[buttonProfile setTarget:[SettingManager sharedSettingManager] andAction:@selector(showDialogChangeName)];
	
	buttonEffects = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" withText:@"On" 
											atScreenPercentage:CGPointMake(75.0, 55) isRotated:NO];
	[buttonEffects setTarget:self andAction:@selector(toggleEffects)];
	[buttonEffects setButtonColourFilterRed:0.0 green:1.0 blue:0.0 alpha:1.0];
	
	
	buttonMusic = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" withText:@"On" 
											atScreenPercentage:CGPointMake(75.0, 35) isRotated:NO];
	[buttonMusic setTarget:self andAction:@selector(toggleMusic)];
	[buttonMusic setButtonColourFilterRed:0.0 green:1.0 blue:0.0 alpha:1.0];
	
	
	buttonReset = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonExtended" withText:@"Reset" 
											atScreenPercentage:CGPointMake(50, 10) isRotated:NO];
	[buttonReset setTarget:self andAction:@selector(resetAttempt)];
	[buttonReset setButtonColourFilterRed:1.0 green:1.0 blue:0.0 alpha:1.0];
	
	buttonResetConfirm = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" withText:@"Erase" 
											 atScreenPercentage:CGPointMake(20, 10) isRotated:NO];
	[buttonResetConfirm setTarget:self andAction:@selector(resetConfirm)];
	[buttonResetConfirm setButtonColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	
	buttonResetStop = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonExtended" withText:@"Don't Erase" 
											 atScreenPercentage:CGPointMake(75, 10) isRotated:NO];
	[buttonResetStop setTarget:self andAction:@selector(resetCancel)];
	[buttonResetStop setButtonColourFilterRed:0.0 green:1.0 blue:0.0 alpha:1.0];
		
	[self finishLoadScene];
}

- (void) finishLoadScene
{
	NSLog(@"Finish Loading...");
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
	
	[buttonReset setEnabled:TRUE];
	[buttonReset resetStates];
	[buttonResetConfirm setEnabled:FALSE];
	[buttonResetConfirm resetStates];
	[buttonResetStop setEnabled:FALSE];
	[buttonResetStop resetStates];
	[labelReset setEnabled:FALSE];
	
	// Profile
	[buttonProfile setText:[[SettingManager sharedSettingManager] forProfileGet:ProfileKey_Name]];
	[buttonProfile setButtonColourWithString:[[SettingManager sharedSettingManager] forProfileGet:ProfileKey_Pet_Color]];
	
	// Effects
	if([[[SettingManager sharedSettingManager] forProfileGet:ProfileKey_Effects] intValue] == 1)
	{
		[buttonEffects setText:@"On"];
		[buttonEffects setButtonColourFilterRed:0.0 green:1.0 blue:0.0 alpha:1.0];
	}
	else
	{
		[buttonEffects setText:@"Off"];
		[buttonEffects setButtonColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	}
	
	// Music
	if([[[SettingManager sharedSettingManager] forProfileGet:ProfileKey_Music] intValue] == 1)
	{
		[buttonMusic setText:@"On"];
		[buttonMusic setButtonColourFilterRed:0.0 green:1.0 blue:0.0 alpha:1.0];
	}
	else
	{
		[buttonMusic setText:@"Off"];
		[buttonMusic setButtonColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	}
}

- (void) loadMenuScene
{
	[[Director sharedDirector] setCurrentSceneToSceneWithKey:SCENEKEY_MENU];
}

- (void) resetAttempt
{
	[buttonReset setEnabled:FALSE];
	[buttonReset resetStates];
	[buttonResetConfirm setEnabled:TRUE];
	[buttonResetConfirm resetStates];
	[buttonResetStop setEnabled:TRUE];
	[buttonResetStop resetStates];
	[labelReset setEnabled:TRUE];
}

- (void) showNewProfileName
{
	[buttonProfile setText:[[SettingManager sharedSettingManager] forProfileGet:ProfileKey_Name]];
}

- (void) resetConfirm
{
	[[SettingManager sharedSettingManager] resetProfile];
	[self transitioningToCurrentScene];
}

- (void) resetCancel
{
	[buttonReset setEnabled:TRUE];
	[buttonReset resetStates];
	[buttonResetConfirm setEnabled:FALSE];
	[buttonResetConfirm resetStates];
	[buttonResetStop setEnabled:FALSE];
	[buttonResetStop resetStates];
	[labelReset setEnabled:FALSE];
	
}

- (void) toggleEffects
{
	if([[[SettingManager sharedSettingManager] forProfileGet:ProfileKey_Effects] intValue] == 0)
	{
		[[SettingManager sharedSettingManager] forProfileSet:ProfileKey_Effects to:@"1"];
		[buttonEffects setText:@"On"];
		[buttonEffects setButtonColourFilterRed:0.0 green:1.0 blue:0.0 alpha:1.0];
	}
	else 
	{
		[[SettingManager sharedSettingManager] forProfileSet:ProfileKey_Effects to:@"0"];
		[buttonEffects setText:@"Off"];
		[buttonEffects setButtonColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	}
}

- (void) toggleMusic
{
	if([[[SettingManager sharedSettingManager] forProfileGet:ProfileKey_Music] intValue] == 0)
	{
		[[SettingManager sharedSettingManager] forProfileSet:ProfileKey_Music to:@"1"];
		[buttonMusic setText:@"On"];
		[buttonMusic setButtonColourFilterRed:0.0 green:1.0 blue:0.0 alpha:1.0];
	}
	else 
	{
		[[SettingManager sharedSettingManager] forProfileSet:ProfileKey_Music to:@"0"];
		[buttonMusic setText:@"Off"];
		[buttonMusic setButtonColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
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
			[buttonBack touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[buttonReset touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[buttonProfile touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[buttonEffects touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[buttonMusic touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[buttonResetConfirm touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
			[buttonResetStop touchBeganAtPoint:[Director sharedDirector].eventArgs.startPoint];
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
			[buttonBack touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[buttonReset touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[buttonProfile touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[buttonEffects touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[buttonMusic touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[buttonResetConfirm touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
			[buttonResetStop touchMovedAtPoint:[Director sharedDirector].eventArgs.movedPoint];
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
			[buttonBack touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[buttonReset touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[buttonProfile touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[buttonEffects touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[buttonMusic touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[buttonResetConfirm touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
			[buttonResetStop touchEndedAtPoint:[Director sharedDirector].eventArgs.endPoint];
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
			[buttonBack render];
			[buttonReset render];
			[buttonResetConfirm render];
			[buttonResetStop render];
			[buttonEffects render];
			[buttonMusic render];
			[buttonProfile render];
			
			[labelVersion render];
			[labelReset render];
			[labelMusic render];
			[labelTitle render];
			[labelProfile render];
			[labelEffects render];
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
	glPopMatrix();
}

@end

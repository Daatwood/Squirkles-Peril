//
//  JumpScrollerScene.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 11/21/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

#import "JumpScrollerScene.h"

@implementation JumpScrollerScene

// Initialize
- (id) init
{
	if (self = [super init]) 
	{
		NSLog(@"Sky Scene Initializing...");
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responseSetGameLevel:) name:@"GAME_LEVEL_CHANGE" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pause) name:@"APPLICATION_RESIGN_ACTIVE" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveGameState) name:@"APPLICATION_WILL_TERMINATE" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadGameState) name:@"LOAD_SKY_GAME" object:nil];
	}
	return self;
}

- (void) startLoadScene
{
	NSLog(@"Sky Scene Loading...");

	NSLog(@"Creating Font...10%");
	font = [[AngelCodeFont alloc] initWithFontImageNamed:FONT16 controlFile:FONT16 scale:1.0 filter:GL_LINEAR];
	
	NSLog(@"Creating Labels...20%");
	labelLevel = [[LabelControl alloc] initWithFontName:FONT21];
	[[labelLevel font] setColourFilterRed:1.0 green:0.8 blue:0.0 alpha:1.0];
	labelStage = [[LabelControl alloc] initWithFontName:FONT21];
	[[labelStage font] setColourFilterRed:1.0 green:0.8 blue:0.0 alpha:1.0];
	labelBonus = [[LabelControl alloc] initWithFontName:FONT16];
	labelEarned = [[LabelControl alloc] initWithFontName:FONT16];
	[labelEarned setText:@"You Earned" atSceenPercentage:CGPointMake(50, 77)];
	labelGameover = [[LabelControl alloc] initWithFontName:FONT21];
	[labelGameover setText:@"GameOver" atSceenPercentage:CGPointMake(50, 85)];
	labelHiScore = [[LabelControl alloc] initWithFontName:FONT16];
	labelScore = [[LabelControl alloc] initWithFontName:FONT16];
	labelNextLevel = [[LabelControl alloc] initWithFontName:FONT21];
	[labelNextLevel setText:@"Must Reach Stage 6!" atSceenPercentage:CGPointMake(50, 35)];
	[[labelNextLevel font] setColourFilterRed:1.0 green:0.8 blue:0.0 alpha:1.0];
	
	NSLog(@"Calculating Scores...40%");
	pointIndicator = [[Indicator alloc] initAtScreenPercentage:CGPointMake(71.5625, 96) withSize:2
													   currencyType:CurrencyType_Point leftsideIcon:YES];
	boostIndicator = [[Indicator alloc] initAtScreenPercentage:CGPointMake(89.84375, 87.8125) withSize:0
									 currencyType:CurrencyType_Boost leftsideIcon:YES];
	coinIndicator = [[Indicator alloc] initAtScreenPercentage:CGPointMake(71.5625, 96) withSize:2 
													 currencyType:CurrencyType_Coin leftsideIcon:YES];
	treatIndicator = [[Indicator alloc] initAtScreenPercentage:CGPointMake(89.84375, 87.8125) withSize:0 
													  currencyType:CurrencyType_Treat leftsideIcon:NO];
	
	NSLog(@"Imagining Images...50%");
	imageCoin = [[Image alloc] initWithImageNamed:@"iconCurrencyCoin"];
	[imageCoin setPosition:CGPointMake(142, 340)];
	imageBonus = [[Image alloc] initWithImageNamed:@"Nothing"];
	imageBackground = [[Image alloc] initWithImageNamed:@"imageBackgroundPet"];
	[imageBackground setPosition:CGPointMake(160, 300)];
	
	NSLog(@"Pressing Buttons...60%");
	buttonPause = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" 
											  withSubImageNamed:@"buttonSubImagePause" 
											 atScreenPercentage:CGPointMake(87.5, 8) 
													  isRotated:NO];
	[buttonPause setButtonColourFilterRed:1.0 green:1.0 blue:0.0 alpha:1.0];
	[buttonPause setTarget:self andAction:@selector(togglePause)];
	buttonBoost = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" 
											  withSubImageNamed:@"buttonSubImageBoostNeed" 
											 atScreenPercentage:CGPointMake(18, 8) 
													  isRotated:NO];
	[buttonBoost setButtonColourFilterRed:0.0 green:1.0 blue:0.0 alpha:1.0];
	[buttonBoost setTarget:self andAction:@selector(useBoost)];
	NSLog(@"Still Pressing Buttons...70%");
	buttonResume = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonExtended" withText:@"Resume" 
											  atScreenPercentage:CGPointMake(50, 50) isRotated:NO];
	[buttonResume setTarget:self andAction:@selector(togglePause)];
	[buttonResume setButtonColourFilterRed:1.0 green:1.0 blue:0.0 alpha:1.0];
	buttonRestart = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonExtended" withText:@"Play Again" 
													   atScreenPercentage:CGPointMake(70.70, 12.5) isRotated:NO];
	[buttonRestart setTarget:self andAction:@selector(reset)];
	[buttonRestart setButtonColourFilterRed:0.0 green:1.0 blue:0.0 alpha:1.0];
	buttonArcade = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" withText:@"Back"
													atScreenPercentage:CGPointMake(18.75, 12.5) isRotated:NO];
	[buttonArcade setTarget:self andAction:@selector(loadArcadeScene)];
	[buttonArcade setButtonColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	buttonNextLevel = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonExtended" withText:@"Next Level"
													atScreenPercentage:CGPointMake(50, 30) isRotated:NO];
	[buttonNextLevel setTarget:self andAction:@selector(loadNextLevel)];
	
	NSLog(@"Calculating Scores Again...80%");
	player = [[MGSkyPlayer alloc] init];
	platforms = [[NSMutableArray alloc] initWithCapacity:platformsPerColumn];
	obstacles = [[NSMutableArray alloc] initWithCapacity:platformsPerColumn];
	background = [[JumpScrollerBackground alloc] init];
	platformManager = [[MGSkyPlatformManager alloc] init];
		
	NSLog(@"Checking Pencils...90%");

	[self finishLoadScene];
}

- (void) finishLoadScene
{
	[super setAccelerometerSensitivity:0.5f];
	averageDelta = 0.4f;
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
		[player adjustImagesBodyStyle:@"(null)"
						  BodyPattern:@"(null)"
							  Antenna:[sharedSettingManager get:ItemKey_Image 
														withUID:[[sharedSettingManager forProfileGet:Profilekey_Pet_Antenna]intValue]]  
								 eyes:[sharedSettingManager get:ItemKey_Image  
														withUID:[[sharedSettingManager forProfileGet:ProfileKey_Pet_Eyes]intValue]]  
								color:[sharedSettingManager forProfileGet:ProfileKey_Pet_Color]];
		
		// Setting the Boost
		int boost = [[sharedSettingManager forProfileGet:ProfileKey_Boost] intValue];
		[boostIndicator changeInitialValue:boost];
		if(boost > 0)
		{
			[buttonBoost setButtonImageNamed:@"ButtonSmall" withSubImageNamed:@"buttonSubImageBoost"];
			[buttonBoost setButtonColourFilterRed:0.0 green:1.0 blue:0.0 alpha:1.0];
		}
		else
			[buttonBoost setButtonImageNamed:@"ButtonSmall" withSubImageNamed:@"buttonSubImageBoostNeed"];
		
		// Setting Coins
		[coinIndicator changeInitialValue:[[sharedSettingManager forProfileGet:ProfileKey_Coins] intValue]];
		
		// Setting Treats
		[treatIndicator changeInitialValue:[[sharedSettingManager forProfileGet:ProfileKey_Treats] intValue]];
		
		// Setting Points
		[pointIndicator changeInitialValue:0];
		
		// Reset Varibles and Start Game
		[self reset];
		[self pause];
	}
}

// Notification Reponse, Sets the Game's Level
- (void) responseSetGameLevel:(NSNotification*)newLevel
{
	NSNumber *obj = [newLevel object];
	
	gameLevel = [obj intValue];
}

- (void) loadArcadeScene
{
	gameStage = 0;
	sceneState = SceneState_GameOver;
	[[Director sharedDirector] setCurrentSceneToSceneWithKey:SCENEKEY_ARCADE];
}

// Transition to next level;
- (void) loadNextLevel
{
	if(gameStage < 6)
		return;
	
	gameLevel++;
	if(gameLevel > 3)
		gameLevel = 3;
	gameStage = 0;
	
	int points = pointsPlayer;
	
	[self reset];
	
	[pointIndicator changeInitialValue:points];
	pointsPlayer = points;
	
	sceneState = SceneState_Running;
}

- (void) togglePause
{
	if(sceneState == SceneState_Running)
		sceneState = SceneState_Paused;
	else if(sceneState == SceneState_Paused)
		sceneState = SceneState_Running;
}

// Pause Game
- (void) pause
{
	sceneState = SceneState_Paused;
	//[self saveGameState];
}


- (void) saveGameState
{
	// Checks to see if the game state is not set to gameover
	if(sceneState != SceneState_Running && sceneState != SceneState_Paused)
		return;
	
	// If the stage is not greater than 0 then a game has not been started
	if(gameStage == 0)
		return;
	
	NSLog(@"MG-Sky: Saving Game");
	
	NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
	[settings setBool:YES forKey:@"GAME"];
    [settings setInteger:pointsPlayer forKey:@"MGP"];
	NSLog(@"<<MGP: %D", pointsPlayer);
	[settings setFloat:distanceRequired forKey:@"MGD"];
	[settings setInteger:gameStage forKey:@"MGS"];
	[settings setInteger:gameLevel forKey:@"MGL"];
	[settings synchronize];
}

- (void) loadGameState
{
	/*
	NSArray *gameArray = [gameState object];
	
	gameLevel = [[gameArray objectAtIndex:4] intValue];
	gameStage = [[gameArray objectAtIndex:3] intValue] - 1;
	[self reset];
	distanceRequired = [[gameArray objectAtIndex:2] floatValue];
	pointsPlayer = [[gameArray objectAtIndex:1] intValue];
	
	[[SettingManager sharedSettingManager] eraseGameFile];
	 */
	
	NSLog(@"MG-Sky: Loading Game");
	
	NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
	
	
	[self reset];
	gameLevel = [settings integerForKey:@"MGL"];
	gameStage = [settings integerForKey:@"MGS"];
	[self setGameParameters];
	distanceRequired = [settings floatForKey:@"MGD"];
	pointsPlayer = [settings integerForKey:@"MGP"];
	NSLog(@">>MGP: %D", pointsPlayer);
	[pointIndicator changeInitialValue:pointsPlayer];
	[settings setBool:NO forKey:@"GAME"];
	[settings synchronize];
}

// Reset the gameplay
- (void) reset
{
	_pointsPerSecond = 0;
	//_pointsPerSecondUpdate = 0;
	_timePlayed	= 0;
	
	[pointIndicator changeInitialValue:0];
	[boostIndicator setAtScreenPercentage:CGPointMake(89.84375, 87.8125) leftsideIcon:YES];
	pointsPlayer = 0;
	bonusPlayer = 0;
	bonusType = -1;
	gameStage = 0;
	
	// Removes all platform data to allow for repopulation
	//[platformManager removeAllPlatforms];
	platformManager = [[MGSkyPlatformManager alloc] init];
	
	// Prepares the Game by tuning to the correct level settings
	[self setGameParameters];
	
	// Setup Hostile Spawn Distance
	distanceHostile = DistancePerStage * 2;
	
	// Removes all objects in preparation of replenishing them
	[platforms removeAllObjects];
	[obstacles removeAllObjects];
	
	/*
	// Adds new platforms
	for(int i = 0; i < platformsPerColumn; i++)
	{
		JumpScrollerPlatformRow* platform = [[JumpScrollerPlatformRow alloc] init];
		[platforms addObject:platform];
		[platform release];
	}
	
	// Adjusting the placement of the platforms
	for(int i = 0; i < platformsPerColumn; i++)
	{
		[self generateNextPlatform];
		[[platforms lastObject] setNewPosition: CGPointMake(RANDOM(320 + 1), i * (720 / (platformsPerColumn - 1)))];
	}
	 */
	
	// Adjusting the placement of the platforms
	for(int i = 0; i < platformsPerColumn * 3; i+=3)
	{
		// This will create and add new platforms
		[self generateNextPlatform];
		//[[platforms lastObject] setPositionPlatform: CGPointMake(RANDOM(320 + 1), i * (720 / (platformsPerColumn - 1)))];
	}
	
	// Resetting player data
	[player reset];
	
	// Resetting Background data
	[background reset];
	[background adjustScrollingRate: 1 / ([Director sharedDirector].screenBounds.size.height / DistancePerStage)];
	
	// Set the game to running and begins game
	sceneState = SceneState_Running;
}

// Will adjust the game parameters based upon difficulty 
- (void) setGameParameters
{
	//NSLog(@"Stage in %f Seconds", _pointsPerSecondUpdate);
	// Increments the game stage.
	gameStage++;
	
	[labelLevel setText:[NSString stringWithFormat:@"Level %D", gameLevel] atSceenPercentage:CGPointMake(15, 98)];
	[labelStage setText:[NSString stringWithFormat:@"Stage %D", gameStage] atSceenPercentage:CGPointMake(15, 90)];
	switch (gameLevel) 
	{
			
		case 1:
		{
			// Setting up Platforms; Adjusting Min to 12;
			platformsPerColumn = 17 - (gameStage - 1);
			if(platformsPerColumn < 12)
				platformsPerColumn = 12;
			
			// Sets the Distance Per Stage for Level 1
			distanceRequired = DistancePerStage;
			
			switch (gameStage) 
			{
				case 1:
				{
					// Adds Normal Platform
					[platformManager addPlatformWithType:PlatformType_Normal];
					
					// Sets Up Next Level Information
					[labelNextLevel setEnabled:YES];
					[buttonNextLevel setSticky:YES];
					[buttonNextLevel setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
					break;
				}
				case 3:
				{
					// Adds Dissolve Platform
					[platformManager addPlatformWithType:PlatformType_Dissolve];
					break;
				}
				case 5:
				{
					// Adds Fake Platform
					[platformManager addPlatformWithType:PlatformType_Fake andCooldown:7];
					break;
				}
				case 6:
				{
					// Unlocks the next level
					[[SettingManager sharedSettingManager] forProfileSet:(ProfileKey_Sky_HiScore + gameLevel + 1) to:@"1"];
					[labelNextLevel setEnabled:NO];
					[buttonNextLevel setTarget:self andAction:@selector(loadNextLevel)];
					[buttonNextLevel setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
					[buttonNextLevel setSticky:NO];
					break;
				}
				default:
				{
					break;
				}
			}
			break;
		}
		case 2:
		{
			// Setting up Platforms; Adjusting Min to 9;
			platformsPerColumn = 14 - (gameStage - 1);
			if(platformsPerColumn < 9)
				platformsPerColumn = 9;
			
			// Sets the Distance Per Stage for Level 2
			distanceRequired = DistancePerStage;
			//if(distanceAlien == MAXFLOAT)
			//	distanceAlien = (DistancePerStage * 3) * 0.8;
			
			switch (gameStage) 
			{
				case 1:
				{
					// Adds Normal,Dissolve Platform
					[platformManager addPlatformWithType:PlatformType_Normal];
					[platformManager addPlatformWithType:PlatformType_Dissolve];
					
					// Sets Up Next Level Information
					[labelNextLevel setEnabled:YES];
					[buttonNextLevel setSticky:YES];
					[buttonNextLevel setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
					break;
				}
				case 2:
				{
					// Adds Fake Platform
					[platformManager addPlatformWithType:PlatformType_Fake andCooldown:7];
					break;
				}
				case 3:
				{
					// Adds Moving Platform
					[platformManager addPlatformWithType:PlatformType_HMoving];
					break;
				}
				case 4:
				{
					// Adds Net Platform
					[platformManager addPlatformWithType:PlatformType_Net andCooldown:23];
					break;
				}
				case 5:
				{
					// Adds Bouncy Platform
					[platformManager addPlatformWithType:PlatformType_Bouncy andCooldown:11];
					break;
				}
				case 6:
				{
					// Unlocks Next Level
					[[SettingManager sharedSettingManager] forProfileSet:(ProfileKey_Sky_HiScore + gameLevel + 1) to:@"1"];
					[labelNextLevel setEnabled:NO];
					[buttonNextLevel setTarget:self andAction:@selector(loadNextLevel)];
					[buttonNextLevel setButtonColourFilterRed:0.5 green:0.5 blue:1.0 alpha:1.0];
					[buttonNextLevel setSticky:NO];
					break;
				}
				default:
				{
					break;
				}
			}
			break;
		}
		case 3:
		{
			// Setting up Platforms; Adjusting Min to 9;
			platformsPerColumn = (11 - (gameStage - 1));
			if(platformsPerColumn < 7)
				platformsPerColumn = 7;
			
			// Sets the Distance Per Stage for Level 3
			distanceRequired = DistancePerStage;
			///if(distanceAlien == MAXFLOAT)
			//	distanceAlien = (DistancePerStage * 3) * 0.8;
			
			switch (gameStage) 
			{
				case 1:
				{
					// Adds Fake,Dissolve Platform
					[platformManager addPlatformWithType:PlatformType_Dissolve];
					[platformManager addPlatformWithType:PlatformType_Fake andCooldown:7];
					
					// Disable Next Level Info
					[labelNextLevel setEnabled:NO];
					[buttonNextLevel setEnabled:NO];
					break;
				}
				case 2:
				{
					// Adds Moving and Ship
					[platformManager addPlatformWithType:PlatformType_HMoving];
					[platformManager addPlatformWithType:PlatformType_Ship andCooldown:61];
					break;
				}
				case 3:
				{
					// Adds Bouncy/Explosive Platform
					[platformManager addPlatformWithType:PlatformType_Bouncy andCooldown:11];
					[platformManager addPlatformWithType:PlatformType_Explosive andCooldown:13];
					break;
				}
				case 4:
				{
					// Adds Net Platform
					[platformManager addPlatformWithType:PlatformType_Net andCooldown:23];
					break;
				}
				case 5:
				{
					// Adds Star Platform
					[platformManager addPlatformWithType:PlatformType_Star andCooldown:37];
					break;
				}
				default:
				{
					break;
				}
			}
			break;
		}
		default:
		{
			NSLog(@"Invalid Game Level");
			break;
		}
	}
}

- (void) calculateWinnings
{
	int rnd = RANDOM(100);
	int bonusAmt = pointsPlayer / 10;
	
	if(pointsPlayer < 500)
	{
		// No Bonus Awarded
		bonusPlayer = 0;
		bonusType = -1;
	}
	else if (pointsPlayer < 1500) 
	{
		// Must reach 500 Points, For Coin Bonus
		bonusPlayer = (bonusAmt / 2) + RANDOM((bonusAmt / 2));
		bonusType = ProfileKey_Coins;
	}
	else if (pointsPlayer < 3500) 
	{
		// Must reach 1500 Points, For Coin/Boost Bonus
		if(rnd < 60)
		{
			// Coin Bonus 70 - 100; 25%
			bonusPlayer = (bonusAmt / 2) + RANDOM((bonusAmt / 2));
			bonusType = ProfileKey_Coins;
		}
		else 
		{
			// Boost Bonus 1 - 3; 10%
			bonusPlayer = 1 + RANDOM(2);
			bonusType = ProfileKey_Boost;
		}
	}
	else 
	{
		// Must reach 3500 Points, For Coin/Boost/Treat Bonus
		if(rnd < 55)
		{
			// Coin Bonus 100 - 200; 55%
			bonusPlayer = (bonusAmt / 2) + RANDOM((bonusAmt / 2));
			bonusType = ProfileKey_Coins;
		}
		else if(rnd < 90) 
		{
			// Boost Bonus 5 - 10; 35%
			bonusPlayer = bonusAmt * 0.003 + RANDOM(bonusAmt * 0.003);
			bonusType = ProfileKey_Boost;
		}
		else 
		{
			// Treat Bonus 1; 10%
			bonusPlayer = 1;
			bonusType = ProfileKey_Treats;
		}
	}
	
	switch (bonusType) 
	{
		case ProfileKey_Coins:
		{
			imageBonus = [[Image alloc] initWithImageNamed:@"iconCurrencyCoin"];
			[sharedSettingManager modifyCoinsBy:bonusPlayer];
			[coinIndicator addValue:bonusPlayer];
			[labelBonus setText:@"Bonus!" atSceenPercentage:CGPointMake(50, 60)];
			break;
		}
		case ProfileKey_Boost:
		{
			imageBonus = [[Image alloc] initWithImageNamed:@"iconCurrencyBoost"];
			[sharedSettingManager modifyBoostBy:bonusPlayer];
			[boostIndicator addValue:bonusPlayer];
			[labelBonus setText:@"Bonus!" atSceenPercentage:CGPointMake(50, 60)];
			break;
		}
		case ProfileKey_Treats:
		{
			imageBonus = [[Image alloc] initWithImageNamed:@"iconCurrencyTreat"];
			[sharedSettingManager modifyTreatsBy:bonusPlayer];
			[treatIndicator addValue:bonusPlayer];
			[labelBonus setText:@"Bonus!" atSceenPercentage:CGPointMake(50, 60)];
			break;
		}
		default:
		{
			imageBonus = [[Image alloc] initWithImageNamed:@"Nothing"];
			[labelBonus setText:@"No Bonus Yet!" atSceenPercentage:CGPointMake(50, 55)];
			break;
		}
			
	}
	
	[imageBonus setPosition:CGPointMake(142, 258)];
	[sharedSettingManager modifyCoinsBy:bonusAmt];
	[coinIndicator addValue:bonusAmt];
	
	// Calculating if New HiScore
	int previousHiScore = [[sharedSettingManager forProfileGet:ProfileKey_Sky_HiScore] intValue];
	if (previousHiScore < pointsPlayer) 
	{
		previousHiScore = pointsPlayer;
		[sharedSettingManager forProfileSet:ProfileKey_Sky_HiScore to:[[NSNumber numberWithInt:previousHiScore]stringValue]];
	}
	//NSLog(@"%D Points over %F Seconds", [pointIndicator returnTotalPoints], _timePlayed);
	[labelScore setText:[NSString stringWithFormat:@"Score: %d", pointsPlayer] atSceenPercentage:CGPointMake(50, 40)];
	[labelHiScore setText:[NSString stringWithFormat:@"HiScore: %d", previousHiScore] atSceenPercentage:CGPointMake(50, 35)];
	[boostIndicator setAtScreenPercentage:CGPointMake(60, 87.8125) leftsideIcon:YES];
}

// Update
- (void) updateWithDelta:(GLfloat)delta
{
		[super updateWithDelta:delta];
		switch (sceneState) 
		{
				// The Scene is in the forefront and running.
			case SceneState_Running:
			{
				[boostIndicator updateWithDelta:delta];
				[pointIndicator updateWithDelta:delta];
				
				// Calculate the FPS
				_pointsPerSecondUpdate += delta;
				_timePlayed += delta;
				
				// if the delta exceeds the average delta by double
				// then set it to average delta
				if(delta > averageDelta * 2)
					delta = averageDelta;
				
				// Adds to the average Delta;
				averageDelta = (averageDelta + delta) / 2;
				
				// The FPS Counter update intervals
				if(_pointsPerSecondUpdate > 0.5f) 
				{
					_pointsPerSecondUpdate -= 0.5f;
					//	_pointsPerSecond = (pointsPlayer / _timePlayed);
				}
				
				// If delta is has exceeded a second then set it equal to a second.
				// This will have a min frames per second to 1, anything below that may
				// cause unwanted behaviour
				delta *= 1 + (gameLevel * 0.25) + ((gameStage - 1) * 0.025);
				
				// Update the player
				[player updateWithDelta:delta];
				
				float playerVelocity = [player velocityPlayer].y * delta;
				
				// Obstacle Update Loop
				for(int i = 0; i < [obstacles count]; i++)
				{ 
					if([[obstacles objectAtIndex:i] readyForDeletion])
						[obstacles removeObjectAtIndex:i];
					else
					{
						// Simple Update Check and Collision Check
						[[obstacles objectAtIndex:i] updateWithDelta:delta givenPlayer:player];
						
						// If the player position is greater than half the screen move platforms down.
						if ([player positionPlayer].y >= ([Director sharedDirector].screenBounds.size.height / 2) && playerVelocity > 0)
						{
							// Moving platforms down.
							[[obstacles objectAtIndex:i] applyVelocity:playerVelocity];
						}
						
						if ([player positionPlayer].y < [Director sharedDirector].screenBounds.size.height * 0.25 && playerVelocity <= 0)
						{
							// Moving platforms down.
							[[obstacles objectAtIndex:i] applyVelocity:playerVelocity];
						}
					}
				}
				
				// Platform Update Loop
				for(int i = 0; i < [platforms count]; i++) 
				{
					if([[platforms objectAtIndex:i] readyForDeletion])
						[platforms removeObjectAtIndex:i];
					else
					{
						// Simple update check for platforms
						[[platforms objectAtIndex:i] updateWithDelta:delta givenPlayer:player];
						
						// The check is only preformed if the player's velocity is less than 0.
						// Since the player can pass through objects no need to check if collided with em.
						if([[platforms objectAtIndex:i] earnedPoints])
						{
							float increasePoints = [[platforms objectAtIndex:i] rewardPoints];
							pointsPlayer += increasePoints;
							[pointIndicator addValue:increasePoints];
						}
						
						// If the player position is greater than half the screen move platforms down.
						if ([player positionPlayer].y >= ([Director sharedDirector].screenBounds.size.height / 2) && playerVelocity > 0)
						{
							// Moving platforms down.
							[[platforms objectAtIndex:i] applyVelocity:playerVelocity];
						}
						
						if ([player positionPlayer].y < [Director sharedDirector].screenBounds.size.height * 0.25 && playerVelocity <= 0)
						{
							// Moving platforms down.
							[[platforms objectAtIndex:i] applyVelocity:playerVelocity];
						}	
					}
				}
				
				// If the player is in the bottom half of the screen
				// apply velocity to the player.
				if ([player positionPlayer].y < 240 || playerVelocity <= 0)
				{
					// Apply the velocity to the player.
					[player applyVelocity:playerVelocity];
				}
				else
				{
					distanceRequired -= playerVelocity;
					distanceHostile -= playerVelocity;
					[background addScroll:playerVelocity withDelta:1.0];
				}
				
				/*
				 if([[platforms objectAtIndex:0] readyForDeletion])
				 {
				 [self generateNextPlatform];
				 }
				 */
				
				// If Platforms are missing a platform then generate another
				// Each Platform Generation Creates 3
				// So Make sure it can fit 3 before making it
				if([platforms count] + 3 < platformsPerColumn * 3)
				{
					[self generateNextPlatform];
				}
				
				
				if([player readyForDeletion])
				{
					// Player has died, reset
					sceneState = SceneState_GameOver;
					//[[sharedDirector backgroundScene] setIsRunning:TRUE];
					[self calculateWinnings];
					gameStage = 0;
				}
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
				// The Scene is currently paused.
			case SceneState_Paused:
			{
				break;
			}
			case SceneState_GameOver:
			{
				[coinIndicator updateWithDelta:delta];
				[treatIndicator updateWithDelta:delta];
				break;
			}
			default:
			{
				break;
			}
		}
}

- (void)updateWithAccelerometer:(UIAcceleration*)aAcceleration 
{
	switch (sceneState) 
	{
		case SceneState_Running:
		{
			[super updateWithAccelerometer:aAcceleration];
			
			GLfloat data = [[Director sharedDirector] eventArgs].acceleration.x * 10;
			
			if(![player applyAccelerometer:data])
			{
				// If data could not be applied then apply it to the platforms
				for (MGSkyPlatform* platform in platforms) 
				{
					[platform applyAccelerometer:data];
				}
				
				// If data could not be applied then apply it to the obstacles
				for (MGSkyObstacle* obstacle in obstacles) 
				{
					[obstacle applyAccelerometer:data];
				}
			}
			break;
		}
		default:
			break;
	}
}

- (void) useBoost
{
	if ([[[SettingManager sharedSettingManager] forProfileGet:ProfileKey_Boost] intValue] > 0 && ![player inShip]) 
	{
		[sharedSettingManager modifyBoostBy:-1];
		if([[[SettingManager sharedSettingManager] forProfileGet:ProfileKey_Boost] intValue] <= 0)
			[buttonBoost setButtonImageNamed:@"ButtonSmall" withSubImageNamed:@"buttonSubImageBoostNeed"];
		
		[boostIndicator addValue:-1];
		[player applyShip];
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
			
			[buttonPause touchBeganAtPoint:[[Director sharedDirector] eventArgs].startPoint];
			[buttonBoost touchBeganAtPoint:[[Director sharedDirector] eventArgs].startPoint];
			break;
		}
		case SceneState_Paused:
		{
			[buttonResume touchBeganAtPoint:[[Director sharedDirector] eventArgs].startPoint];
			[buttonNextLevel touchBeganAtPoint:[[Director sharedDirector] eventArgs].startPoint];
			[buttonRestart touchBeganAtPoint:[[Director sharedDirector] eventArgs].startPoint];
			[buttonArcade touchBeganAtPoint:[[Director sharedDirector] eventArgs].startPoint];
			break;
		}
		case SceneState_GameOver:
		{
			[buttonRestart touchBeganAtPoint:[[Director sharedDirector] eventArgs].startPoint];
			[buttonArcade touchBeganAtPoint:[[Director sharedDirector] eventArgs].startPoint];
			break;
		}
		default:
		{
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
			[buttonPause touchMovedAtPoint:[[Director sharedDirector] eventArgs].movedPoint];
			[buttonBoost touchMovedAtPoint:[[Director sharedDirector] eventArgs].movedPoint];
			break;
		}
		case SceneState_Paused:
		{
			[buttonResume touchMovedAtPoint:[[Director sharedDirector] eventArgs].movedPoint];
			[buttonNextLevel touchMovedAtPoint:[[Director sharedDirector] eventArgs].movedPoint];
			[buttonRestart touchMovedAtPoint:[[Director sharedDirector] eventArgs].movedPoint];
			[buttonArcade touchMovedAtPoint:[[Director sharedDirector] eventArgs].movedPoint];
			break;
		}
		case SceneState_GameOver:
		{
			[buttonRestart touchMovedAtPoint:[[Director sharedDirector] eventArgs].movedPoint];
			[buttonArcade touchMovedAtPoint:[[Director sharedDirector] eventArgs].movedPoint];
			break;
		}
		default:
		{
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
			[buttonPause touchEndedAtPoint:[[Director sharedDirector] eventArgs].endPoint];
			[buttonBoost touchEndedAtPoint:[[Director sharedDirector] eventArgs].endPoint];
			break;
		}
		case SceneState_Paused:
		{
			[buttonResume touchEndedAtPoint:[[Director sharedDirector] eventArgs].endPoint];
			[buttonNextLevel touchEndedAtPoint:[[Director sharedDirector] eventArgs].endPoint];
			[buttonRestart touchEndedAtPoint:[[Director sharedDirector] eventArgs].endPoint];
			[buttonArcade touchEndedAtPoint:[[Director sharedDirector] eventArgs].endPoint];
			break;
		}
		case SceneState_GameOver:
		{
			[buttonRestart touchEndedAtPoint:[[Director sharedDirector] eventArgs].endPoint];
			[buttonArcade touchEndedAtPoint:[[Director sharedDirector] eventArgs].endPoint];
			break;
		}
		default:
		{
			break;
		}
	}
}

// Reuses an old platform for new
- (void) generateNextPlatform
{
	/*
	id obj = [platforms objectAtIndex:0];
	[obj retain];
	[platforms removeObjectAtIndex:0];
	[platforms addObject:obj];
	[obj release];
	 */
	
	// Create a New platform
	// Setup New platform
	// Add To List
	// Setup Obstacles
	// Add To List
	
	int type = -1, theme;
	
	// The player has reached the next stage
	// update variables first.
	if(distanceRequired <= 0)
		[self setGameParameters];
	
	/*
	// Removing last platform if it exceeds the max amount
	if([platforms count] > platformsPerColumn)
	{
		[platforms removeLastObject];
		return;
	}
	*/
	
	switch (gameLevel) 
	{
		case 1:
		{
			theme = PlatformTheme_Smoke;
			if(distanceHostile <= 0)
			{
				MGSkyObstacle *obstacle = [[MGSkyObstacle alloc] initWithTheme:theme withOwner:nil];
				[obstacle setPositionObstacle:CGPointMake(RANDOM(320 + 1), 
														  -[Director sharedDirector].screenBounds.size.height)];
				[obstacles addObject:obstacle];
				[obstacle release];
				// Spawn at Stage 3
				distanceHostile = DistancePerStage * 2;
			}
			
			break;
		}
		case 2:
		{
			theme = PlatformTheme_Cloud;
			if(distanceHostile <= 0)
			{
				MGSkyObstacle *obstacle = [[MGSkyObstacle alloc] initWithTheme:theme withOwner:nil];
				if(RANDOM(2) == 0)
					[obstacle turnHarmful];
				[obstacle setPositionObstacle:CGPointMake(RANDOM(320 + 1), 
														  -[Director sharedDirector].screenBounds.size.height)];
				[obstacles addObject:obstacle];
				[obstacle release];
				// Spawn at Stage 2.75
				distanceHostile = DistancePerStage * 1.75;
			}
			break;
		}
		case 3:
		{
			theme = PlatformTheme_Space;
			if(distanceHostile <= 0)
			{
				MGSkyObstacle *obstacle = [[MGSkyObstacle alloc] initWithTheme:theme withOwner:nil];
				[obstacle turnHarmful];
				[obstacle setPositionObstacle:CGPointMake(RANDOM(320 + 1), 
														  -[Director sharedDirector].screenBounds.size.height)];
				[obstacles addObject:obstacle];
				[obstacle release];
				// Spawn at Stage 2.5
				distanceHostile = DistancePerStage * 1.5;
			}
			break;
		}
		default:
		{
			NSLog(@"Unknown Level given in platform generation");
			break;
		}
	}
	
	
	
	
	// Setup Center Platform
	MGSkyPlatform* newPlatform;
	CGPoint newPosition = CGPointMake(RANDOM(320 + 1), 
									  [[platforms lastObject] positionPlatform].y + (720 / (platformsPerColumn - 1)));
	type = [platformManager pickReady];
	if(type == -1)
	{
		type = [platformManager pickRandom];
		if(type == -1)
		{
			NSLog(@"Unable to retrieve any platforms setting to normal");
			type = PlatformType_Normal;
		}
	}
	newPlatform = [[MGSkyPlatform alloc] initWithTheme:theme andType:type 
											atPosition:newPosition];
	if((type != PlatformType_Fake || type != PlatformType_Net) && 
	   RANDOM(100) < ((gameLevel * 10) + (gameStage - 1)))
	{
		MGSkyObstacle *obstacle = [[MGSkyObstacle alloc] initWithTheme:theme withOwner:newPlatform];
		[obstacles addObject:obstacle];
		[obstacle release];
	}
	else if(type == PlatformType_Net)
	{
		int loopAmt = 3 + RANDOM(3);
		for (int i = 0; i < loopAmt; i++) 
		{
			MGSkyObstacle *obstacle = [[MGSkyObstacle alloc] initWithTheme:theme withOwner:newPlatform];
			[obstacles addObject:obstacle];
			[obstacle release];
		}
	}
	
	[platforms addObject:newPlatform];
	[newPlatform release];
	
	// Setup Left Platform
	newPosition.x -= [Director sharedDirector].screenBounds.size.width;
	type = [platformManager pickRandom];
	if(type == -1)
	{
		NSLog(@"Unable to retrieve any platforms setting to normal");
		type = PlatformType_Normal;
	}
	
	newPlatform = [[MGSkyPlatform alloc] initWithTheme:theme andType:type 
											atPosition:newPosition];
	if(type != PlatformType_Fake && 
	   RANDOM(100) < ((gameLevel * 10) + (gameStage - 1)))
	{
		MGSkyObstacle *obstacle = [[MGSkyObstacle alloc] initWithTheme:theme withOwner:newPlatform];
		[obstacles addObject:obstacle];
		[obstacle release];
	}
	
	[platforms addObject:newPlatform];
	[newPlatform release];
	
	// Setup Right Platform
	newPosition.x += [Director sharedDirector].screenBounds.size.width * 2;
	type = [platformManager pickRandom];
	if(type == -1)
	{
		NSLog(@"Unable to retrieve any platforms setting to normal");
		type = PlatformType_Normal;
	}
	
	newPlatform = [[MGSkyPlatform alloc] initWithTheme:theme andType:type 
											atPosition:newPosition];
	if(type != PlatformType_Fake && 
	   RANDOM(100) < ((gameLevel * 10) + (gameStage - 1)))
	{
		MGSkyObstacle *obstacle = [[MGSkyObstacle alloc] initWithTheme:theme withOwner:newPlatform];
		[obstacles addObject:obstacle];
		[obstacle release];
	}
	
	[platforms addObject:newPlatform];
	[newPlatform release];
}

// Render
- (void) render
{
	if(!isInitialized)
		return;
	
	@synchronized(self)
	{
		glPushMatrix();
		switch (sceneState) 
		{
				// The Scene is in the forefront and running.
			case SceneState_Running:
			{
				[background render];
				for (MGSkyPlatform* platform in platforms) 
				{ [platform render]; }
				for (MGSkyObstacle* obstacle in obstacles) 
				{ [obstacle render]; }
				
				[player render];
				
				[pointIndicator render];
				[labelLevel render];
				[labelStage render];
				[boostIndicator render];
				[buttonBoost render];
				[buttonPause render];
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
				// The Scene is currently paused.
			case SceneState_Paused:
			{
				[background render];
				
				for (MGSkyPlatform* platform in platforms) 
				{ [platform render]; }
				
				[player render];
				
				[pointIndicator render];
				[labelLevel render];
				[labelStage render];
				
				[boostIndicator render];
				
				[buttonResume render];
				[buttonNextLevel render];
				[labelNextLevel render];
				[buttonRestart render];
				[buttonArcade render];
				break;
			}
			case SceneState_GameOver:
			{
				[imageBackground render];
				[imageCoin render];
				[font drawStringAt:CGPointMake(160, 354) text:[NSString	stringWithFormat:@"%d", pointsPlayer / 10]];
				[imageBonus render];
				if (bonusPlayer > 0)
					[font drawStringAt:CGPointMake(160, 274) text:[NSString	stringWithFormat:@"%d", bonusPlayer]];
				[labelGameover render];
				[labelEarned render];
				[labelBonus render];
				[labelScore render];
				[labelHiScore render];
				//[labelHeight render];
				
				[coinIndicator render];
				[treatIndicator render];
				[boostIndicator render];
				
				[buttonRestart render];
				[buttonArcade render];
				break;
			}
			default:
			{
				break;
			}
		}
		glPopMatrix();
		//[font drawStringAt:CGPointMake(100, 460) text:[NSString stringWithFormat:@"PPS: %1.0f", _pointsPerSecond]];
		//[font drawStringAt:CGPointMake(100, 480) text:[NSString stringWithFormat:@"FPS: %1.0f", [[Director sharedDirector] framesPerSecond]]];
	}
}

@end

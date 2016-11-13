//
//  JumpScrollerScene.m
//  BadBadMonkey
//
//  Created by Dustin Atwood on 11/21/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

#import "JumpScrollerScene.h"

#define Button_OpenFeint 20
#define Button_BuyCoin 21
#define Button_BuyBoost 22
#define Button_SelectLevel 23
#define Button_SelectStage 24

#define Button_Level1 10

#define DEBUG_PLATFORM_REUSE 1

#define AutoAcceptInvites 1

typedef struct {
    CFSwappedFloat32 playerTilt;
} Packet;

@implementation JumpScrollerScene

// 
// --- BASIC ---
// 

// Initialize
- (id) init
{
	if ((self = [super init])) 
	{
		NSLog(@"Sky Scene Initializing...");
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responseSetGameLevel:) name:@"GAME_LEVEL_CHANGE" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setGameParameters) name:@"INCREASE_GAME_STAGE" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPauseScreen) name:@"APPLICATION_RESIGN_ACTIVE" object:nil];
        [MultiplayerManager sharedMultiplayerManager].lobbyDelegate = self;
        [MultiplayerManager sharedMultiplayerManager].gameDelegate = self;
    }
	return self;
}

- (void) startLoadScene
{
	NSLog(@"Sky Scene Loading...");

	font = [[AngelCodeFont alloc] initWithFontImageNamed:FONT16 controlFile:FONT16 scale:1.0 filter:GL_LINEAR];
	
	labelLevel = [[LabelControl alloc] initWithFontName:FONT16];
	[[labelLevel font] setColourFilterRed:1.0 green:0.8 blue:0.0 alpha:1.0];
    [labelLevel setText:@"Stage" atSceenPercentage:CGPointMake(15, 97)];
	labelStage = [[LabelControl alloc] initWithFontName:FONT16];
	[[labelStage font] setColourFilterRed:1.0 green:0.8 blue:0.0 alpha:1.0];
	
	indicatorPlayer = [[IndicatorPlayer alloc] init];

	ButtonControl* button;
    // Start/Resume Button
	button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonLarge" 
                                                       withText:@"Start" 
                                                   withFontName:FONT_LARGE
                                             atScreenPercentage:CGPointMake(50, 10)];
	[button setIdentifier:Button_Action];
    [button setButtonColourFilterRed:0.0 green:1.0 blue:0.0 alpha:1.0];
	[button setTarget:self andAction:@selector(showRunningScreen)];
	[[super sceneControls] addObject:button];
	[button release];
    
    // Pause Button
	button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" 
											  withSubImageNamed:@"InterfacePause" 
											 atScreenPercentage:CGPointMake(84.84, 6.46)];
	[button setIdentifier:Button_Options];
    [button setButtonColourFilterRed:1.0 green:1.0 blue:0.0 alpha:1.0];
	[button setTarget:self andAction:@selector(showPauseScreen)];
	[[super sceneControls] addObject:button];
	[button release];
    
    //End
	button = [[ButtonControl alloc] initAsAtlasButtonImageNamed:@"ButtonSmall" 
													  withText:@"End" withFontName:FONT21
											 atScreenPercentage:CGPointMake(15.15, 84)];
	[button setIdentifier:Button_Cancel];
    [button setTarget:self andAction:@selector(loadMenuScene)];
    [button setButtonColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	[[super sceneControls] addObject:button];
	[button release];
    
	player1 = [[MGSkyPlayer alloc] init];
    player2 = [[MGSkyPlayer alloc] init];
	platforms = [[NSMutableArray alloc] initWithCapacity:platformsPerColumn];
	obstacles = [[NSMutableArray alloc] initWithCapacity:platformsPerColumn];
	background = [[JumpScrollerBackground alloc] init];
	platformManager = [[MGSkyPlatformManager alloc] init];
    
    averageDelta = 0.4f;
	gameScale = 1.0f;
	gameScaleTarget = 1.0f;
    
    gameLevel = [[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Level] intValue];
    gameStage = [[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Stage] intValue];
    gameDistance = 0;//[[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Distance] intValue];
    
    if(gameLevel > 8)
        gameLevel = 8;
    
    if(gameStage > 9)
        gameStage = 1;
    
    if(gameDistance > 100)
        gameDistance = 0;
    
	[self finishLoadScene];
}

- (void) finishLoadScene
{
	[super setAccelerometerSensitivity:0.5f];
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
        
		[indicatorPlayer refresh];
		
		[player1 adjustImagesBodyType:[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Part1] 
                             Antenna:[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Part2]
                                eyes:[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Part3]
								color:[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Color]];
		
        [player2 adjustImagesBodyType:[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Part1] 
                              Antenna:[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Part2]
                                 eyes:[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Part3]
								color:[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Color]];
		
        
		[self showStartScreen];
        //[[MultiplayerManager sharedMultiplayerManager] ]
	}
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
			[indicatorPlayer updateWithDelta:delta];
			[background updateWithDelta:delta];
			
			// if the delta exceeds the average delta by double
			// then set it to average delta
			if(delta > averageDelta * 2)
				delta = averageDelta;
			// Adds to the average Delta;
			averageDelta = (averageDelta + delta) / 2;
			
			// Increasing delta to 1.25 to increase the speed of the game
			delta *= (1.9 + ([[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Level] intValue] / 10));
			
            // Hard Delta Cap
            if(delta > 2.5)
                delta = 2.5;
            
			// Update the player
			[player1 updateWithDelta:delta];
			[player2 updateWithDelta:delta];
            
            // Adjust zoom based on upward velocity
			float playerVelocity = player1.playerInfo.playerVelocity.y;
			if (playerVelocity < 0)
				playerVelocity = 0;
			float newScale = (200 / (playerVelocity * 1.5));
			gameScaleTarget = (gameScaleTarget + newScale) / 2;
			float difference = fabsf(gameScale - gameScaleTarget);
			// Reduce Gamescale
			if(gameScale > gameScaleTarget)
			{
				if (difference > 0.01) 
					gameScale -= 0.01;
				else
					gameScale -= difference;
			}
			// Increase Gamescale
			else if(gameScale < gameScaleTarget)
			{
				if (difference > 0.005) 
					gameScale += 0.005;
				else
					gameScale += difference;
			}
			if(gameScale > 1.0)
				gameScale = 1.0;
			if(gameScale < 0.65)
				gameScale = 0.65;
			
            // Reset local velocity
			playerVelocity = player1.playerInfo.playerVelocity.y * delta;
			
			// Update all obstacles
			for (MGSkyEnemy *enemy in obstacles) 
			{
				// Simple Update Check and Collision Check
				[enemy updateWithDelta:delta withNeighbors:obstacles andPlayer:player1];
				
				// If the player position is greater than half the screen move obstacles down.
				if (player1.playerInfo.playerPosition.y >= ([Director sharedDirector].screenBounds.size.height / 2) && playerVelocity > 0)
				{
					// Moving obstacles down.
					[enemy applyVelocity:playerVelocity];
				}
				
				if (player1.playerInfo.playerPosition.y < [Director sharedDirector].screenBounds.size.height * 0.25 && playerVelocity <= 0)
				{
					// Moving obstacles down.
					[enemy applyVelocity:playerVelocity];
				}
			}
            
            BOOL interactedWithPlayer = FALSE;
			// Update all platforms
			for (MGSkyPlatform *platform in platforms) 
			{
                if(!interactedWithPlayer)
                    interactedWithPlayer = [platform updateWithDelta:delta givenPlayer:player1];
                else
                    interactedWithPlayer = [platform updateWithDelta:delta givenPlayer:nil];
				
				// The check is only preformed if the player's velocity is less than 0.
				// Since the player can pass through objects no need to check if collided with em.
				if([platform earnedPoints])
				{
					float increasePoints = [platform rewardPoints];
					if(increasePoints > 0)
					{
						pointsPlayer += increasePoints;
						[sharedSettingManager forPlayerAdjustCoinsBy:increasePoints];
						[sharedSettingManager forPlayerAdjustExperienceBy:increasePoints];
						gameScaleTarget = 0.5;
					}
				}
				
				// If the player position is greater than half the screen move platforms down.
				if (player1.playerInfo.playerPosition.y >= ([Director sharedDirector].screenBounds.size.height / 2) && playerVelocity > 0)
				{
					// Moving platforms down.
					[platform applyVelocity:playerVelocity];
				}
				
				if (player1.playerInfo.playerPosition.y < [Director sharedDirector].screenBounds.size.height * 0.25 && playerVelocity <= 0)
				{
					// Moving platforms down.
					[platform applyVelocity:playerVelocity];
				}	
			}
			
			// If the player is in the bottom half of the screen
			// apply velocity to the player.
			if (player1.playerInfo.playerPosition.y < ([Director sharedDirector].screenBounds.size.height / 2) || playerVelocity <= 0)
			{
				// Apply the velocity to the player.
				[player1 applyVelocity:playerVelocity];
			}
			else
			{
				distanceRequired -= playerVelocity;
				distanceHostile -= playerVelocity;
				[background increaseBy:playerVelocity];
                gameDistance = [background offsetCurrent] / [background offsetMax] * 100;
                [labelStage setText:[NSString stringWithFormat:@"%d.%d.%d", gameLevel, gameStage, gameDistance] atSceenPercentage:CGPointMake(15, 93)];
			}
			
			// Remove the dead
			[obstacles removeObjectsInArray:[obstacles filteredArrayUsingPredicate:
											 [NSPredicate predicateWithFormat:@"readyForDeletion == TRUE"]]];
            
            NSArray* reusingPlatforms = [platforms filteredArrayUsingPredicate:
                                         [NSPredicate predicateWithFormat:@"readyForDeletion == TRUE"]];
            if([reusingPlatforms count] > 2)
            {
                NSRange range;
                range.location = 0;
                range.length = 3;
                [self generateNextPlatform:[reusingPlatforms subarrayWithRange:range]];
            }
            
			if([player1 readyForDeletion])
				[self showStartScreen];
			
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
			
			if(![player1 applyAccelerometer:data])
			{
				// If data could not be applied then apply it to the platforms
				for (MGSkyPlatform* platform in platforms) 
				{
					[platform applyAccelerometer:data];
				}
				
				// If data could not be applied then apply it to the obstacles
				for (MGSkyEnemy* obstacle in obstacles) 
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

- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView
{
	[super updateWithTouchLocationBegan:touches withEvent:event view:aView];
}

- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView
{
	[super updateWithTouchLocationMoved:touches withEvent:event view:aView];
}

- (BOOL)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView
{
	if(![super updateWithTouchLocationEnded:touches withEvent:event view:aView])
    {
        [self useBoost];
    }
	
	return TRUE;
}

// Render
- (void) render
{
	if(!isInitialized)
		return;
	
	glPushMatrix();
	
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
            // All items within the push/pop will be scaled and adjusted
			glPushMatrix();
			// This will alter the orgination to center opposed to the bottom left.
			glTranslatef((1 - gameScale) * 160, (1 - gameScale) * 240, 0.0f );
			glScalef(gameScale, gameScale, 1.0);
			[background render];
			for (MGSkyPlatform* platform in platforms) 
			{ [platform renderWithinBounds:CGSizeMake(320 / gameScale, 480 / gameScale)]; }
			for (MGSkyEnemy* obstacle in obstacles) 
			{ [obstacle render]; }
			[player1 render];
			glPopMatrix();
			
			[labelLevel render];
			[labelStage render];
			[indicatorPlayer render];
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
            
			[labelLevel render];
			[labelStage render];
			
			[indicatorPlayer render];
			break;
		}
		default:
		{
			break;
		}
	}
	
	[super render]; 

    glPopMatrix();
}

// 
// --- TRANSITIONS AND SETUPS ---
// 

// Load Arcade Scene
- (void) loadMenuScene
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"START_BACKGROUND" object:nil]; 
	sceneState = SceneState_GameOver;
	[[Director sharedDirector] setCurrentSceneToSceneWithKey:SCENEKEY_MENU];
}

// Show/Setup Startup Screen
- (void) showStartScreen
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"STOP_BACKGROUND" object:nil]; 
	// Setup Start Button
	[[super control:Button_Action] setText:@"Start"];
    [[super control:Button_Action] setVisible:TRUE];

	// Setup Back Button
	[[super control:Button_Cancel] setVisible:TRUE];
    
    // Options Button
    [[super control:Button_Options] setVisible:FALSE];
    
	// Reset Game
	[self reset];
	
	sceneState = SceneState_Paused;
}

// Show/Setup Game Screen
- (void) showRunningScreen
{
    [[MultiplayerManager sharedMultiplayerManager] setupSession];
    
	// Disable Start Button
	[[super control:Button_Action] setVisible:FALSE];
	
	// Setup Back Button
	[[super control:Button_Cancel] setVisible:FALSE];
	
	// Setup Pause Button
    [[super control:Button_Options] setVisible:TRUE];
    
	sceneState = SceneState_Running;
}


// Show/Setup Game Screen
- (void) showPauseScreen
{
	if(sceneState != SceneState_Running)
		return;

    [[super control:Button_Options] setVisible:FALSE];
    
	// Setup Resume Button
	[[super control:Button_Action] setText:@"Resume"];
    [[super control:Button_Action] setVisible:TRUE];

	// Setup Back Button
	[[super control:Button_Cancel] setVisible:TRUE];
	
	sceneState = SceneState_Paused;
}

// Notification Reponse, Sets the Game's Level
- (void) responseSetGameLevel:(NSNotification*)newLevel
{
	NSNumber *obj = [newLevel object];
	
	gameLevel = [obj intValue];
}

// 
// --- GAME MECHANICS ---
// 

// Reset the gameplay
- (void) reset
{
	pointsPlayer = 0;
	bonusPlayer = 0;
	bonusType = -1;
    gameStage--;
    gameDistance = 0;

	platformManager = [[MGSkyPlatformManager alloc] init];
    lastMovingDirection = 1;
	
    [background setLevel:gameLevel];

    //float offset = [background offsetCurrent];
	// Prepares the Game by tuning to the correct level settings
	[self setGameParameters];
    //[background increaseBy:offset];
	
	// Setup Hostile Spawn Distance
	distanceHostile = DistancePerStage * 2;
	
	// Removes all objects in preparation of replenishing them
	[platforms removeAllObjects];
	[obstacles removeAllObjects];
	
	// Adjusting the placement of the platforms
	for(int i = 0; i < platformsPerColumn * 3; i+=3)
	{
		// This will create and add new platforms
		[self generateNewPlatform];
	}

	// Resetting player data
	[player1 reset];
	
	// Set the game to running and begins game
	sceneState = SceneState_Running;
}

// Will adjust the game parameters based upon difficulty 
- (void) setGameParameters
{
	// Increments the game stage.
	gameStage++;
	
	// Retrieve the highest stage, save the curruent stage if needed
	int savedLevel = [[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Level] intValue];
	if(gameLevel == savedLevel)
	{
		int savedStage = [[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Stage] intValue];
		if(gameStage > savedStage)
		{
			[[SettingManager sharedSettingManager] for:FileType_Character 
			 set:ProfileKey_Stage to:[[NSNumber numberWithInt:gameStage] stringValue]];
			
			if(gameStage == 10 && gameLevel < 8)
			{
                gameStage = 1;
                gameLevel++;
				[[SettingManager sharedSettingManager] for:FileType_Character 
				 set:ProfileKey_Level to:[[NSNumber numberWithInt:gameLevel] stringValue]];
			}
            [[SettingManager sharedSettingManager] for:FileType_Character 
			 set:ProfileKey_Stage to:[[NSNumber numberWithInt:gameStage] stringValue]];
		}
	}
	
	// Setting Background Data
	[background setOffsetMax:DistancePerStage * (gameStage + .01) * gameLevel];
	[background setOffsetCurrent:0];
	[background setOffset:0];
	
	// Update the level and stage text
	
	[labelStage setText:[NSString stringWithFormat:@"%d.%d.%d", gameLevel, gameStage, gameDistance] atSceenPercentage:CGPointMake(15, 93)];
	
	switch (gameLevel) 
	{
			// Land (Intro)
		case 1:
		{
			platformsPerColumn = 8;
			
			[platformManager addPlatformWithType:PlatformType_Normal];
			[platformManager addPlatformWithType:PlatformType_Dissolve andCooldown:10];
			[platformManager addPlatformWithType:PlatformType_Bouncy andCooldown:3];
			[platformManager addPlatformWithType:PlatformType_FlyThru andCooldown:10];

			break;
		}
			// Sky
		case 2:
		{
			platformsPerColumn = 8;
			
			[platformManager addPlatformWithType:PlatformType_Normal];
			[platformManager addPlatformWithType:PlatformType_Dissolve andCooldown:10];
			[platformManager addPlatformWithType:PlatformType_Fake andCooldown:10];
			[platformManager addPlatformWithType:PlatformType_FlyThru andCooldown:7];
			[platformManager addPlatformWithType:PlatformType_Bouncy];
			
			break;
		}
			// Sky Edge
		case 3:
		{
			platformsPerColumn = 8;
			
			[platformManager addPlatformWithType:PlatformType_Normal];
			[platformManager addPlatformWithType:PlatformType_Dissolve andCooldown:10];
			[platformManager addPlatformWithType:PlatformType_Fake andCooldown:10];
			[platformManager addPlatformWithType:PlatformType_FlyThru];
			[platformManager addPlatformWithType:PlatformType_Bouncy];
			
			break;
		}
			
			// Space
		case 4:
		{
			platformsPerColumn = 7;
			
			[platformManager addPlatformWithType:PlatformType_Normal];
			[platformManager addPlatformWithType:PlatformType_Dissolve andCooldown:7];
			[platformManager addPlatformWithType:PlatformType_Fake andCooldown:7];
			[platformManager addPlatformWithType:PlatformType_FlyThru];
			[platformManager addPlatformWithType:PlatformType_Bouncy];
			
			break;
		}
			// Asteroid
		case 5:
		{
			platformsPerColumn = 7;
			
			[platformManager addPlatformWithType:PlatformType_Normal];
			[platformManager addPlatformWithType:PlatformType_Dissolve andCooldown:7];
			[platformManager addPlatformWithType:PlatformType_Fake andCooldown:7];
			[platformManager addPlatformWithType:PlatformType_FlyThru];
			[platformManager addPlatformWithType:PlatformType_Bouncy];
			
			break;
		}
			// Solar System
		case 6:
		{
			platformsPerColumn = 7;
			
			[platformManager addPlatformWithType:PlatformType_Normal];
			[platformManager addPlatformWithType:PlatformType_Dissolve andCooldown:7];
			[platformManager addPlatformWithType:PlatformType_Fake andCooldown:7];
			[platformManager addPlatformWithType:PlatformType_FlyThru];
			[platformManager addPlatformWithType:PlatformType_Bouncy];
			
			break;
		}
			
			// Galaxy 
		case 7:
		{
			platformsPerColumn = 6;
			
			[platformManager addPlatformWithType:PlatformType_Dissolve];
			[platformManager addPlatformWithType:PlatformType_Fake andCooldown:7];
			[platformManager addPlatformWithType:PlatformType_FlyThru];
			[platformManager addPlatformWithType:PlatformType_Bouncy];
			
			break;
		}
			// Unbound 
		case 8:
		{
			platformsPerColumn = 6;
			
			[platformManager addPlatformWithType:PlatformType_Dissolve];
            [platformManager addPlatformWithType:PlatformType_FlyThru];
			break;
		}
			// Uncontrollable
		case 9:
		{
			platformsPerColumn = 6;
			
			[platformManager addPlatformWithType:PlatformType_Dissolve];
			[platformManager addPlatformWithType:PlatformType_Fake andCooldown:7];
			[platformManager addPlatformWithType:PlatformType_FlyThru];
			[platformManager addPlatformWithType:PlatformType_Bouncy];
			
			break;
		}
			
			// Chaos
		case 10:
		{
			platformsPerColumn = 6;
			
			[platformManager addPlatformWithType:PlatformType_Dissolve];
			//[platformManager addPlatformWithType:PlatformType_Fake andCooldown:7];
			[platformManager addPlatformWithType:PlatformType_FlyThru];
			
			break;
		}
		default:
		{
            platformsPerColumn = 6;
			
			[platformManager addPlatformWithType:PlatformType_Dissolve];
			//[platformManager addPlatformWithType:PlatformType_Fake andCooldown:7];
			[platformManager addPlatformWithType:PlatformType_FlyThru];
			break;
		}
	}
}

- (void) useBoost
{
	if([player1 isBoosting])
		return;
	
	if ([[SettingManager sharedSettingManager] forPlayerAdjustBoostBy:-1]) 
	{
        [player1 applyBoost];
	}
}

// Creates a new platform when one has died.
- (void) generateNewPlatform
{
	int spawnChance = 0;
	if(gameLevel < 3)
		spawnChance = gameStage - 1;
	else if(gameLevel < 5)
		spawnChance = 10 + gameStage - 1;
	else if(gameLevel < 7)
		spawnChance = 20 + gameStage;
	else
		spawnChance = 33;
    
	if(RANDOM(100) < spawnChance)
	{
		MGSkyEnemy* newObstacle = [[MGSkyEnemy alloc] initAsShape:1 + RANDOM(gameLevel)];
		[newObstacle setPositionCurrent:CGPointMake(RANDOM(320 + 1), 
													[[platforms lastObject] positionPlatform].y + (960 / (platformsPerColumn - 1)))];
		[obstacles addObject:newObstacle];
		[newObstacle release];
	}

	// ----- Setup Center Platform
    
    lastMovingDirection *= -1;
    
	MGSkyPlatform* newPlatform;
	CGPoint newPosition = CGPointMake(RANDOM(320 + 1), 
									  [[platforms lastObject] positionPlatform].y + (960 / (platformsPerColumn - 1)));
	
	 newPlatform = [[MGSkyPlatform alloc] initWithType:[platformManager pickReady] 
	 atPosition:newPosition
	 withMovementDirection:lastMovingDirection];
	 [platforms addObject:newPlatform];
	 [newPlatform release];
	 
	// ----- Setup Left Platform
	newPosition.x -= [Director sharedDirector].screenBounds.size.width;
	
	 newPlatform = [[MGSkyPlatform alloc] initWithType:[platformManager pickReady] 
	 atPosition:newPosition
	 withMovementDirection:lastMovingDirection];
	 [platforms addObject:newPlatform];
	 [newPlatform release];
	 
	// ----- Setup Right Platform
	newPosition.x += [Director sharedDirector].screenBounds.size.width * 2;
	
	 newPlatform = [[MGSkyPlatform alloc] initWithType:[platformManager pickReady] 
	 atPosition:newPosition
	 withMovementDirection:lastMovingDirection];
	 [platforms addObject:newPlatform];
	 [newPlatform release]; 
}

// Reuses an old platform for new
- (void) generateNextPlatform:(NSArray*)reusePlatforms
{
    // GENERATE OBJSTACLE
	int spawnChance = 0;
	if(gameLevel < 4)
		spawnChance = gameStage - 1;
	else if(gameLevel < 7)
		spawnChance = 10 + gameStage - 1;
	else if(gameLevel < 10)
		spawnChance = 20 + gameStage;
	else
		spawnChance = 33;
	if(RANDOM(100) < spawnChance)
	{
		MGSkyEnemy* newObstacle = [[MGSkyEnemy alloc] initAsShape:1 + RANDOM(gameLevel)];
		[newObstacle setPositionCurrent:CGPointMake(RANDOM(320 + 1), 
													[[platforms lastObject] positionPlatform].y + (960 / (platformsPerColumn - 1)))];
		[obstacles addObject:newObstacle];
		[newObstacle release];
	}
    
    
    // GENERATE PLATFORMS
    lastMovingDirection *= -1;
    
	// New Position
	CGPoint newPosition = CGPointMake(RANDOM(320 + 1), 
									  [[platforms lastObject] positionPlatform].y + (960 / (platformsPerColumn - 1)));
	
    // Removes the objects.
	[platforms removeObjectsInArray:reusePlatforms];
	// Add the objects to the end of the array
	[platforms addObjectsFromArray:reusePlatforms];
    
    // Reset Center Platform
	[[reusePlatforms objectAtIndex:0] resetWithType:[platformManager pickReady] 
                                         atPosition:newPosition
                              withMovementDirection:lastMovingDirection];
	// ----- Setup Left Platform
	[[reusePlatforms objectAtIndex:1] resetWithType:[platformManager pickReady] 
                                         atPosition:CGPointMake(newPosition.x - [Director sharedDirector].screenBounds.size.width, newPosition.y)
                              withMovementDirection:lastMovingDirection];
	// ----- Setup Right Platform
	[[reusePlatforms objectAtIndex:2] resetWithType:[platformManager pickReady] 
                                         atPosition:CGPointMake(newPosition.x + [Director sharedDirector].screenBounds.size.width, newPosition.y)
                              withMovementDirection:lastMovingDirection];
}


// Called when user selects a peer from the list or accepts a call invitation.
- (void) openGameScreenWithPeerID:(NSString *)peerID
{
	NSLog(@"Starting game with Peer:%@", peerID);
}

- (void) peerListDidChange:(MultiplayerManager *)session;
{
    NSLog(@"Peerlist did change.. %@", [[session peerList] description]);
}

// Invitation dialog due to peer attempting to connect.
- (void) didReceiveInvitation:(MultiplayerManager *)session fromPeer:(NSString *)participantID;
{
    NSLog(@"Received Invitation..");
    
    if(AutoAcceptInvites)
    {
        // Auto accept invitation
        if ([[MultiplayerManager sharedMultiplayerManager] didAcceptInvitation])
            [self openGameScreenWithPeerID:[MultiplayerManager sharedMultiplayerManager].currentConfPeerID];  
    }
    else
    {
        NSString *str = [NSString stringWithFormat:@"Incoming Invite from %@", participantID];
        if (alertView.visible) {
            [alertView dismissWithClickedButtonIndex:0 animated:NO];
            [alertView release];
        }
        alertView = [[UIAlertView alloc] 
                     initWithTitle:str
                     message:@"Do you wish to accept?" 
                     delegate:self 
                     cancelButtonTitle:@"Decline" 
                     otherButtonTitles:nil];
        [alertView addButtonWithTitle:@"Accept"]; 
        [alertView show];
    }
}

// Display an alert sheet indicating a failure to connect to the peer.
- (void) invitationDidFail:(MultiplayerManager *)session fromPeer:(NSString *)participantID
{
    // Invitation did fail
}

// User has reacted to the dialog box and chosen accept or reject.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1) 
    {
        // User accepted.  Open the game screen and accept the connection.
        if ([[MultiplayerManager sharedMultiplayerManager] didAcceptInvitation])
            [self openGameScreenWithPeerID:[MultiplayerManager sharedMultiplayerManager].currentConfPeerID]; 
	} 
    else 
    {
        [[MultiplayerManager sharedMultiplayerManager] didDeclineInvitation];
	}
}

// === Game Delegates

- (void) voiceChatWillStart:(MultiplayerManager *)session
{
    // Starting voice chat
}

// Send the same information each time, just with a different header
-(void) sendPacket:(PacketType)packetType
{
    Packet outgoing;
    
    outgoing.playerTilt = CFConvertFloat32HostToSwapped(player1.playerInfo.playerTilt);
    
    NSData *packet = [[NSData alloc] initWithBytes:&outgoing length:sizeof(Packet)];
    [[MultiplayerManager sharedMultiplayerManager] sendPacket:packet ofType:packetType];
    [packet release];
}

- (void) session:(MultiplayerManager *)session didConnectAsInitiator:(BOOL)shouldStart
{
    NSLog(@"Connected");
    
    [self sendPacket:PacketTypeStart];
}

// If hit end call or the call failed or timed out, clear the state and go back a screen.
- (void) willDisconnect:(MultiplayerManager *)session
{    
    NSLog(@"Will disconnect..");
}

// The GKSession got a packet and sent it to the game, so parse it and update state.
- (void) session:(MultiplayerManager *)session didReceivePacket:(NSData*)data ofType:(PacketType)packetType
{
    //NSLog(@"Did recieve Packet..");
    Packet incoming;
    if ([data length] == sizeof(Packet)) {
        [data getBytes:&incoming length:sizeof(Packet)];
        
        switch (packetType) 
        {
            case PacketTypeStart:
            {
                // The other player started the game, so unpause our graphics
                
                [player2 adjustImagesBodyType:[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Part1] 
                                      Antenna:[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Part2]
                                         eyes:[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Part3]
                                        color:[[SettingManager sharedSettingManager] for:FileType_Character get:ProfileKey_Color]];
                
                PlayerInfo info = player2.playerInfo;
                info.playerPosition = CGPointMake(300, 240);
                info.playerTilt = CFConvertFloat32SwappedToHost(incoming.playerTilt);
                player2.playerInfo = info;
                player2.isAlive = TRUE;
                break;
            }
            case PacketTypeMove:
            {
                PlayerInfo info = player2.playerInfo;
                info.playerTilt = CFConvertFloat32SwappedToHost(incoming.playerTilt);
                player2.playerInfo = info;
                break;
            }
            default:
                break;
        }
    }
}


@end

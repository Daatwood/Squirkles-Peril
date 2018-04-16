//
//  SideScrollerScene.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 11/5/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

#import "SideScrollerScene.h"


@implementation SideScrollerScene

// Initialize
- (id) init
{
	if (self = [super init]) 
	{
		NSLog(@"Escape Scene Initializing...");
		
	}
	return self;
}

- (void) startLoadScene
{
	NSLog(@"Escape Scene Loading...");
	
	font = [[AngelCodeFont alloc] initWithFontImageNamed:FONT16 controlFile:FONT16 scale:1.0 filter:GL_LINEAR];
	[font setRotation:90];
	
	labelLevel = [[LabelControl alloc] initWithFontName:FONT21];
	labelStage = [[LabelControl alloc] initWithFontName:FONT21];
	labelBonus = [[LabelControl alloc] initWithFontName:FONT16];
	labelEarned = [[LabelControl alloc] initWithFontName:FONT16];
	[labelEarned setText:@"You Earned" atSceenPercentage:CGPointMake(50, 77)];
	labelGameover = [[LabelControl alloc] initWithFontName:FONT21];
	[labelGameover setText:@"GameOver" atSceenPercentage:CGPointMake(50, 85)];
	labelHeight = [[LabelControl alloc] initWithFontName:FONT16];
	labelHiScore = [[LabelControl alloc] initWithFontName:FONT16];
	labelScore = [[LabelControl alloc] initWithFontName:FONT16];
	
	pointIndicator = [[PointIndicator alloc] initAtScreenPercentage:CGPointMake(78.125, 96)];
	boostIndicator = [[BoostIndicator alloc] initBoost:0 atScreenPercentage:CGPointMake(89.84375, 87.8125)];
	currencyIndicator = [[CurrencyIndicator alloc] initAtScreenPercentage:CGPointMake(78.125, 96)];
	
	imageCoin = [[Image alloc] initWithImageNamed:@"imageCoin"];
	[imageCoin setPosition:CGPointMake(143, 340)];
	imageBonus = [[Image alloc] initWithImageNamed:@"Nothing"];
	imageOverlayMask = [[Image alloc] initWithImageNamed:@"imageBackground"];
	[imageOverlayMask setPosition:CGPointMake(160, 240)];
	imageBackground = [[Image alloc] initWithImageNamed:@"imageBackgroundPet"];
	[imageBackground setPosition:CGPointMake(160, 300)];
	
	
	buttonPause = [[ButtonControl alloc] initAsButtonImageNamed:@"Nothing" selectionImage:NO 
													 atPosition:CGPointMake(280, 40)];
	[buttonPause setTarget:self andAction:@selector(togglePause)];
	
	buttonRestart = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonExtended" withText:@"Play Again" selectionImage:NO 
													   atPosition:CGPointMake(160+50, 61)];
	[buttonRestart setTarget:self andAction:@selector(reset)];
	[buttonRestart setButtonColourFilterRed:0.0 green:1.0 blue:0.0 alpha:1.0];
	
	
	buttonArcade = [[ButtonControl alloc] initAsButtonImageNamed:@"ButtonSmall" withText:@"Back" selectionImage:NO 
													  atPosition:CGPointMake(60, 61)];
	[buttonArcade setTarget:self andAction:@selector(loadArcadeScene)];
	[buttonArcade setButtonColourFilterRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	
	
	player = [[SideScrollerPlayerObject alloc] init];
	SideScrollerGroundObject* groundObject1 = [[SideScrollerGroundObject alloc] init];
	SideScrollerGroundObject* groundObject2 = [[SideScrollerGroundObject alloc] init];
	groundObjects = [[NSMutableArray alloc] initWithObjects:groundObject1, groundObject2, nil];
	highscorePoints = 0;
	
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
	
	[player adjustImagesAntenna:[sharedSettingManager get:ItemKey_Image 
												  withUID:[[sharedSettingManager forProfileGet:Profilekey_Pet_Antenna]intValue]] 
						   eyes:[sharedSettingManager get:ItemKey_Image  
												  withUID:[[sharedSettingManager forProfileGet:ProfileKey_Pet_Eyes]intValue]] 
						  color:[sharedSettingManager forProfileGet:ProfileKey_Pet_Color]];
	
	[self reset];
	
}

- (void) loadArcadeScene
{
	[[Director sharedDirector] setCurrentSceneToSceneWithKey:SCENEKEY_ARCADE];
}

- (void) togglePause
{
	if(sceneState == SceneState_Running)
		sceneState = SceneState_Paused;
	else if(sceneState == SceneState_Paused)
		sceneState = SceneState_Running;
}

// Reset the gameplay
- (void) reset
{
	//[player	changeColor:[sharedSettingManager petColor]];
	sceneState = SceneState_Running;
	[player reset];
	totalPoints = 0;
	totalDistance = 0;
	islandSpecialCounter = 3 + RANDOM(5);
	[[groundObjects objectAtIndex:0] resetWithType:0 position:CGPointMake(0, 144) size:CGSizeMake(960, 144)];
	[[groundObjects objectAtIndex:1] resetWithType:0 position:CGPointMake(960+64, 16) size:CGSizeMake(480, 16)];
}

- (void) calculateBonus
{
	int rnd = RANDOM(100);
	int bonusAmt = totalPoints / 10;
	[labelBonus setText:@"Bonus!" atSceenPercentage:CGPointMake(50, 60)];
	
	if(totalPoints < 500)
	{
		// No Bonus Awarded
		bonusAmount = 0;
		bonusType = -1;
	}
	else if (totalPoints < 750) 
	{
		// Coin Bonus 30 - 70; 30%
		bonusAmount = bonusAmt + RANDOM(bonusAmt);
		bonusType = ProfileKey_Coins;
	}
	else if (totalPoints < 1000) 
	{
		if(rnd < 60)
		{
			// Coin Bonus 70 - 100; 25%
			bonusAmount = bonusAmt + RANDOM(bonusAmt);
			bonusType = ProfileKey_Coins;
		}
		else 
		{
			// Boost Bonus 1 - 3; 10%
			bonusAmount = 1 + RANDOM(2);
			bonusType = ProfileKey_Boost;
		}
	}
	else 
	{
		if(rnd < 55)
		{
			// Coin Bonus 100 - 200; 55%
			bonusAmount = bonusAmt + RANDOM(bonusAmt);
			bonusType = ProfileKey_Coins;
		}
		else if(rnd < 90) 
		{
			// Boost Bonus 5 - 10; 35%
			bonusAmount = bonusAmt * .5 + RANDOM(bonusAmt * .5);
			bonusType = ProfileKey_Boost;
		}
		else 
		{
			// Treat Bonus 1; 10%
			bonusAmount = 1;
			bonusType = ProfileKey_Treats;
		}
	}
	
	switch (bonusType) 
	{
		case ProfileKey_Coins:
		{
			imageBonus = [[Image alloc] initWithImageNamed:@"imageCoin"];
			[sharedSettingManager modifyCoinsBy:bonusAmount];
			[currencyIndicator addCoins:bonusAmount];
			break;
		}
		case ProfileKey_Boost:
		{
			imageBonus = [[Image alloc] initWithImageNamed:@"imageBoost"];
			[sharedSettingManager modifyBoostBy:bonusAmount];
			[boostIndicator addBoost:bonusAmount];
			break;
		}
		case ProfileKey_Treats:
		{
			imageBonus = [[Image alloc] initWithImageNamed:@"imageTreat"];
			[sharedSettingManager modifyTreatsBy:bonusAmount];
			[currencyIndicator addTreats:bonusAmount];
			break;
		}
		default:
		{
			imageBonus = [[Image alloc] initWithImageNamed:@"Nothing"];
			[labelBonus setText:@"No Bonus Yet!" atSceenPercentage:CGPointMake(50, 55)];
			break;
		}
			
	}
	[imageBonus setPosition:CGPointMake(132, 268)];
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
			if([player isAlive])
			{
				// Update the player
				[player updateWithDelta:delta];
				
				BOOL velocityRecievedAttention = FALSE;
				// Check for collisions and apply velocity
				for (SideScrollerGroundObject* groundObj in groundObjects) 
				{
					if(!velocityRecievedAttention)
						velocityRecievedAttention = [groundObj hasCollidedWithPlayer:player];
					// Apply the velocity data to the grounds
					[groundObj applyVelocity:[player velocity]];
				}
				// Apply the velocity data to the player
				[player applyVelocity];
				
				// If velocity recieved no attention then the player is probably over a gap
				// Set the player to fall
				if(!velocityRecievedAttention)
				{
					if([player onGround])
					{
						//NSLog(@"Player is over a Gap");
						[player setOnGround:FALSE];
						// Prevent the player from attempting a jump when its too late
						[player setCanDoubleJump:FALSE];
					}
				}
				if(![[groundObjects objectAtIndex:0] isAlive])
					[self generateNextIsland];
				
				// One Distance Unit per 325 Pixels
				totalDistance += ([player velocity].x / 325) * delta;
				if(totalDistance >= 500)
					NSLog(@"%f Distance reached with %f Points.", totalDistance, totalPoints);
				
				// The player recieves different amounts of points when he is jumping vs flying/running
				// Points are based off of 1 distance unit.
				float pointsEarned = ([player velocity].x / 65) * delta;
				// When on the ground/flying the players receives 5 times as much
				if([player onGround] || [player isFlying])
					pointsEarned *= 5;
				totalPoints += pointsEarned;
				
				/*
				if([player onGround] || [player isFlying])
					totalPoints +=  ([player velocity].x / 65) * delta;
				else
					totalPoints +=  ([player velocity].x / 325) * delta;
				 */
			}
			else 
			{
				sceneState = SceneState_GameOver;
				[self calculateBonus];
				[sharedSettingManager modifyCoinsBy:(totalPoints / 10)];
				[currencyIndicator addCoins:(totalPoints / 10)];
				
				float previousHiScore = [[sharedSettingManager forProfileGet:ProfileKey_Sky_HiScore] floatValue];
				
				if (previousHiScore < totalPoints) 
				{
					previousHiScore = totalPoints;
					[sharedSettingManager forProfileSet:ProfileKey_Sky_HiScore to:[[NSNumber numberWithFloat:previousHiScore]stringValue]];
				}
				
				[labelScore setText:[NSString stringWithFormat:@"Score: %1.0f", totalPoints] atSceenPercentage:CGPointMake(50, 40)];
				[labelHiScore setText:[NSString stringWithFormat:@"HiScore: %1.0f", previousHiScore] atSceenPercentage:CGPointMake(50, 35)];
				[labelHeight setText:[NSString stringWithFormat:@"Height: %1.0f", totalDistance / 100] atSceenPercentage:CGPointMake(50, 30)];
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
		default:
		{
			//NSLog(@"ERROR: SideScroller has no valid state.");
			break;
		}
	}
}
#define ISLAND_NORM 0
#define ISLAND_WHALE 1
#define ISLAND_SHIP 2
#define ISLAND_BOMB 3
- (void) generateNextIsland
{
	int islandType = ISLAND_NORM;
	
	islandSpecialCounter--;
	if(islandSpecialCounter == 0)
	{
		islandSpecialCounter = 3 + RANDOM(5);
		islandType = 1 + RANDOM(3);
		//	NSLog(@"Creating Type: %D", islandType);
		// This will be a special island.
		// It will be a sinking boat(2), a whale(1) or an island with lava geyser(3).
	}
	
	// Move the island at index 0 to last index
	id obj = [groundObjects objectAtIndex:0];
	[obj retain];
	[groundObjects removeObjectAtIndex:0];
	[groundObjects addObject:obj];
	[obj release];
	
	// Find the Gap;
	int gapMin;
	if([player isFlying])
		gapMin = 100;
	else
		gapMin = [player velocity].x * 0.5;
	
	// Min Gap is based off of 125velocity
	if(gapMin < 63)
		gapMin = 63;
	int gap = gapMin + RANDOM(gapMin * 2);
	
	int length;
	if(islandType == ISLAND_WHALE)
	{
		// About 1.5Times the min length at 200speed.
		length = 880;
	}
	else
	{
		// Find the Length; Screen Width * 1.5
		int lengthMin;
		if([player isFlying])
			lengthMin = 592;
		else
			lengthMin = floorf([player velocity].x * 0.1875) * 16;
		
		// Min Length is based off of 1 distance unit, and made 16 compatible
		// DO NOT CHANGE, THE BEGINNING CLIFF IS 160PIXELS AND THE ENDING CLIFF IS 160PIXELS
		// THE MINIMUM PIXELS NEEDED TO DRAW AN ISLAND IS 320PIXELS
		if(lengthMin < 320)
			lengthMin = 320;
		
		if(islandType == ISLAND_BOMB)
		{
			// 2 Times the min length; longest possible length;
			// Maybe extend to 3 Times the length to allow for reaction still.
			length = lengthMin * 2;
			
			// Due to graphic restraints island with bomb can be no less than 368
			if(length < 368)
				length = 368;
		}
		else 
		{
			length = lengthMin + RANDOM(lengthMin);
			length = floor(length / 16) * 16;
		}
	}
	
	int height;
	CGPoint previousPosition = [[groundObjects objectAtIndex:0] position];
	CGSize previousSize = [[groundObjects objectAtIndex:0] size];
	
	if(islandType == ISLAND_SHIP)
	{
		height = 128;
	}
	else if(islandType == ISLAND_WHALE)
	{
		height = 48;
	}
	else 
	{
		// Find the HeightChange;
		int heightChange = RANDOM(240) - 160;
		height = previousSize.height + heightChange;
	}
	
	if(height < 16)
		height = 16;
	if(height > 144)
		height = 144;
	
	
	// X position is equal to the (last object - 1) + object length + gap
	float xPosition = previousPosition.x + previousSize.width + gap;
	//NSLog(@"New Ground Object: Pos(%f, %D), Size(%D, %D)", xPosition, height, length, height);
	[[groundObjects lastObject] resetWithType:islandType position:CGPointMake(xPosition, height) 
										 size:CGSizeMake(length, height)];
}

- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView
{
	[super updateWithTouchLocationBegan:touches withEvent:event view:aView];
	
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
			[pauseButton touchBeganAtPoint:[[Director sharedDirector] eventArgs].startPoint];
			if(![pauseButton touched])
				[player jump];
			break;
		}
		case SceneState_Paused:
		{
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
			[player jump];
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
			[pauseButton touchMovedAtPoint:[[Director sharedDirector] eventArgs].movedPoint];
			break;
		}
		case SceneState_Paused:
		{
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
			[pauseButton touchEndedAtPoint:[[Director sharedDirector] eventArgs].endPoint];
			break;
		}
		case SceneState_Paused:
		{
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
			
		}
	}
}


// Render
- (void) render
{
	glPushMatrix();
	switch (sceneState) 
	{
			// The Scene is in the forefront and running.
		case SceneState_Running:
		{
			// Renders the ground objects
			for (SideScrollerGroundObject* groundObj in groundObjects) 
			{ [groundObj render]; }
			
			// Update the pet, if Alive;
			if([player isAlive])
				[player render];
			
			[font drawStringAt:CGPointPortraitToLandscape(CGPointMake(380, 300)) text:[NSString stringWithFormat:@"%1.0f", totalPoints]];

			[pauseButton render];
			
			break;
		}
			// The scene is phasing out.
		case SceneState_TransitionOut:
		{
			// Renders the ground objects
			for (SideScrollerGroundObject* groundObj in groundObjects) 
			{ [groundObj render]; }
			
			// Update the pet, if Alive;
			if([player isAlive])
				[player render];
			
			[font drawStringAt:CGPointPortraitToLandscape(CGPointMake(380, 300)) text:[NSString stringWithFormat:@"%1.0f", totalPoints]];

			break;
		}
			// The scene is phasing in.
		case SceneState_TransitionIn:
		{
			// Renders the ground objects
			for (SideScrollerGroundObject* groundObj in groundObjects) 
			{ [groundObj render]; }
			
			// Update the pet, if Alive;
			if([player isAlive])
				[player render];
			
			[font drawStringAt:CGPointPortraitToLandscape(CGPointMake(380, 300)) text:[NSString stringWithFormat:@"%1.0f", totalPoints]];
			
			break;
		}
			// The Scene is currently paused.
		case SceneState_Paused:
		{
			// Renders the ground objects
			for (SideScrollerGroundObject* groundObj in groundObjects) 
			{ [groundObj render]; }
			
			// Update the pet, if Alive;
			if([player isAlive])
				[player render];
			
			[font drawStringAt:CGPointPortraitToLandscape(CGPointMake(380, 300)) text:[NSString stringWithFormat:@"%1.0f", totalPoints]];
			
			[buttonArcade render];
			[buttonRestart render];
			
			break;
		}
		case SceneState_GameOver:
		{
			[font setRotation:0];
			[imageOverlayMask render];
			//[emitter renderParticles];
			[imageBackground render];
			[imageCoin render];
			[font drawStringAt:CGPointMake(160, 354) text:[NSString	stringWithFormat:@"%1.0f", totalPoints / 10]];
			[imageBonus render];
			if (bonusAmount > 0)
				[font drawStringAt:CGPointMake(160, 274) text:[NSString	stringWithFormat:@"%1.0f", bonusAmount]];
			[labelGameover render];
			[labelEarned render];
			[labelBonus render];
			[labelScore render];
			[labelHiScore render];
			[labelHeight render];
			
			[currencyIndicator render];
			[boostIndicator render];
			
			[buttonRestart render];
			[buttonArcade render];
			[font setRotation:90];
			/*
			
			for (SideScrollerGroundObject* groundObj in groundObjects) 
			{ [groundObj render]; }
			
			[font drawStringAt:CGPointPortraitToLandscape(CGPointMake(240, 176)) text:[NSString stringWithFormat:@"High Score: %1.0f", highscorePoints]];
			[font drawStringAt:CGPointPortraitToLandscape(CGPointMake(240, 140)) text:[NSString stringWithFormat:@"Score: %1.0f", totalPoints]];
			[font drawStringAt:CGPointPortraitToLandscape(CGPointMake(240, 104)) text:[NSString stringWithFormat:@"Distance: %1.0f", totalDistance]];
			
			[buttonRestart render];
			[buttonArcade render];
			 */
			break;
		}
		default:
		{
			//NSLog(@"ERROR: SideScroller has no valid state.");
			break;
		}
	}
	glPopMatrix();
	[font drawStringAt:CGPointPortraitToLandscape(CGPointMake(240, 300)) text:[NSString stringWithFormat:@"%1.0f", [[Director sharedDirector] framesPerSecond]]];
}

@end

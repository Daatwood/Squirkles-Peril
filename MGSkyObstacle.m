//
//  MGSkyObstacle.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 2/15/11.
//  Copyright 2011 Dustin Atwood. All rights reserved.
//

#import "MGSkyObstacle.h"


@implementation MGSkyObstacle

@synthesize positionObstacle, readyForDeletion;

// Initialize the Obstacle
- (id) initWithTheme:(int)theme withOwner:(MGSkyPlatform*)platformOwner
{
	if(self = [super init])
	{
		owner = [platformOwner retain];
		
		imagesObstacle = [[NSMutableArray alloc] initWithCapacity:1];
		
		themeObstacle = theme;
		switch (themeObstacle) 
		{
			case PlatformTheme_Smoke:
			{
				colorObstacle = Color4fMake(0.5f, 0.5f, 0.5f, 1.0f);
				
				Image *imageObstacle = [[Image alloc] initWithImageNamed:@"CloudCivilianLeft"];
				[imageObstacle setColourFilterRed:0.5f green:0.5f blue:0.5f alpha:1.0f];
				[imagesObstacle addObject:imageObstacle];
				[imageObstacle release];
				
				imageObstacle = [[Image alloc] initWithImageNamed:@"CloudCivilianRight"];
				[imageObstacle setColourFilterRed:0.5f green:0.5f blue:0.5f alpha:1.0f];
				[imagesObstacle addObject:imageObstacle];
				[imageObstacle release];
				break;
			}
			case PlatformTheme_Cloud:
			{
				colorObstacle = Color4fMake(1.0f, 1.0f, 1.0f, 1.0f);
				
				Image *imageObstacle = [[Image alloc] initWithImageNamed:@"CloudCivilianLeft"];
				[imagesObstacle addObject:imageObstacle];
				[imageObstacle release];
				
				imageObstacle = [[Image alloc] initWithImageNamed:@"CloudCivilianRight"];
				[imagesObstacle addObject:imageObstacle];
				[imageObstacle release];
				break;
			}
			case PlatformTheme_Space:
			{
				colorObstacle = Color4fMake(0.66f, 0.49f, 0.31f, 1.0f);
				
				Image *imageObstacle = [[Image alloc] initWithImageNamed:@"RockPersonLeft"];
				[imagesObstacle addObject:imageObstacle];
				[imageObstacle release];
				
				imageObstacle = [[Image alloc] initWithImageNamed:@"RockPersonRight"];
				[imagesObstacle addObject:imageObstacle];
				[imageObstacle release];
				break;
			}
			default:
			{
				NSLog(@"MGSkyObstacle: Unknown Theme Given");
				break;
			}
		}
		readyForDeletion = FALSE;
		isAlive = TRUE;
		isHarmful = FALSE;
		isMoving = FALSE;
		bounceUp = TRUE;
		
		positionObstacle = CGPointMake(0, 24);
		movementDirection = RANDOM(2);
		timeBeforeActionChange = 0.5 + RANDOM_0_TO_1();
		bounceOffset = 0;
	}
	return self;
}

- (void)dealloc 
{
	[owner release];
	owner = nil;
	
	[imagesObstacle release];
	imagesObstacle = nil;
	
	[emitter release];
	emitter = nil;
	
	[super dealloc];
}

// Flips Direction
- (void) flipDirection
{
	if(readyForDeletion)
		return;
	
	if(movementDirection == 0)
		movementDirection = 1;
	else if(movementDirection == 1)
		movementDirection = 0;
}

// Turn to Harmful
- (void) turnHarmful
{
	
	if(readyForDeletion)
		return;
	
	if(!isAlive)
		return;
	
	if(owner)
	{
		positionObstacle = CGPointMake(positionObstacle.x + [owner positionPlatform].x, 
									   positionObstacle.y + [owner positionPlatform].y);
	}
	
	direction = CGPointZero;
	
	// Begin the Emitter;
	emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"CloudParticle"
																position:Vector2fMake(positionObstacle.x, 
																					  positionObstacle.y)
												  sourcePositionVariance:Vector2fZero
																   speed:25.0f
														   speedVariance:0.0f
														particleLifeSpan:0.5f	
												particleLifespanVariance:0.0f
																   angle:0.0f
														   angleVariance:360.0f
																 gravity:Vector2fZero
															  startColor:colorObstacle
													  startColorVariance:Color4fZero
															 finishColor:Color4fZero  
													 finishColorVariance:Color4fZero
															maxParticles:20
															particleSize:20
													particleSizeVariance:10
																duration:0.5f
														   blendAdditive:NO];
	
	// Play Sound Transformation
	// NYI
	// Change Images To Harmful
	[imagesObstacle removeAllObjects];
	switch (themeObstacle) 
	{
		case PlatformTheme_Smoke:
		{
			colorObstacle = Color4fMake(1.0f, 0.5f, 0.5f, 1.0f);
			
			Image *imageObstacle = [[Image alloc] initWithImageNamed:@"CloudCivilianLeft"];
			[imageObstacle setColourFilterRed:1.0f green:0.3f blue:0.3f alpha:1.0f];
			[imagesObstacle addObject:imageObstacle];
			[imageObstacle release];
			
			imageObstacle = [[Image alloc] initWithImageNamed:@"CloudCivilianRight"];
			[imageObstacle setColourFilterRed:1.0f green:0.3f blue:0.3f alpha:1.0f];
			[imagesObstacle addObject:imageObstacle];
			[imageObstacle release];
			break;
		}
		case PlatformTheme_Cloud:
		{
			colorObstacle = Color4fMake(1.0f, 0.3f, 0.3f, 1.0f);
			
			Image *imageObstacle = [[Image alloc] initWithImageNamed:@"CloudCivilianLeft"];
			[imageObstacle setColourFilterRed:1.0f green:0.3f blue:0.3f alpha:1.0f];
			[imagesObstacle addObject:imageObstacle];
			[imageObstacle release];
			
			imageObstacle = [[Image alloc] initWithImageNamed:@"CloudCivilianRight"];
			[imageObstacle setColourFilterRed:1.0f green:0.3f blue:0.3f alpha:1.0f];
			[imagesObstacle addObject:imageObstacle];
			[imageObstacle release];
			break;
		}
		case PlatformTheme_Space:
		{
			colorObstacle = Color4fMake(0.66f, 0.29f, 0.11f, 1.0f);
			
			Image *imageObstacle = [[Image alloc] initWithImageNamed:@"RockPersonLeft"];
			[imageObstacle setColourFilterRed:0.66f green:0.29f blue:0.11f alpha:1.0f];
			[imagesObstacle addObject:imageObstacle];
			[imageObstacle release];
			
			imageObstacle = [[Image alloc] initWithImageNamed:@"RockPersonRight"];
			[imageObstacle setColourFilterRed:0.66f green:0.29f blue:0.11f alpha:1.0f];
			[imagesObstacle addObject:imageObstacle];
			[imageObstacle release];
			break;
		}
		default:
		{
			NSLog(@"MGSkyObstacle: Unknown Theme Given");
			break;
		}
	}
	
	
	
	// Adjust Variables
	isHarmful = TRUE;
	bounceOffset = 0;
	timeBeforeActionChange = 1 + RANDOM_0_TO_1();
}

// Kills the Obstacle
- (void) die
{
	if(readyForDeletion)
		return;
	
	if(!isAlive)
		return;
	
	CGPoint positionCombined = positionObstacle;
	
	if(owner)
	{
		positionCombined = CGPointMake(positionObstacle.x + [owner positionPlatform].x, 
									   positionObstacle.y + [owner positionPlatform].y);
	}
	// Begin the Emitter;
	emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"CloudParticle"
																position:Vector2fMake(positionCombined.x, 
																					  positionCombined.y)
												  sourcePositionVariance:Vector2fZero
																   speed:50.0f
														   speedVariance:0.0f
														particleLifeSpan:0.50f	
												particleLifespanVariance:0.0f
																   angle:270.0f
														   angleVariance:90.0f
																 gravity:Vector2fZero
															  startColor:colorObstacle
													  startColorVariance:Color4fZero
															 finishColor:Color4fZero  
													 finishColorVariance:Color4fZero
															maxParticles:4
															particleSize:20
													particleSizeVariance:1
																duration:0.50f
														   blendAdditive:NO];
	
	// Play Death Sound
	// NYI
	// Adjust Variables
	isAlive = FALSE;
}

// Update's the Obstacle
- (void) updateWithDelta:(GLfloat)delta givenPlayer:(MGSkyPlayer*)player;
{
	if(readyForDeletion)
		return;
	
	// Update Emitter
	[emitter update:delta];
	
	if(![emitter active] && !isAlive)
		readyForDeletion = TRUE;
	
	// Update if isAlive
	if(!isAlive)
		return;
	
	if(owner)
	{
		// Owner has died
		if(![owner isUsable])
		{
			// Make sure the platform is within reasonable viewing distance 
			// and was not accidentally made on a fake platform
			if([owner positionPlatform].y > -100 && [owner typePlatform] != PlatformType_Fake)
				// The Obstacle will become angered!
				[self turnHarmful];
			else
				readyForDeletion = YES;
			
			[owner release];
			owner = nil;
		}
		else
		{
			// Update Idle Movements
			timeBeforeActionChange -= delta;
			
			if(timeBeforeActionChange <= 0)
			{
				// Random Facing Direction; 0Left, 1Right
				movementDirection = RANDOM(2);
				
				// Moving or Not Moving
				if (RANDOM(2)) 
					isMoving = TRUE;
				else
					isMoving = FALSE;
				
				// Timer for next Action
				timeBeforeActionChange = 0.5 + RANDOM_0_TO_1();
			}
			
			if(isMoving)
			{
				if(movementDirection == 0)
					positionObstacle.x -= delta * 13;
				else if(movementDirection == 1)
					positionObstacle.x += delta * 13;
			}
			
			if(positionObstacle.x > [owner sizePlatform].width)
			{
				[self flipDirection];
				positionObstacle.x = [owner sizePlatform].width;
			}
			if (positionObstacle.x < 0) 
			{
				[self flipDirection];
				positionObstacle.x = 0;
			}
			
			// Update Animation
			if(bounceUp)
				bounceOffset += delta * 12;
			else
				bounceOffset -= delta * 12;
			
			if (bounceOffset > 2.5) 
				bounceUp = FALSE;
			else if (bounceOffset < -2.5) 
				bounceUp = TRUE;
		}
	}
	else
	{
		// Does not have a owner
		
		timeBeforeActionChange -= delta;
		
		if(timeBeforeActionChange <= 0)
		{
			// Update Chasing Variable
			timeBeforeActionChange = 1 + RANDOM_0_TO_1();
			
			CGPoint playerPosition;
			if(isHarmful)
				playerPosition = CGPointMake(player.positionPlayer.x, player.positionPlayer.y + 100);
			else
			{
				int width = [[Director sharedDirector] screenBounds].size.width / 3;
				int height = [[Director sharedDirector] screenBounds].size.height / 3;
				
				playerPosition = CGPointMake(width + RANDOM(width), height + RANDOM(height));
			}
			direction = CGPointNormalize(CGPointSub(playerPosition, positionObstacle));
			if(direction.x > 0)
				movementDirection = 1;
			else
				movementDirection = 0;
		}
		
		positionObstacle = CGPointAdd(positionObstacle, CGPointMultiply(direction, delta * 85));
	}
	
	// Perform a collision check
	[self hasCollidedWithPlayer:player withDelta:delta];
}

// Applys accelerometer to the player.
- (void) applyAccelerometer:(GLfloat)data
{
	if(readyForDeletion)
		return;
	
	if(!isAlive)
		return;
	
	if(owner)
		return;
	
	positionObstacle.x -= data;
}

// Applies velocity to the platform
- (void) applyVelocity:(float)velocity
{
	if(readyForDeletion)
		return;
	
	if(!isAlive)
		return;
	
	if(owner)
		return;
	
	positionObstacle.y -= velocity;
	if(positionObstacle.y < -230)
	{
		[self die];
	}
}

#define obstacleSizeWidth 22
#define playerSizeWidth 10

// Collision Check Method
- (int) hasCollidedWithPlayer:(MGSkyPlayer*)player withDelta:(GLfloat)delta
{
	CGPoint positionCombined = positionObstacle;
	
	if(owner)
	{
		positionCombined = CGPointMake(positionObstacle.x + [owner positionPlatform].x, 
										   positionObstacle.y + [owner positionPlatform].y);
	}
	
	CGPoint playerPosition = [player positionPlayer];
	CGPoint velocity = [player velocityPlayer];
	CGSize playerSize = [player sizePlayer];
	velocity.x *= delta;
	velocity.y *= delta;
	
	// Check to see if the player is above or under the platform
	// Adding a total of 26 to the platform to accomodate the player width
	if(playerPosition.x + playerSize.width > positionCombined.x && 
	   playerPosition.x - playerSize.width < positionCombined.x + obstacleSizeWidth)
	{
		// The player has entered the area of the this ground;
		// Checking to see if player is above ground; 
		if(playerPosition.y + playerSize.height >= positionCombined.y)
		{
			// Checking to see if player will hit obstacle when velocity is applied;
			if(playerPosition.y - playerSize.height + velocity.y < positionCombined.y - velocity.y)
			{
				// The player is above the obstacle and will hit next update
				
				if(isHarmful && ![player inShip] && [player isAlive])
				{
					[player die];
					//NSLog(@"Player Died by Angry Obstacle!");
				}
				else
					[self die];
				
				return 2;
			}
			else 
			{
				// The player is above the ground and wont hit next update
				
				// Do Nothing...
				
				return 0;
			}
		}
		else 
		{
			// Checking to see if player will hit under the obstacle when velocity is applied;
			if(playerPosition.y + playerSize.height + velocity.y > positionCombined.y - velocity.y)
			{
				// The player is under the obstacle and will hit next update
				
				if(isHarmful && ![player inShip] && [player isAlive])
				{
					[player die];
					//NSLog(@"Player Died by Angry Obstacle!");
				}
				else
					[self die];
			
				return 2;
			}
			else 
			{
				// The player is under the obstacle and wont hit next update
				
				// Do Nothing...
				
				return 0;
			}
		}
	}
	else 
	{
		// The player is not in the area where the object is
		// Do Nothing..
		return FALSE;
	}
}

// Renders the Obstacle
- (void) render
{
	if(readyForDeletion)
		return;
	
	// Render if isAlive
	if(isAlive)
	{
		if(owner)
		{
			CGPoint positionCombined = CGPointMake(positionObstacle.x + [owner positionPlatform].x, 
												   positionObstacle.y + [owner positionPlatform].y + bounceOffset);
			// Render Images
			[[imagesObstacle objectAtIndex:movementDirection] renderAtPoint:positionCombined centerOfImage:YES];
		}
		else
		{
			[[imagesObstacle objectAtIndex:movementDirection] renderAtPoint:positionObstacle centerOfImage:YES];
		}
	}
	
	// Render Emitter
	[emitter renderParticles];
}

@end

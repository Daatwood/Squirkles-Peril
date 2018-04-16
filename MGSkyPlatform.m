//
//  MGSkyPlatform.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 2/15/11.
//  Copyright 2011 Dustin Atwood. All rights reserved.
//

#import "MGSkyPlatform.h"


@implementation MGSkyPlatform
@synthesize readyForDeletion;
@synthesize isUsable;
@synthesize earnedPoints;
@synthesize positionPlatform;
@synthesize sizePlatform;
@synthesize typePlatform;

// Initialize the Platform
- (id) initWithTheme:(int)theme andType:(int)type atPosition:(CGPoint)pos
{
	if(self = [super init])
	{
		themePlatform = theme;
		typePlatform = type;
		positionPlatform = pos;
		//NSLog(@"Position! %F, %F", pos.x, pos.y);
		
		readyForDeletion = FALSE;
		isUsable = TRUE;
		earnedPoints = FALSE;
		imageIndex = 1;
		supportedJumps = 3;
		movementDirection = RANDOM(2);
		animationBounce = 0;
		animationTimer = 0;
		colorPlatform = Color4fInit;
		
		imagesPlatform = [[NSMutableArray alloc] initWithCapacity:1];
		Image* imagePlatform;
		imagePlatform = [[Image alloc] initWithImageNamed:@"Nothing"];
		[imagesPlatform addObject:imagePlatform];
		switch (typePlatform) 
		{
				
			case PlatformType_Normal:
			{
				awardPoints = 5;
				if (themePlatform == PlatformTheme_Smoke) 
				{
					[imagePlatform release];
					imagePlatform = [[Image alloc] initWithImageNamed:@"Cloud3"];
					[imagePlatform setColourFilterRed:0.5 green:0.5 blue:0.5 alpha:1.0];
					[imagesPlatform addObject:imagePlatform];
				}
				else if (themePlatform == PlatformTheme_Cloud) 
				{
					[imagePlatform release];
					imagePlatform = [[Image alloc] initWithImageNamed:@"Cloud3"];
					[imagesPlatform addObject:imagePlatform];
				}
				else if (themePlatform == PlatformTheme_Space) 
				{
					[imagePlatform release];
					imagePlatform = [[Image alloc] initWithImageNamed:@"Rock"];
					[imagesPlatform addObject:imagePlatform];
				}
				break;
			}
			case PlatformType_Fake:
			{
				isUsable = FALSE;
				awardPoints = 0;
				supportedJumps = 1;
				if (themePlatform == PlatformTheme_Smoke) 
				{
					[imagePlatform release];
					imagePlatform = [[Image alloc] initWithImageNamed:@"CloudFake3"];
					[imagePlatform setColourFilterRed:0.5 green:0.5 blue:0.5 alpha:1.0];
					[imagesPlatform addObject:imagePlatform];
				}
				else if (themePlatform == PlatformTheme_Cloud) 
				{
					[imagePlatform release];
					imagePlatform = [[Image alloc] initWithImageNamed:@"CloudFake3"];
					[imagesPlatform addObject:imagePlatform];
				}
				else if (themePlatform == PlatformTheme_Space) 
				{
					[imagePlatform release];
					imagePlatform = [[Image alloc] initWithImageNamed:@"RockFake"];
					[imagesPlatform addObject:imagePlatform];
				}
				break;
			}
			case PlatformType_Dissolve:
			{
				awardPoints = 7;
				supportedJumps = 1;
				if (themePlatform == PlatformTheme_Smoke) 
				{
					[imagePlatform release];
					imagePlatform = [[Image alloc] initWithImageNamed:@"Cloud3"];
					[imagePlatform setColourFilterRed:0.5 green:0.5 blue:0.5 alpha:1.0];
					[imagesPlatform addObject:imagePlatform];
				}
				else if (themePlatform == PlatformTheme_Cloud) 
				{
					[imagePlatform release];
					imagePlatform = [[Image alloc] initWithImageNamed:@"Cloud3"];
					[imagesPlatform addObject:imagePlatform];
				}
				else if (themePlatform == PlatformTheme_Space) 
				{
					[imagePlatform release];
					imagePlatform = [[Image alloc] initWithImageNamed:@"Rock"];
					[imagesPlatform addObject:imagePlatform];
				}
				break;
			}
			case PlatformType_HMoving:
			{
				awardPoints = 10;
				if (themePlatform == PlatformTheme_Smoke) 
				{
					[imagePlatform release];
					imagePlatform = [[Image alloc] initWithImageNamed:@"Cloud3"];
					[imagePlatform setColourFilterRed:0.5 green:0.5 blue:0.5 alpha:1.0];
					[imagesPlatform addObject:imagePlatform];
				}
				else if (themePlatform == PlatformTheme_Cloud) 
				{
					[imagePlatform release];
					imagePlatform = [[Image alloc] initWithImageNamed:@"Cloud3"];
					[imagesPlatform addObject:imagePlatform];
				}
				else if (themePlatform == PlatformTheme_Space) 
				{
					[imagePlatform release];
					imagePlatform = [[Image alloc] initWithImageNamed:@"Rock"];
					[imagesPlatform addObject:imagePlatform];
				}
				break;
			}
			case PlatformType_Bouncy:
			{
				awardPoints = 7;
				if (themePlatform == PlatformTheme_Smoke) 
				{
					[imagePlatform release];
					imagePlatform = [[Image alloc] initWithImageNamed:@"imagePlatformBouce1"];
					[imagePlatform setColourFilterRed:0.5 green:0.5 blue:0.5 alpha:1.0];
					[imagesPlatform addObject:imagePlatform];
					
					[imagePlatform release];
					imagePlatform = [[Image alloc] initWithImageNamed:@"imagePlatformBouce0"];
					[imagePlatform setColourFilterRed:0.5 green:0.5 blue:0.5 alpha:1.0];
					[imagesPlatform addObject:imagePlatform];
				}
				else if (themePlatform == PlatformTheme_Cloud) 
				{
					[imagePlatform release];
					imagePlatform = [[Image alloc] initWithImageNamed:@"imagePlatformBouce1"];
					[imagesPlatform addObject:imagePlatform];
					
					[imagePlatform release];
					imagePlatform = [[Image alloc] initWithImageNamed:@"imagePlatformBouce0"];
					[imagePlatform setColourFilterRed:0.5 green:0.5 blue:0.5 alpha:1.0];
					[imagesPlatform addObject:imagePlatform];
				}
				else if (themePlatform == PlatformTheme_Space) 
				{
					[imagePlatform release];
					imagePlatform = [[Image alloc] initWithImageNamed:@"imagePlatformBouce1"];
					[imagesPlatform addObject:imagePlatform];
					
					[imagePlatform release];
					imagePlatform = [[Image alloc] initWithImageNamed:@"imagePlatformBouce0"];
					[imagePlatform setColourFilterRed:0.5 green:0.5 blue:0.5 alpha:1.0];
					[imagesPlatform addObject:imagePlatform];
				}
				break;
			}
			case PlatformType_Net:
			{
				awardPoints = 1;
				if (themePlatform == PlatformTheme_Smoke) 
				{
					[imagePlatform release];
					imagePlatform = [[Image alloc] initWithImageNamed:@"CloudNetPlatform"];
					[imagePlatform setColourFilterRed:0.5 green:0.5 blue:0.5 alpha:1.0];
					[imagesPlatform addObject:imagePlatform];
				}
				else if (themePlatform == PlatformTheme_Cloud) 
				{
					[imagePlatform release];
					imagePlatform = [[Image alloc] initWithImageNamed:@"CloudNetPlatform"];
					[imagesPlatform addObject:imagePlatform];
				}
				else if (themePlatform == PlatformTheme_Space) 
				{
					[imagePlatform release];
					imagePlatform = [[Image alloc] initWithImageNamed:@"imageSpacePlatformNet"];
					[imagesPlatform addObject:imagePlatform];
				}
				break;
			}
			case PlatformType_Star:
			{
				awardPoints = 20;
				[imagePlatform release];
				imagePlatform = [[Image alloc] initWithImageNamed:@"StarPlatform"];
				[imagesPlatform addObject:imagePlatform];
				break;
			}
			case PlatformType_Ship:
			{
				awardPoints = 0;
				[imagePlatform release];
				imagePlatform = [[Image alloc] initWithImageNamed:@"imageSpacePlatformShip"];
				[imagesPlatform addObject:imagePlatform];
				break;
			}
			case PlatformType_Explosive:
			{
				awardPoints = 7;
				[imagePlatform release];
				imagePlatform = [[Image alloc] initWithImageNamed:@"BombPlatform"];
				[imagesPlatform addObject:imagePlatform];
				break;
			}
			default:
				break;
		}
		
		if(typePlatform == PlatformType_Net)
			sizePlatform = CGSizeMake([[imagesPlatform objectAtIndex:imageIndex] imageWidth], 
								 [[imagesPlatform objectAtIndex:imageIndex] imageHeight] / 2);
		else
			sizePlatform = CGSizeMake([[imagesPlatform objectAtIndex:imageIndex] imageWidth], 
									  [[imagesPlatform objectAtIndex:imageIndex] imageHeight]);
	}
	return self;
}

- (void)dealloc 
{
	//NSLog(@"MGSkyPlatform Dealloc");
	[imagesPlatform release];
	imagesPlatform = nil;
	
	[emitter release];
	emitter = nil;
	
	[super dealloc];
}

// Kills the Platform
- (void) die
{
	// Begin Emitter
	emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"CloudParticle"
																position:Vector2fMake(positionPlatform.x + sizePlatform.width / 2, 
																					  positionPlatform.y + sizePlatform.height / 2)
												  sourcePositionVariance:Vector2fMake(sizePlatform.width / 2, sizePlatform.height / 2)
																   speed:50.0f
														   speedVariance:0.0f
														particleLifeSpan:0.50f	
												particleLifespanVariance:0.0f
																   angle:0.0f
														   angleVariance:360.0f
																 gravity:Vector2fMake(0.0f, -20.0f)
															  startColor:colorPlatform
													  startColorVariance:Color4fZero
															 finishColor:Color4fZero 
													 finishColorVariance:Color4fZero
															maxParticles:6
															particleSize:25
													particleSizeVariance:1
																duration:0.50f
														   blendAdditive:NO];
	// Play Death Sound
	// Adjust Variables
	isUsable = FALSE;
	imageIndex = 0;
}

// Update's the Platform
- (void) updateWithDelta:(GLfloat)delta givenPlayer:(MGSkyPlayer*)player
{
	if(readyForDeletion)
		return;
	
	// Update Emitter
	[emitter update:delta];
	
	if(![emitter active] && !isUsable && typePlatform != PlatformType_Fake)
		readyForDeletion = TRUE;
	
	// Update if isUsable
	if(!isUsable)
		return;
	
	// Update Animation
	switch (typePlatform) 
	{
		case PlatformType_HMoving:
		{
			if(movementDirection == 0)
			{
				positionPlatform.x += (1 + RANDOM_0_TO_1()) * (1 + delta);
				if(positionPlatform.x + sizePlatform.width > 640)
					movementDirection = 1;
			}
			else 
			{
				positionPlatform.x -= (1 + RANDOM_0_TO_1()) * (1 + delta);
				if(positionPlatform.x < -320)
					movementDirection = 0;
			}
			break;
		}
		case PlatformType_Bouncy:
		{
			if (animationTimer > 0) 
			{
				animationTimer -= delta;
			}
			else 
			{
				animationTimer = 0.2;
				animationBounce += 1;
				if(animationBounce > 1)
					animationBounce = 0;
			}
			
			if(animationBounce == 0)
				positionPlatform.y += (1 + RANDOM_0_TO_1()) * delta * 5;
			else
				positionPlatform.y -= (1 + RANDOM_0_TO_1()) * delta * 5;
			
			break;
		}
		default:
			break;
	}
	
	// Bound Check
	if(positionPlatform.x < -320)
		positionPlatform.x = positionPlatform.x + 320 + 640;
	else if(positionPlatform.x > 640)
		positionPlatform.x = positionPlatform.x - 640 - 320;
	
	// Collision Check
	[self hasCollidedWithPlayer:player withDelta:delta];
}


// Applys accelerometer to the Platform.
- (void) applyAccelerometer:(GLfloat)data
{
	if(readyForDeletion)
		return;
	
	positionPlatform.x -= data;
}

// Applies velocity to the Platform
- (void) applyVelocity:(float)velocity
{
	if(readyForDeletion)
		return;
	
	positionPlatform.y -= velocity;
	if(positionPlatform.y < -240)
	{
		//NSLog(@"Platform Too Far - Removed");
		[self die];
		[emitter stopParticleEmitter];
		if(typePlatform == PlatformType_Fake)
			readyForDeletion = TRUE;
	}
}

// Returns the reward points
- (int) rewardPoints
{
	if(readyForDeletion)
		return 0;
	
	if(!earnedPoints)
		return 0;
	
	int points = awardPoints;
	awardPoints = 0;
	earnedPoints = FALSE;
	return points;
}

#define playerSizeWidth 10

// Collision Check Method
- (void) hasCollidedWithPlayer:(MGSkyPlayer*)player withDelta:(GLfloat)delta
{
	CGPoint playerPosition = [player positionPlayer];
	CGPoint velocity = [player velocityPlayer];
	CGSize playerSize = [player sizePlayer];
	playerSize.height /= 2;
	velocity.x *= delta;
	velocity.y *= delta;
	
	// Check to see if the player is above or under the platform
	// Adding a total of 26 to the platform to accomodate the player width
	if(playerPosition.x + playerSize.width > positionPlatform.x && 
	   playerPosition.x - playerSize.width < positionPlatform.x + sizePlatform.width )
	{
		// The player has entered the area of the this ground;
		// Checking to see if player is above ground; 
		if(playerPosition.y + playerSize.height >= positionPlatform.y)
		{
			// Checking to see if player will hit ground when velocity is applied;
			if(playerPosition.y - playerSize.height + velocity.y < positionPlatform.y - velocity.y)
			{
				// The player is above the ground and will hit next update
				
				if(velocity.y > 0)
					earnedPoints = NO; 
				
				switch (typePlatform) 
				{
					case PlatformType_Ship:
					{
						if([player applyShip])
							supportedJumps--;
						break;
					}
					case PlatformType_Bouncy:
					{
						if([player applySuperJump])
							supportedJumps--;
						break;
					}
					case PlatformType_Star:
					{
						if([player applyBoost])
							supportedJumps--;
						break;
					}
					case PlatformType_Fake:
					{
						// Don't Do Anything
						break;
					}
					default:
					{
						// If type not found just normal jump
						if([player applyJump])
							supportedJumps--;
						break;
					}
				}
				
				if(supportedJumps <= 0)
					[self die];
				
				earnedPoints = TRUE;
			}
			else 
			{
				// The player is above the ground and wont hit next update
				
				// Do Nothing...
				
				earnedPoints = NO;
			}
		}
		else 
		{
			// Checking to see if player will hit under the ground when velocity is applied;
			if(playerPosition.y + playerSize.height + velocity.y > positionPlatform.y - velocity.y)
			{
				// The player is under the ground and will hit next update
				
				if([player inShip])
					[self die];

				earnedPoints = YES;
			}
			else 
			{
				// The player is under the ground and wont hit next update
				
				// Do Nothing...
				
				earnedPoints = NO;
			}
		}
	}
	else 
	{
		// The player is not in the area where the object is
		// Do Nothing..
		earnedPoints =  NO;
	}
}

// Renders the Platform
- (void) render
{
	if(readyForDeletion)
		return;
	
	// Render the correct image
	if(positionPlatform.x > -sizePlatform.width && positionPlatform.x < [[Director sharedDirector] screenBounds].size.width)
	{
		[[imagesPlatform objectAtIndex:imageIndex] renderAtPoint:positionPlatform centerOfImage:NO];
		
		[emitter renderParticles];
	}
	// Render Emitter
}

@end

//
//  JumpScrollerPlatform.m
//  BadBadMonkey
//
//  Created by Dustin Atwood on 11/21/10.
//  Copyright 2010 Litlapps. All rights reserved.
//

#import "JumpScrollerPlatform.h"

@implementation JumpScrollerPlatform

@synthesize position, size, platformType, movementDirection, isUsable, isAlive, platformTheme;

// Initialize the platform
- (id) init
{
	if(self = [super init])
	{
		position = CGPointZero;
		size = CGSizeZero;
		platformType = -1;
		platformTheme = -1;
		isUsable = FALSE;
		movementDirection = -1;
		movementOffset = 0;
		coutdownTimer = 0;
		isAlive = FALSE;
		platformImageSecondary = [[Image alloc] initWithImageNamed:@"imagePlatformBouce0"];
	}
	return self;
}

- (void) createCloudPerson
{
	
}

// Reset the platform with a new position and type
- (void) resetWithType:(int)newType position:(CGPoint)newPosition theme:(int)newTheme;
{
	[self setIsAlive:TRUE];
	[self setMovementDirection:-1];
	[self setIsUsable:TRUE];
	[self setPlatformType:newType];
	[self setPlatformTheme:newTheme];
	[self setPosition:newPosition];
	
		switch (platformType) 
		{
				
			case PlatformType_Normal:
			{
				if (platformTheme == PlatformTheme_Smoke) 
				{
					[platformImage release];
					platformImage = [[Image alloc] initWithImageNamed:@"Cloud3"];
					[platformImage setColourFilterRed:0.5 green:0.5 blue:0.5 alpha:1.0];
				}
				else if (platformTheme == PlatformTheme_Cloud) 
				{
					[platformImage release];
					platformImage = [[Image alloc] initWithImageNamed:@"Cloud3"];
				}
				else if (platformTheme == PlatformTheme_Space) 
				{
					[platformImage release];
					platformImage = [[Image alloc] initWithImageNamed:@"Rock"];
				}
				break;
			}
			case PlatformType_Fake:
			{
				if (platformTheme == PlatformTheme_Smoke) 
				{
					[platformImage release];
					platformImage = [[Image alloc] initWithImageNamed:@"CloudFake3"];
					[platformImage setColourFilterRed:0.5 green:0.5 blue:0.5 alpha:1.0];
				}
				else if (platformTheme == PlatformTheme_Cloud) 
				{
					[platformImage release];
					platformImage = [[Image alloc] initWithImageNamed:@"CloudFake3"];
				}
				else if (platformTheme == PlatformTheme_Space) 
				{
					[platformImage release];
					platformImage = [[Image alloc] initWithImageNamed:@"RockFake"];
				}
				break;
			}
			case PlatformType_Dissolve:
			{
				if (platformTheme == PlatformTheme_Smoke) 
				{
					[platformImage release];
					platformImage = [[Image alloc] initWithImageNamed:@"Cloud3"];
					[platformImage setColourFilterRed:0.5 green:0.5 blue:0.5 alpha:1.0];
				}
				else if (platformTheme == PlatformTheme_Cloud) 
				{
					[platformImage release];
					platformImage = [[Image alloc] initWithImageNamed:@"Cloud3"];
				}
				else if (platformTheme == PlatformTheme_Space) 
				{
					[platformImage release];
					platformImage = [[Image alloc] initWithImageNamed:@"Rock"];
				}
				break;
			}
			case PlatformType_HMoving:
			{
				if (platformTheme == PlatformTheme_Smoke) 
				{
					[platformImage release];
					platformImage = [[Image alloc] initWithImageNamed:@"Cloud3"];
					[platformImage setColourFilterRed:0.5 green:0.5 blue:0.5 alpha:1.0];
				}
				else if (platformTheme == PlatformTheme_Cloud) 
				{
					[platformImage release];
					platformImage = [[Image alloc] initWithImageNamed:@"Cloud3"];
				}
				else if (platformTheme == PlatformTheme_Space) 
				{
					[platformImage release];
					platformImage = [[Image alloc] initWithImageNamed:@"Rock"];
				}
				break;
			}
			case PlatformType_Bouncy:
			{
				if (platformTheme == PlatformTheme_Smoke) 
				{
					[platformImage release];
					platformImage = [[Image alloc] initWithImageNamed:@"imagePlatformBouce1"];
					[platformImage setColourFilterRed:0.5 green:0.5 blue:0.5 alpha:1.0];
				}
				else if (platformTheme == PlatformTheme_Cloud) 
				{
					[platformImage release];
					platformImage = [[Image alloc] initWithImageNamed:@"imagePlatformBouce1"];
				}
				else if (platformTheme == PlatformTheme_Space) 
				{
					[platformImage release];
					platformImage = [[Image alloc] initWithImageNamed:@"imagePlatformBouce1"];
				}
				break;
			}
			case PlatformType_Net:
			{
				if (platformTheme == PlatformTheme_Smoke) 
				{
					[platformImage release];
					platformImage = [[Image alloc] initWithImageNamed:@"CloudNetPlatform"];
					[platformImage setColourFilterRed:0.5 green:0.5 blue:0.5 alpha:1.0];
				}
				else if (platformTheme == PlatformTheme_Cloud) 
				{
					[platformImage release];
					platformImage = [[Image alloc] initWithImageNamed:@"CloudNetPlatform"];
				}
				else if (platformTheme == PlatformTheme_Space) 
				{
					[platformImage release];
					platformImage = [[Image alloc] initWithImageNamed:@"imageSpacePlatformNet"];
				}
				break;
			}
			case PlatformType_Star:
			{
				[platformImage release];
				platformImage = [[Image alloc] initWithImageNamed:@"StarPlatform"];
				break;
			}
			case PlatformType_Ship:
			{
				[platformImage release];
				platformImage = [[Image alloc] initWithImageNamed:@"imageSpacePlatformShip"];
				break;
			}
			case PlatformType_Explosive:
			{
				[platformImage release];
				platformImage = [[Image alloc] initWithImageNamed:@"BombPlatform"];
				break;
			}
			default:
				break;
		}
	//}
	
	[self setSize:CGSizeMake([platformImage imageWidth], [platformImage imageHeight])];
	
	switch (platformType) 
	{
			
		case PlatformType_Normal:
		{
			awardPoints = 5;
			break;
		}
		case PlatformType_Fake:
		{
			awardPoints = 0;
			[self setIsUsable:FALSE];
			break;
		}
		case PlatformType_Dissolve:
		{
			awardPoints = 7;
			break;
		}
		case PlatformType_HMoving:
		{
			movementDirection = RANDOM(2);
			awardPoints = 10;
			break;
		}
		case PlatformType_Bouncy:
		{
			awardPoints = 7;
			currentBounce = 0;
			coutdownTimer = 0.2;
			break;
		}
		case PlatformType_Net:
		{
			awardPoints = 1;
			size.height /= 2;
			break;
		}
		case PlatformType_Star:
		{
			awardPoints = 20;
			break;
		}
		case PlatformType_Ship:
		{
			awardPoints = 0;
			break;
		}
		case PlatformType_Explosive:
		{
			awardPoints = 7;
			coutdownTimer = 10;
			break;
		}
		default:
			break;
	}
	/*
	
	if(newTheme != PlatformTheme_Smoke && RANDOM(3) == 0 && isUsable)
	{
		MGSkyObstacle *obstacle = [[MGSkyObstacle alloc] initWithTheme:newTheme withOwner:self];
		int w = size.width;
		[obstacle setPositionObstacle:CGPointMake(RANDOM(w), 0)];
	}
	*/
}

// Applys accelerometer to the player.
- (void) applyAccelerometer:(GLfloat)data
{
	position.x -= data;
}

- (void) updateWithDelta:(GLfloat)delta
{
	[emitter update:delta];
	
	switch (platformType) 
	{
		case PlatformType_Explosive:
		{
			if (coutdownTimer > 0) 
			{
				coutdownTimer -= delta;
			}
			else 
			{
				[platformImage setAlpha:0.0];
				[self setIsUsable:FALSE];
			}
			break;
		}
		case PlatformType_HMoving:
		{
			if(movementDirection == 0)
			{
				position.x += (1 + RANDOM_0_TO_1()) * (1 + delta);
				if(position.x + size.width > 640)
					movementDirection = 1;
			}
			else 
			{
				position.x -= (1 + RANDOM_0_TO_1()) * (1 + delta);
				if(position.x < -320)
					movementDirection = 0;
			}
			break;
		}
		case PlatformType_Bouncy:
		{
			if (coutdownTimer > 0) 
			{
				coutdownTimer -= delta;
			}
			else 
			{
				coutdownTimer = 0.2;
				currentBounce += 1;
				if(currentBounce > 1)
					currentBounce = 0;
			}
			
			if(currentBounce == 0)
				position.y += (1 + RANDOM_0_TO_1()) * delta * 5;
			else
				position.y -= (1 + RANDOM_0_TO_1()) * delta * 5;
			
			break;
		}
		default:
			break;
	}
	
	/*
	if(obstacle != nil)
	{
		if(isUsable)
		{
			[obstacle updateWithDelta:delta];
		
			if ([obstacle positionObstacle].x < 0) 
				[obstacle flipDirection];
		
			if ([obstacle positionObstacle].y > size.width) 
				[obstacle flipDirection];
		}
		else
		{
			// Make the obstacle fall since the 
			// platform probably is invisible now.
			CGPoint oldObstaclePosition = [obstacle positionObstacle];
			[obstacle setPositionObstacle:CGPointMake(oldObstaclePosition.x, 
													  oldObstaclePosition.y - (delta * 5))];
		}
	}
	 */
	
	if(position.x < -320)
		position.x = position.x + 320 + 640;
	else if(position.x > 640)
		position.x = position.x - 640 - 320;
	
}

// Applies velocity to the platform
- (void) applyVelocity:(float)velocity
{
	position.y -= velocity;
	if(position.y < -240)
	{
		[self setIsAlive:FALSE];
	}
}

- (int) retrieveAwardPoints
{
	int points = awardPoints;
	awardPoints = 0;
	return points;
}

// Collision Check Method
// The player may go through the sides of the platfom or may through it completly
// The player gains a jump when successfully lands ontop of the platform.
- (BOOL) hasCollidedWithPlayer:(JumpScrollerPlayer*)player withDelta:(GLfloat)delta
{
	CGPoint playerPosition = [player position];
	CGPoint velocity = [player velocity];
	velocity.x *= delta;
	velocity.y *= delta;
	
	// Check to see if the player is above or under the platform
	// Adding a total of 24 to the platform to accomodate the player width
	if(playerPosition.x > position.x - 12 && playerPosition.x < position.x + size.width + 12)
	{
		// The player has entered the area of the this ground;
		// Checking to see if player is above ground; 
		if(playerPosition.y >= position.y)
		{
			// OLD OBSTACLE CHECKING
			/*
			// (position.x + offset - 10, position.y + 20 + bounceOffset
			// Check ti see if player will hit the obstacle when velocity is applied.
			
			
			// If the obstacle is not nil check to see
			// if the player has collided with it.
			if(obstacle != nil && [obstacle isAlive] && isUsable)
			{
				if(playerPosition.y + velocity.y < position.y - velocity.y + 20)
				{
					float objPosX = position.x + [obstacle offset] - 10;
					if(playerPosition.x > objPosX - 12 && playerPosition.x < objPosX + 30 + 12)
					{
						[obstacle setIsAlive:FALSE];
						/*
						ObjectEventArguements args = [Director sharedDirector] eventArgs];
					
						args.particleEmitterNeeded = TRUE;
						args.particleEmitterPosition = CGPointMake(position.x + [obstacle offset],
																position.y + 20 + [obstacle bounceOffset]);
						 
						
						if(platformTheme ==PlatformTheme_Cloud)
						{
							emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"CloudParticle"
																					position:Vector2fMake(playerPosition.x, 
																										  playerPosition.y- size.height)
																	  sourcePositionVariance:Vector2fMake(0,0)
																					   speed:50.0f
																			   speedVariance:0.0f
																			particleLifeSpan:0.50f	
																	particleLifespanVariance:0.0f
																					   angle:270.0f
																			   angleVariance:90.0f
																					 gravity:Vector2fMake(0.0f, 0.0f)
																				  startColor:Color4fMake(1.0f, 1.0f, 1.0f, 1.0f)
																		  startColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.5f)
																				 finishColor:Color4fMake(1.0f, 1.0f, 1.0f, 0.0f)  
																		 finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
																				maxParticles:4
																				particleSize:20
																		particleSizeVariance:1
																					duration:0.50f
																			   blendAdditive:NO];
						}
						else if(platformTheme ==PlatformTheme_Space)
						{
							emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"CloudParticle"
																						position:Vector2fMake(playerPosition.x, 
																											  playerPosition.y- size.height)
																		  sourcePositionVariance:Vector2fMake(0,0)
																						   speed:50.0f
																				   speedVariance:0.0f
																				particleLifeSpan:0.50f	
																		particleLifespanVariance:0.0f
																						   angle:270.0f
																				   angleVariance:90
																						 gravity:Vector2fMake(0.0f, 0.0f)
																					  startColor:Color4fMake(0.66f, 0.49f, 0.31f, 1.0f)
																			  startColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.5f)
																					 finishColor:Color4fMake(0.66f, 0.49f, 0.31f, 0.0f)  
																			 finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
																					maxParticles:4
																					particleSize:20
																			particleSizeVariance:1
																						duration:0.50f
																				   blendAdditive:NO];
						}
					
						//[Director sharedDirector] setEventArgs:args];
					
						// Kills the obstacle and rewards the player with 5 points.
						awardPoints *= 1.5;
					}
				}
			}
			*/
			
			// Checking to see if player will hit ground when velocity is applied;
			if(playerPosition.y + velocity.y < position.y - velocity.y)
			{
				if([self isUsable])
				{
					
					if (platformType == PlatformType_Bouncy) 
					{
						[player applySuperJump];
					}
					else if(platformType == PlatformType_Ship)
					{
						[player applyShip];
						[platformImage setAlpha:0.0];
						[self setIsUsable:FALSE];
					}
					else
					{
						// Since the player will hit the ground next step apply possible jump
						[player applyJump];
						//[player applyShip];
					}
					// Check to see if the platform will remain usable
					if(platformType == PlatformType_Dissolve)
					{
						[self setIsUsable:FALSE];
						
						[platformImage setAlpha:0.0];
						if(platformTheme ==PlatformTheme_Smoke)
						{
							emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"CloudParticle"
																						position:Vector2fMake(playerPosition.x , 
																											  playerPosition.y- size.height)
																		  sourcePositionVariance:Vector2fMake(0,0)
																						   speed:50.0f
																				   speedVariance:0.0f
																				particleLifeSpan:0.50f	
																		particleLifespanVariance:0.0f
																						   angle:270.0f
																				   angleVariance:90
																						 gravity:Vector2fMake(0.0f, 0.0f)
																					  startColor:Color4fMake(0.5f, 0.5f, 0.5f, 1.0f)
																			  startColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.5f)
																					 finishColor:Color4fMake(0.5f, 0.5f, 0.5f, 0.0f)  
																			 finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
																					maxParticles:6
																					particleSize:25
																			particleSizeVariance:1
																						duration:0.50f
																				   blendAdditive:NO];
						}
						else if(platformTheme ==PlatformTheme_Cloud)
						{
							emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"CloudParticle"
																					position:Vector2fMake(playerPosition.x , 
																										  playerPosition.y- size.height)
																	  sourcePositionVariance:Vector2fMake(0,0)
																					   speed:50.0f
																			   speedVariance:0.0f
																			particleLifeSpan:0.50f	
																	particleLifespanVariance:0.0f
																					   angle:270.0f
																			   angleVariance:90
																					 gravity:Vector2fMake(0.0f, 0.0f)
																				  startColor:Color4fMake(1.0f, 1.0f, 1.0f, 1.0f)
																		  startColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.5f)
																				 finishColor:Color4fMake(1.0f, 1.0f, 1.0f, 0.0f)  
																		 finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
																				maxParticles:6
																				particleSize:25
																		particleSizeVariance:1
																					duration:0.50f
																			   blendAdditive:NO];
						}
						else if(platformTheme ==PlatformTheme_Space)
						{
							emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"CloudParticle"
																						position:Vector2fMake(playerPosition.x, 
																											  playerPosition.y- size.height)
																		  sourcePositionVariance:Vector2fMake(0,0)
																						   speed:50.0f
																				   speedVariance:0.0f
																				particleLifeSpan:0.50f	
																		particleLifespanVariance:0.0f
																						   angle:270.0f
																				   angleVariance:90
																						 gravity:Vector2fMake(0.0f, 0.0f)
																					  startColor:Color4fMake(0.66f, 0.49f, 0.31f, 1.0f)
																			  startColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.5f)
																					 finishColor:Color4fMake(0.66f, 0.49f, 0.31f, 0.0f)  
																			 finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
																					maxParticles:6
																					particleSize:25
																			particleSizeVariance:1
																						duration:0.50f
																				   blendAdditive:NO];
						}
					}
					
					if(platformType == PlatformType_Explosive)
					{
						[platformImage setAlpha:0.0];
						[self setIsUsable:FALSE];
						emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"imageParticleFire"
																					position:Vector2fMake(playerPosition.x, 
																										  playerPosition.y- size.height)
																	  sourcePositionVariance:Vector2fMake(0,0)
																					   speed:50.0f
																			   speedVariance:1.0f
																			particleLifeSpan:0.5f	
																	particleLifespanVariance:0.2f
																					   angle:270.0f
																			   angleVariance:90
																					 gravity:Vector2fMake(0.0f, 0.0f)
																				  startColor:Color4fMake(1.0f, 0.0f, 0.0f, 1.0f)
																		  startColorVariance:Color4fMake(0.0f, 1.0f, 0.0f, 0.0f)
																				 finishColor:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)  
																		 finishColorVariance:Color4fMake(0.00f, 0.00, 0.00, 0.0f)
																				maxParticles:75
																				particleSize:10
																		particleSizeVariance:1
																					duration:0.25f
																			   blendAdditive:NO];
					}
					if(platformType == PlatformType_Star)
					{
						emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"imageStar"
																					position:Vector2fMake(playerPosition.x, 
																										  playerPosition.y- size.height )
																	  sourcePositionVariance:Vector2fMake(0,0)
																					   speed:100.0f
																			   speedVariance:1.0f
																			particleLifeSpan:0.5f	
																	particleLifespanVariance:0.2f
																					   angle:180.0f
																			   angleVariance:180
																					 gravity:Vector2fMake(0.0f, -10.0f)
																				  startColor:Color4fMake(1.0f, 1.0f, 0.0f, 1.0f)
																		  startColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
																				 finishColor:Color4fMake(0.0f, 1.0f, 0.0f, 0.0f)  
																		 finishColorVariance:Color4fMake(0.00f, 0.00, 0.00, 0.0f)
																				maxParticles:75
																				particleSize:10
																		particleSizeVariance:1
																					duration:0.25f
																			   blendAdditive:NO];
					}
					
					return TRUE;
				}
				else 
				{
					return FALSE;
				}
			}
			else 
			{
				// The player is above the ground and wont hit next update
				return FALSE;
			}
		}
		else 
		{
			// player is under the ground, do nothing and allow the player to pass through the ground
			return FALSE;
		}
	}
	else 
	{
		// The player is not in the area where the object is
		// Do Nothing..
		return FALSE;
	}
}

// Renders the platform object
- (void) render
{
	//NSLog(@"Rendering Platform witihn Platform");
	
	if(position.x > -size.width && position.x < 320)
	{
		if(platformType == PlatformType_Bouncy && currentBounce == 1)
			[platformImageSecondary renderAtPoint:position centerOfImage:FALSE];
		else
			[platformImage renderAtPoint:position centerOfImage:FALSE];
		
		/*
		if(obstacle != nil)
		{
			[obstacle renderAtPosition:position];
		}
		 */
		
		[emitter renderParticles];
	}
}

@end

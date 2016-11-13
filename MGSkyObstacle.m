//
//  MGSkyObstacle.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 2/15/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import "MGSkyObstacle.h"


@implementation MGSkyObstacle

@synthesize positionObstacle, readyForDeletion;

// Initialize the Obstacle
- (id) initAsType:(int)type
{
	if(self = [super init])
	{
		readyForDeletion = NO;
		isAlive = YES;
		isEnraged = NO;
		positionObstacle = CGPointZero;
		velocityObstacle = CGPointZero;
		typeObstacle = type;
		directionPlayer = CGPointZero;
		timeBeforeActionChange = 0.5 + RANDOM_0_TO_1();
		currentAction = MGSkyObstacleAction_Idle;
		//abilityCooldown = 0;
		
		// For now color will be random, but later it will be assigned by type;
		int rndColor = RANDOM(3);
		if(rndColor == 0)
			colorObstacle = Color4fMake(0.75 + RANDOM_0_TO_1() / 4, RANDOM_0_TO_1(), RANDOM_0_TO_1(), 1.0f);
		else if(rndColor == 1)
			colorObstacle = Color4fMake(RANDOM_0_TO_1(), 0.75 + RANDOM_0_TO_1() / 4, RANDOM_0_TO_1(), 1.0f);
		else if(rndColor == 2)
			colorObstacle = Color4fMake(RANDOM_0_TO_1(), RANDOM_0_TO_1(), 0.75 + RANDOM_0_TO_1() / 4, 1.0f);
		
		// Loads the body based on shape
		imageBody = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"Triangle32" withinAtlasNamed:@"ShapesAtlas"];
		[imageBody setColourFilterRed:colorObstacle.red 
								green:colorObstacle.green 
								 blue:colorObstacle.blue 
								alpha:colorObstacle.alpha];
		// Loads the eyes
		imageEyes = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"ShapesEyes" withinAtlasNamed:@"ShapesAtlas"];
		[imageEyes setColourFilterRed:0.2 
								green:0.2
								 blue:0.2 
								alpha:1.0];
	}
	return self;
}

- (void)dealloc 
{
	[imageBody release];
	imageBody = nil;
	
	[imageEyes release];
	imageEyes = nil;
	
	[emitter release];
	emitter = nil;
	
	[super dealloc];
}

// Becomes Enraged
- (void) becomeEnrage
{
	isEnraged = TRUE;
}

// Becomes the assigned type
- (void) becomeType:(int)type
{
	
}

// Kills the Obstacle
- (void) die
{
	if(readyForDeletion)
		return;
	
	if(!isAlive)
		return;
	
	// Begin the Emitter;
	emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"CloudParticle"
																position:Vector2fMake(positionObstacle.x, 
																					  positionObstacle.y)
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

// Performs ability
- (void) useAbility
{
	switch (typeObstacle) 
	{
		case ShapeType_Circle:
		{
			abilityCooldown = 3;
			break;
		}
		case ShapeType_Triangle:
		{
			//positionObstacle = CGPointAdd(positionObstacle, CGPointMultiply(directionPlayer, delta * 100));
			abilityCooldown = 3;
			break;
		}
		case ShapeType_Square:
		{
			abilityCooldown = 3;
			break;
		}
		default:
			break;
	}
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
	
	float velocity = 0;
	
	abilityCooldown -= delta;
	if(abilityCooldown <= 0)
	{
		abilityCooldown = 1 + RANDOM_0_TO_1();
		CGPoint playerPosition = CGPointMake(RANDOM_MINUS_1_TO_1() * 320, 460 + RANDOM_0_TO_1() * 20);
		directionPlayer = CGPointNormalize(CGPointSub(playerPosition, positionObstacle));
	}
	velocity = 200;
	
	// Perform a collision check
	[self hasCollidedWithPlayer:player withDelta:delta];
	
	// Apply Velocity to the object
	positionObstacle = CGPointAdd(positionObstacle, CGPointMultiply(directionPlayer, delta * velocity));
}

// Applys accelerometer to the player.
- (void) applyAccelerometer:(GLfloat)data
{
	if(readyForDeletion)
		return;
	
	if(!isAlive)
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
	
	CGPoint playerPosition = player.playerInfo.playerPosition;
	CGPoint velocity = player.playerInfo.playerVelocity;
	CGSize playerSize = player.sizePlayer;
	velocity.x *= delta;
	velocity.y *= delta;
	
	// Check to see if the player is above or under the platform
	// Adding a total of 26 to the platform to accomodate the player width
	if(playerPosition.x + playerSize.width > positionCombined.x && 
	   playerPosition.x - playerSize.width < positionCombined.x + obstacleSizeWidth)
	{
		// The player has entered the area of the this ground;
		// Checking to see if player is above obstacle; 
		if(playerPosition.y + playerSize.height >= positionCombined.y)
		{
			// Checking to see if player will hit obstacle when velocity is applied;
			if(playerPosition.y - playerSize.height + velocity.y < positionCombined.y - velocity.y)
			{
				// The player is above the obstacle and will hit next update
				
				//if([player isAlive])
				//	[player die];
				
				//velocity =  CGPointAdd(velocity, CGPointMultiply(directionPlayer, 500));
				//[player setVelocityPlayer:velocity];
				//directionPlayer = CGPointMultiply(directionPlayer, -1);
					//NSLog(@"Player Died by Angry Obstacle!");
				
				// The player is rising, flip velocity
				if(velocity.y > 0)
				{
					velocity =  CGPointMultiply(velocity, -1);
					[player setVelocityTo:velocity];
				}
				// The player is falling, multiply it by 2
				else
				{
					velocity =  CGPointMultiply(velocity, 2);
					[player setVelocityTo:velocity];
				}
				
				directionPlayer = CGPointMultiply(directionPlayer, -1);
				
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
				
				// The player is rising, flip velocity
				if(velocity.y > 0)
				{
					velocity =  CGPointMultiply(velocity, -1);
                    [player setVelocityTo:velocity];
				}
				// The player is falling, multiply it by 2
				else
				{
					velocity =  CGPointMultiply(velocity, 2);
                    
                    [player setVelocityTo:velocity];
                    
				}
				
				directionPlayer = CGPointMultiply(directionPlayer, -1);
			
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
		[imageBody renderAtPoint:positionObstacle centerOfImage:YES];
		[imageEyes renderAtPoint:positionObstacle centerOfImage:YES];
	}
	
	// Render Emitter
	[emitter renderParticles];
}

@end

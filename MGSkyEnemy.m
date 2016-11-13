//
//  MGSkyEnemy.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 3/2/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import "MGSkyEnemy.h"

#define NeighborMaxDistance 64
#define NeighborMinDistance 16
#define MaxSpeed 200.0f
#define MaxForce 10.0f

@implementation MGSkyEnemy

@synthesize positionCurrent, 
			accelerationCurrent, 
			velocityCurrent, 
			positionTarget, 
			readyForDeletion, 
			isAlive, 
			isLeader;


// Initialize the Obstacle
- (id) initAsShape:(Shape_Level)shape
{
	if((self = [super init]))
	{
		readyForDeletion = NO;
		isAlive = YES;
		isLeader = FALSE;
		
		//if(shape == Shape_Square)
		//	isLeader = TRUE;
		
		leaderEnemy = nil;
		
		positionCurrent = CGPointMake(160, 240);
		velocityCurrent = CGPointMake(RANDOM_MINUS_1_TO_1() * 100, RANDOM_MINUS_1_TO_1() * 100);
		shapeCurrent = shape;

		// Loads the body based on shape
		imageBody = [[ResourceManager sharedResourceManager] getImageWithImageNamed:NSStringFromShapeLevel(shape) withinAtlasNamed:@"ShapesAtlas"];
		[imageBody setColourWithColor4f:Color4fFromShapeLevel(shapeCurrent)];
		[imageBody setScale:0.75];
		// Loads the eyes
		imageEyes = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"ShapesEyes32" withinAtlasNamed:@"ShapesAtlas"];
		[imageEyes setColourFilterRed:0.2 
								green:0.2
								 blue:0.2 
								alpha:1.0];
		[imageEyes setScale:0.75];
		
		tillTargetChange = 0;
	}
	return self;
}

- (void)dealloc 
{
	[imageBody release];
	imageBody = nil;
	
	[imageEyes release];
	imageEyes = nil;
	
	[super dealloc];
}

// Update method with the owning game scene
- (void) updateWithDelta:(GLfloat)delta withNeighbors:(NSMutableArray*)neighbors andPlayer:(MGSkyPlayer*)player
{
	if(!isAlive && readyForDeletion)
		return;
	
	tillTargetChange -= delta;
	if(!isAlive && tillTargetChange <= 0)
	{
		readyForDeletion = TRUE;
			return;
	}
	
	if(isLeader)
	{
		// Is the Leader; Will move Randomly or At the player.
		// ---------------------------------------------------
		
		// Target Position Change Check
		if(tillTargetChange <= 0)
		{
			tillTargetChange = RANDOM_0_TO_1();
			
			if (RANDOM(3) == 1) 
				positionTarget = player.playerInfo.playerPosition;
			else
				positionTarget = CGPointMake(RANDOM(320), 320 + RANDOM(160));
		}
		
		// Find Acceleration based upon Seek and Seperation Behaviors
		accelerationCurrent = CGPointAdd([self steerTowardPosition:positionTarget], 
										 [self flockingSeperate:neighbors]);
		
		// Add Acceleration to Velocity
		velocityCurrent = CGPointAdd(velocityCurrent, accelerationCurrent);
		
		// Limit Velocity
		if(CGPointLength(velocityCurrent) > MaxSpeed)
		{
			velocityCurrent = CGPointNormalize(velocityCurrent);
			velocityCurrent = CGPointMultiply(velocityCurrent, MaxSpeed);
		}
		
		// Add Velocity to Position
		positionCurrent = CGPointAdd(positionCurrent, CGPointMultiply(velocityCurrent, delta));

		// Check Collision
		if([player isAlive])
			[self hasCollidedWithPlayer:player withDelta:delta];
		
		// Wrap if needed
		if(positionCurrent.x < -320)
			positionCurrent.x = positionCurrent.x + 320 + 640;
		else if(positionCurrent.x > 640)
			positionCurrent.x = positionCurrent.x - 640 - 320;
		
	}
	else
	{
		// Makes sure leaderEnemy is present and alive
		// or else removes it.
		if(leaderEnemy && ![leaderEnemy isAlive])
			leaderEnemy = nil;
		
		if(leaderEnemy)
		{
			// Has a leader; Will move towards the leader while keeping alignment with the pack
			// --------------------------------------------------------------------------------
			
			// Target Position Change
			positionTarget = [leaderEnemy positionCurrent];
			
			// Find Acceleration based upon Seek and Alignment Behaviors
			accelerationCurrent = CGPointAdd([self steerTowardPosition:positionTarget], 
											 [self flockingAlignment:neighbors]);
			
			// Add Acceleration to Velocity
			velocityCurrent = CGPointAdd(velocityCurrent, accelerationCurrent);
			
			// Limit Velocity
			if(CGPointLength(velocityCurrent) > MaxSpeed)
			{
				velocityCurrent = CGPointNormalize(velocityCurrent);
				velocityCurrent = CGPointMultiply(velocityCurrent, MaxSpeed);
			}
			
			// Add Velocity to Position
			positionCurrent = CGPointAdd(positionCurrent, CGPointMultiply(velocityCurrent, delta));
			
			// Check Collision
			if([player isAlive])
				[self hasCollidedWithPlayer:player withDelta:delta];
			
			// Wrap if needed
			if(positionCurrent.x < -320)
				positionCurrent.x = positionCurrent.x + 320 + 640;
			else if(positionCurrent.x > 640)
				positionCurrent.x = positionCurrent.x - 640 - 320;
			
		}
		else
		{
			// No leader or dead leader, Will move Randomly
			//------------------------------
			
			// Target Position Change Check
			if(tillTargetChange <= 0)
			{
				tillTargetChange = RANDOM_0_TO_1();
				
				positionTarget = CGPointMake(RANDOM(320), 320 + RANDOM(160));
			}
			
			// Find Acceleration based upon Seek Behavior
			accelerationCurrent = [self steerTowardPosition:positionTarget];
			
			// Add Acceleration to Velocity
			velocityCurrent = CGPointAdd(velocityCurrent, accelerationCurrent);
			
			// Limit Velocity
			if(CGPointLength(velocityCurrent) > MaxSpeed)
			{
				velocityCurrent = CGPointNormalize(velocityCurrent);
				velocityCurrent = CGPointMultiply(velocityCurrent, MaxSpeed);
			}
			
			// Add Velocity to Position
			positionCurrent = CGPointAdd(positionCurrent, CGPointMultiply(velocityCurrent, delta));
			
			// Check Collision
			if([player isAlive])
				[self hasCollidedWithPlayer:player withDelta:delta];
			
			// Wrap if needed
			if(positionCurrent.x < -320)
				positionCurrent.x = positionCurrent.x + 320 + 640;
			else if(positionCurrent.x > 640)
				positionCurrent.x = positionCurrent.x - 640 - 320;
		}
	}
}

- (void) assignLeader:(MGSkyEnemy*)newLeader
{
	if(!isAlive || readyForDeletion)
		return;
	
	if((leaderEnemy && [leaderEnemy isAlive]) || isLeader)
		return;
	
	if(leaderEnemy)
		leaderEnemy = nil;
	
	leaderEnemy = newLeader;
}

// Kills the Obstacle
- (void) die
{
	isAlive = FALSE;
	readyForDeletion = TRUE;
	tillTargetChange = 1.0;
}

/*
- (void) updateWithDelta:(GLfloat)delta withPlayer:(MGSkyPlayer*)player
{
	timeSinceUpdate -= delta;
	if(timeSinceUpdate <= 0)
	{
		// Time to Assign a new target position.
		int randomAct = RANDOM(100);
		
		// (50%) Assign a random top position	
		if(randomAct < 50)
		{
			positionTarget = CGPointMake(RANDOM(320), 400 + RANDOM(160));
		}
		// (40%)Assign as player's target
		else if(randomAct < 90)
		{
			positionTarget = [player positionPlayer];
		}
		// (1%) Become Enrage!
		else if(randomAct < 91)
		{
			[self becomeEnrage];
		}
		// (9%) Shift Type
		else if(randomAct < 100)
		{
			[self becomeType:1+RANDOM(8)];
		}	
		
		timeSinceUpdate = RANDOM_0_TO_1();
	}
	
	// Setup acceleration from flocking algorthim by collecting the three components.
	accelerationCurrent = [self steerTowardPosition:positionTarget];
	
	// Acceleration is added to Velocity then capped at its limit
	velocityCurrent = CGPointAdd(velocityCurrent, accelerationCurrent);
	
	if(CGPointLength(velocityCurrent) > MaxSpeed)
	{
		velocityCurrent = CGPointNormalize(velocityCurrent);
		velocityCurrent = CGPointMultiply(velocityCurrent, MaxSpeed);
	}
	
	// Velocity is added to its position
	positionCurrent = CGPointAdd(positionCurrent, CGPointMultiply(velocityCurrent, delta));
	
	[self hasCollidedWithPlayer:player withDelta:delta];
	
	if(positionCurrent.x < -320)
		positionCurrent.x = positionCurrent.x + 320 + 640;
	else if(positionCurrent.x > 640)
		positionCurrent.x = positionCurrent.x - 640 - 320;
}
 */

#define obstacleSizeWidth 22
#define playerSizeWidth 10

// Collision Check Method
- (int) hasCollidedWithPlayer:(MGSkyPlayer*)player withDelta:(GLfloat)delta
{
	CGPoint playerPosition = player.playerInfo.playerPosition;
	CGPoint velocity = player.playerInfo.playerVelocity;
	CGSize playerSize = [player sizePlayer];
	velocity.x *= delta;
	velocity.y *= delta;
		
	// Check to see if the player is above or under the platform
	// Adding a total of 26 to the platform to accomodate the player width
	if(playerPosition.x + playerSize.width > positionCurrent.x && 
	   playerPosition.x - playerSize.width < positionCurrent.x + obstacleSizeWidth)
	{
		// The player has entered the area of the this ground;
		// Checking to see if player is above obstacle; 
		if(playerPosition.y + playerSize.height >= positionCurrent.y)
		{
			// Checking to see if player will hit obstacle when velocity is applied;
			if(playerPosition.y - playerSize.height + velocity.y < positionCurrent.y - velocity.y)
			{
				
				// If the velocity is upward inverse it and do not add it
				if(velocityCurrent.y > 0)
				{
                    [player setVelocityTo:CGPointAdd(velocity, velocityCurrent)];
                    [[SettingManager sharedSettingManager] forPlayerAdjustBoostBy:1];
					[self die];
                    return 0;
				}
				
				[player setVelocityTo:CGPointAdd(velocity, velocityCurrent)];
				
				//velocityCurrent = CGPointAdd(velocityCurrent, velocity);
				
				// Velocity is added to its position
				//positionCurrent = CGPointAdd(positionCurrent, CGPointMultiply(velocityCurrent, delta));
                [[SettingManager sharedSettingManager] forPlayerAdjustBoostBy:1];
				//[self die];
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
			if(playerPosition.y + playerSize.height + velocity.y > positionCurrent.y - velocity.y)
			{
				
				switch (shapeCurrent) 
				{
					case Shape_Circle:
					{
						//  Add Velocity
						[player setVelocityTo:CGPointAdd(velocity, velocityCurrent)];
						[self die];
						break;
					}
					case Shape_Triangle:
					{
						// Kill Player
						//[player die];
                        [player setVelocityTo:CGPointAdd(velocity, velocityCurrent)];
						[self die];
						break;
					}
					case Shape_Square:
					{
						//  Add Velocity
						//velocityCurrent = CGPointMultiply(velocityCurrent, multi);
						[player setVelocityTo:CGPointAdd(velocity, velocityCurrent)];
						[self die];
						break;
					}
					default:
					{
						//  Add Velocity
						//velocityCurrent = CGPointMultiply(velocityCurrent, multi);
						[player setVelocityTo:CGPointAdd(velocity, velocityCurrent)];
						[self die];
						break;
					}
				}
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
		return 0;
	}
}
/*

// Update's the Obstacle
- (void) updateWithDelta:(GLfloat)delta andNeighbors:(NSMutableArray*)neighbors
{
	// Setup acceleration from flocking algorthim by collecting the three components.
	[self flocking:neighbors];
	// Acceleration is added to Velocity then capped at its limit
	velocityCurrent = CGPointAdd(velocityCurrent, accelerationCurrent);
	
	if(CGPointLength(velocityCurrent) > MaxSpeed)
	{
		velocityCurrent = CGPointNormalize(velocityCurrent);
		velocityCurrent = CGPointMultiply(velocityCurrent, MaxSpeed);
	}
	
	// Limits the Velocity Magnitude
	//if(CGPointLength(velocityCurrent) > MaxSpeed)
	//	velocityCurrent = CGPointMultiply(CGPointNormalize(velocityCurrent), MaxSpeed);
	
	// Velocity is added to its position
	positionCurrent = CGPointAdd(positionCurrent, CGPointMultiply(velocityCurrent, delta));
	
	if(positionCurrent.x > 320)
		positionCurrent.x = 0;
	else if(positionCurrent.x < 0)
		positionCurrent.x = 320;
	
	if(positionCurrent.y > 480)
		positionCurrent.y = 0;
	else if(positionCurrent.y < 0)
		positionCurrent.y = 480;
	
	accelerationCurrent = CGPointZero;
}
 */

// Applys accelerometer to the player.
- (void) applyAccelerometer:(GLfloat)data
{
	if(!isAlive || readyForDeletion)
		return;
	
	positionCurrent.x -= data;
}

// Applies velocity to the platform
- (void) applyVelocity:(float)velocity
{
	if(!isAlive || readyForDeletion)
		return;
	
	positionCurrent.y -= velocity;
	if(positionCurrent.y < -230)
	{
		[self die];
	}
}

// Renders the Obstacle
- (void) render;
{
	// Render if isAlive
	if(isAlive)
	{
		[imageBody renderAtPoint:positionCurrent centerOfImage:YES];
		[imageEyes renderAtPoint:positionCurrent centerOfImage:YES];
	}
}

// Flocking algorthim by collecting the three components.
// Calculates acceleration based upon its neighbors
- (void) flocking:(NSArray*)neighbors
{
	// Seperation Component
	CGPoint seperation = CGPointMultiply([self flockingSeperate:neighbors], 2);
	// Alignment Component
	CGPoint alignment = CGPointMultiply([self flockingAlignment:neighbors], 1);
	// Cohesion Component
	CGPoint cohesion = CGPointMultiply([self flockingCohesion:neighbors], 1);
	
	accelerationCurrent = CGPointAdd(accelerationCurrent, seperation);
	accelerationCurrent = CGPointAdd(accelerationCurrent, alignment);
	accelerationCurrent = CGPointAdd(accelerationCurrent, cohesion);
}

// Seperate Component of the Flocking algorthim
// Trys to keep each object away from eachothers bubble
- (CGPoint) flockingSeperate:(NSArray*)neighbors
{
	CGPoint flockMean = CGPointZero;
	int consideredNeighbors = 0;
	
	for(MGSkyEnemy *neighbor in neighbors)
	{
		[neighbor assignLeader:self];
		// Retrieve the distance between enemy and neighbor
		// if distance is greater than 0 and less than max
		// its a neighbor
		float distance = CGPointDistance(positionCurrent, neighbor.positionCurrent);
		if(distance > 0 && distance < NeighborMinDistance)
		{
			CGPoint diff = CGPointSub(positionCurrent, neighbor.positionCurrent);
			diff = CGPointNormalize(diff);
			diff = CGPointDivide(diff, distance);
			flockMean = CGPointAdd(flockMean,diff);
			consideredNeighbors++;
		}
	}
	
	if (consideredNeighbors > 0) 
		flockMean = CGPointDivide(flockMean, consideredNeighbors);
	
	return flockMean;
}

// Alignment Component of the Flocking algorthim
// Determines the heading based on neighbors
- (CGPoint) flockingAlignment:(NSArray*)neighbors
{
	CGPoint flockMean = CGPointZero;
	int consideredNeighbors = 0;
	
	for(MGSkyEnemy *neighbor in neighbors)
	{
		// Retrieve the distance between enemy and neighbor
		// if distance is greater than 0 and less than max
		// its a neighbor
		float distance = CGPointDistance(positionCurrent, neighbor.positionCurrent);
		if(distance > 0 && distance < NeighborMaxDistance)
		{
			flockMean = CGPointAdd(flockMean, neighbor.positionCurrent);
			consideredNeighbors++;
		}
	}
	
	if (consideredNeighbors > 0) 
	{
		flockMean = CGPointDivide(flockMean, consideredNeighbors);
		if(CGPointLength(flockMean) > MaxForce)
		{
			flockMean = CGPointNormalize(flockMean);
			flockMean = CGPointMultiply(flockMean, MaxForce);
		}
	}
	
	return flockMean;
}

// Cohesion Component of the Flocking algorthim
// Determines the center position of the flock
- (CGPoint) flockingCohesion:(NSArray*)neighbors
{
	CGPoint flockCenter = CGPointZero;
	int consideredNeighbors = 0;
	
	for(MGSkyEnemy *neighbor in neighbors)
	{
		// Retrieve the distance between enemy and neighbor
		// if distance is greater than 0 and less than max
		// its a neighbor
		float distance = CGPointDistance(positionCurrent, [neighbor positionCurrent]);
		if(distance > 0 && distance < NeighborMaxDistance)
		{
			flockCenter = CGPointAdd(flockCenter, [neighbor positionCurrent]);
			consideredNeighbors++;
		}
	}
	
	if (consideredNeighbors > 0) 
	{
		flockCenter = CGPointDivide(flockCenter, consideredNeighbors);
		return [self steerTowardPosition:flockCenter];
	}
	
	return flockCenter;
}

- (CGPoint) steerTowardPosition:(CGPoint)setTarget
{
	CGPoint targetDirection = CGPointSub(setTarget, positionCurrent);
	float targetMagnitude = CGPointLength(targetDirection);
	
	if (targetMagnitude > 0)
	{
		targetDirection = CGPointNormalize(targetDirection);
		
		if(targetMagnitude < MaxSpeed)
			targetDirection = CGPointMultiply(targetDirection, MaxSpeed * (targetMagnitude / 100));
		else
			targetDirection = CGPointMultiply(targetDirection, MaxSpeed);
		
		targetDirection = CGPointSub(targetDirection, velocityCurrent);
		if(CGPointLength(targetDirection) > MaxForce)
		{
			targetDirection = CGPointNormalize(targetDirection);
			targetDirection = CGPointMultiply(targetDirection, MaxForce);
		}
		return targetDirection;
	}
	
	return CGPointZero;
}

@end

//
//  SideScrollerGroundObject.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 11/5/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

#import "SideScrollerGroundObject.h"


@implementation SideScrollerGroundObject

@synthesize position, size, islandType, isAlive, isCollasping;

// Initialize the ground
- (id) init
{
	if(self = [super init])
	{
		position = CGPointZero;
		size = CGSizeZero;
		imageBlocks = [[NSMutableArray alloc] initWithCapacity:6];
		obstacleTimer = 0;
		boostTimer = 15 + RANDOM(10);
	}
	return self;
}

// Reset the ground with a new position, size and type
- (void) resetWithType:(int) newType position:(CGPoint)newPosition size:(CGSize)newSize
{
	isAlive = TRUE;
	isCollasping = FALSE;
	// Sets the max block size now, in case for override later.
	int maxBlocks = (newSize.width - 320) / 16 + 2;
	
	// If the new Type is normal then lets see if a obstacle or boost needs to spawn
	if(newType == 0)
	{
		// An Obstacle will spawn
		if(obstacleTimer <= 0)
		{
			// Setting the type to obstacle type.
			newType = 4;
			// Random position between 25% to 75%
			obstaclePosition = ((maxBlocks / 2) - 1) * 16 + 160; //floorf((newSize.width * 0.015625) + RANDOM(maxPos)) * 16;
			obstacleTimer = 1 + RANDOM(5);
		}
		else if(boostTimer <= 0)
		{
			// Setting the type to a boost type
			newType = 5;
			// Random position between 25% to 75%
			boostPosition = ((maxBlocks / 2) - 1) * 16 + 160; 
			boostTimer = 10 + RANDOM(10);
		}
		else
		{
			obstacleTimer--;
			boostTimer--;
		}
		
		// ALWAYS MAKES ISLANDS, REMOVE ASAP
		//newType = 0;
	}
	// Whale
	else if(newType == 1)
	{
		maxBlocks = 1;
	}
	// Sinking Ship
	else if(newType == 2)
	{
		//NSLog(@"Is Ship");
	}
	// Bomb
	else if(newType == 3)
	{
		//((maxBlocks / 2) - 1) * 16 + 160
		
		bombPosition = ((maxBlocks / 2) - 1) * 16 + 160; 
	}
	
	[self setIslandType:newType];
	[self setPosition:newPosition];
	[self setSize:newSize];
	
	[imageBlocks removeAllObjects];
	Image* imageBlock;
	for(int i = 0; i < maxBlocks; i++)
	{
		// If Normal, Bomb, Slow, Speed.
		if(islandType == 0 || islandType == 3 || islandType == 4 || islandType == 5)
		{
			// Start Block
			if(i == 0)
			{
				imageBlock = [[Image alloc] initWithImageNamed:@"IslandBegin"];
				[imageBlock setRotation:90];
				[imageBlocks addObject:imageBlock];
			}
			// End Block
			else if(i == maxBlocks - 1)
			{
					imageBlock = [[Image alloc] initWithImageNamed:@"IslandEnd"];
					[imageBlock setRotation:90];
					[imageBlocks addObject:imageBlock];
			}
			// Lava Block
			else if(islandType == 3 && i == (maxBlocks / 2) - 1)
			{
				imageBlock = [[Image alloc] initWithImageNamed:@"IslandLava"];
				[imageBlock setRotation:90];
				[imageBlocks addObject:imageBlock];
			}
			// Mud Block
			else if(islandType == 4 && i == (maxBlocks / 2) - 1)
			{
				imageBlock = [[Image alloc] initWithImageNamed:@"IslandMud"];
				[imageBlock setRotation:90];
				[imageBlocks addObject:imageBlock];
			}
			// Mud Block
			else if(islandType == 5 && i == (maxBlocks / 2) - 1)
			{
				imageBlock = [[Image alloc] initWithImageNamed:@"IslandShip"];
				[imageBlock setRotation:90];
				[imageBlocks addObject:imageBlock];
			}
			// Doing a Normal Block
			else
			{
				imageBlock = [[Image alloc] initWithImageNamed:@"IslandEmpty"];
				[imageBlock setRotation:90];
				[imageBlocks addObject:imageBlock];
			}
		}
		// If Whale
		else if(islandType == 1)
		{
			imageBlock = [[Image alloc] initWithImageNamed:@"Whale"];
			[imageBlock setRotation:90];
			[imageBlocks addObject:imageBlock];
		}
		// If Ship
		else if(islandType == 2)
		{
			// Start Block
			if(i == 0)
			{
				imageBlock = [[Image alloc] initWithImageNamed:@"ShipBegin"];
				[imageBlock setRotation:90];
				[imageBlocks addObject:imageBlock];
			}
			// End Block
			else if(i == maxBlocks - 1)
			{
				imageBlock = [[Image alloc] initWithImageNamed:@"ShipEnd"];
				[imageBlock setRotation:90];
				[imageBlocks addObject:imageBlock];
			}
			// Doing a Normal Block
			else
			{
				imageBlock = [[Image alloc] initWithImageNamed:@"ShipMid"];
				[imageBlock setRotation:90];
				[imageBlocks addObject:imageBlock];
			}
		}
	}
}

#define SensitivityY 0.10
#define SensitivityX 0.05

// Applies modified player's velocity to the ground
- (void) applyVelocity:(CGPoint)velocity
{
	position.x -= velocity.x * SensitivityX;
	position.y -= velocity.y * SensitivityY;
	
	if(islandType == 2 && isCollasping)
		position.y -= collaspingSpeed;
	
	// If the ground has exceeded its width and is off the screen, kill it.
	if(position.x <= size.width * -1)
	{
		//NSLog(@"Ground Object has died");
		//NSLog(@"Old Ground Object: Pos(%f, %f), Size(%f, %f)", position.x, position.y, size.width, size.height);
		isAlive = FALSE;
	}
}

#define forgivenessLedge 12
// Collision Check Method, 
- (BOOL) hasCollidedWithPlayer:(SideScrollerPlayerObject*)player
{
	CGPoint playerPosition = [player position];
	CGPoint velocity = [player velocity];
	
	// Checking to see if player be in the area of the object
	if(playerPosition.x > position.x - forgivenessLedge && playerPosition.x < position.x + size.width + forgivenessLedge)
	{
		// The player has entered the area of the this ground;
		// Checking to see if player is above ground; 
		// Reducing ground by -1 to accomidate inaccurate velocity settings;
		if(playerPosition.y >= position.y - 1)
		{
			// If the island type is ship, the player is atleast 25% into it and it has not began collasping, do so
			if(islandType == 2 && !isCollasping && playerPosition.x > position.x /*+ (size.width + forgivenessLedge) * 0.10*/)
			{
				isCollasping = TRUE;
				collaspingSpeed = velocity.x * 0.005;
				if(collaspingSpeed < 1)
					collaspingSpeed = 1;
			}
			
			// Checks if the player is considered on the ground
			if([player onGround])
			{
				// The player is on the ground checking the height
				if(playerPosition.y < position.y + 1 && playerPosition.y > position.y - 1)
				{
					//NSLog(@"Player is on the ground.");
					// The player is on the ground.
					// Set the positions to be exact
					playerPosition.y = position.y;
					
					// Checking if the player triggered the bomb. Since they are on the ground.
					if(islandType == 3 && playerPosition.x > position.x + bombPosition && 
					   playerPosition.x < position.x + bombPosition + 16)
					{
						// The player has hit the bomb.
						[player setIsAlive:FALSE];
					}
					
					// Checking if the player triggered the obstacle. Since they are on the ground.
					if(islandType == 4 && playerPosition.x > position.x + obstaclePosition && 
					   playerPosition.x < position.x + obstaclePosition + 16)
					{
						// The player has hit the obstacle.
						velocity.x *= 0.80;
						// Since the obstacle has been hit change the island type.
						// This will prevent a double hit of the obstacle.
					}
					
					// Checking if the player triggered the boost. Since they are on the ground.
					if(islandType == 5 && playerPosition.x > position.x + boostPosition && 
					   playerPosition.x < position.x + boostPosition + 16)
					{
						// The player has hit the boost.
						// Since the obstacle has been hit change the island type.
						// This will prevent a double hit of the obstacle.
						[player setIsFlying:TRUE];
						[player setTimerFlying:10];
						boostPosition = -100;
					}
				}
				else if(isCollasping)
				{
					// The player is on the ground checking the height
					if(playerPosition.y < position.y + 3 && playerPosition.y > position.y - 3)
					{
						//NSLog(@"Player is on the collasping ground.");
						// The player is on the ground.
						// Set the positions to be exact
						playerPosition.y = position.y;
					}
				}
				else 
				{
					NSLog(@"Player is too high above ground to not be falling.");
					// The player is too high above ground to be considered on the ground.
					[player setOnGround:FALSE];
					// Prevents the player from attempting a escape jump
					[player setCanDoubleJump:FALSE];
				}
			}
			else 
			{
				// The player is not on the ground, player might be falling
				// perform a velocity check to make sure he wont pass through it
				
				// Checking to see if player will enter ground when velocity is applied;
				if(playerPosition.y + velocity.y < position.y - (velocity.y * SensitivityY))
				{
					//NSLog(@"Player will enter the ground adjusting Velocity.");
					// The player will be in the ground;
					// Set the velocity.y to V = (G-P)/(S+1)
					// This will make them meet right on the ground surface; Within pixel of accuracy;
					velocity.y = (position.y - playerPosition.y) / (SensitivityY + 1);
					//velocity.y = (20 * (position.y - playerPosition.y)) / 21;
					//NSLog(@"Y Velocity is now: %F", velocity.y);
					// Also Resetting jump variables as its jump is coming to an end
					[player setOnGround:TRUE];
					[player setCanDoubleJump:TRUE];
				}
				else 
				{
					//NSLog(@"Player will not be entering the ground.");
					// The player is above the ground and at a safe distance we wont pass through it.
				}

			}
		}
		else 
		{
			NSLog(@"Player is under the ground.");
			// Setting player position to position x
			playerPosition.x = position.x - 24;
			// Setting the x velocity to 0 so it will not enter the ground
			velocity.x = 0;
			// The player hit the side of the ground and will begin to fall
			[player setOnGround:FALSE];
			// Prevents the player from attempting a last second jump when hes falling to death.
			[player setCanDoubleJump:FALSE];
		}
		// Sets the player's position and velocity to their new values.
		[player setPosition:playerPosition];
		[player setVelocity:velocity];
		return TRUE;
	}
	else 
	{
		// The player is not in the area where the object is
		// Do Nothing..
	}
	return FALSE;
}

// Renders the ground object
- (void) render
{
	//NSLog(@"Rendering");
	CGPoint blockPoint;
	
	// +16 Difference Whale
	// -84 difference Ship
	
	for(int i = 0; i < [imageBlocks count]; i++)
	{
		if(islandType == 0)
		{
			// Render First Block
			if(i == 0)
			{
				blockPoint.x = position.x;
				blockPoint.y = position.y - 136;
				
				if(blockPoint.x > -160 && blockPoint.x < 480)
				{
					blockPoint = CGPointPortraitToLandscape(blockPoint);
					[[imageBlocks objectAtIndex:i] renderAtPoint:blockPoint centerOfImage:FALSE];
				}
			}
			// Render Last Block
			else if(i == ([imageBlocks count] - 1) )
			{
				blockPoint.x = position.x + (i - 1) * 16 + 160;
				blockPoint.y = position.y - 136;
				
				if(blockPoint.x > -160 && blockPoint.x < 480)
				{
					blockPoint = CGPointPortraitToLandscape(blockPoint);
					[[imageBlocks objectAtIndex:i] renderAtPoint:blockPoint centerOfImage:FALSE];
				}
			}
			// Render Mid Blocks
			else
			{
				blockPoint.x = position.x + (i - 1) * 16 + 160;
				blockPoint.y = position.y - 136;
				
				if(blockPoint.x > -16 && blockPoint.x < 480)
				{
					blockPoint = CGPointPortraitToLandscape(blockPoint);
					[[imageBlocks objectAtIndex:i] renderAtPoint:blockPoint centerOfImage:FALSE];
				}
			}	
		}
		else if(islandType == 1)
		{
			blockPoint.x = position.x;
			blockPoint.y = position.y - 16;
			blockPoint = CGPointPortraitToLandscape(blockPoint);
			[[imageBlocks objectAtIndex:i] renderAtPoint:blockPoint centerOfImage:FALSE];
		}
		else if(islandType == 2)
		{
			// Render First Block
			if(i == 0)
			{
				blockPoint.x = position.x;
				blockPoint.y = position.y - 80;
				if(blockPoint.x > -160 && blockPoint.x < 480)
				{
					blockPoint = CGPointPortraitToLandscape(blockPoint);
					[[imageBlocks objectAtIndex:i] renderAtPoint:blockPoint centerOfImage:FALSE];
				}
			}
			// Render Last Block
			else if(i == ([imageBlocks count] - 1) )
			{
				blockPoint.x = position.x + (i - 1) * 16 + 160;
				blockPoint.y = position.y - 80;
				if(blockPoint.x > -160 && blockPoint.x < 480)
				{
					blockPoint = CGPointPortraitToLandscape(blockPoint);
					[[imageBlocks objectAtIndex:i] renderAtPoint:blockPoint centerOfImage:FALSE];
				}
			}
			// Render Mid Blocks
			else
			{
				blockPoint.x = position.x + (i - 1) * 16 + 160;
				blockPoint.y = position.y - 80;
				if(blockPoint.x > -16 && blockPoint.x < 480)
				{
					blockPoint = CGPointPortraitToLandscape(blockPoint);
					[[imageBlocks objectAtIndex:i] renderAtPoint:blockPoint centerOfImage:FALSE];
				}
			}
		}
		else if(islandType == 3 || islandType == 4 || islandType == 5)
		{
			// Render First Block
			if(i == 0)
			{
				blockPoint.x = position.x;
				blockPoint.y = position.y - 128;
				if(blockPoint.x > -160 && blockPoint.x < 480)
				{
					blockPoint = CGPointPortraitToLandscape(blockPoint);
					[[imageBlocks objectAtIndex:i] renderAtPoint:blockPoint centerOfImage:FALSE];
				}
			}
			// Render First Half.
			else if(i < ([imageBlocks count] / 2) - 1)
			{
				blockPoint.x = position.x + (i - 1) * 16 + 160;
				blockPoint.y = position.y - 128;
				if(blockPoint.x > -16 && blockPoint.x < 480)
				{
					blockPoint = CGPointPortraitToLandscape(blockPoint);
					[[imageBlocks objectAtIndex:i] renderAtPoint:blockPoint centerOfImage:FALSE];
				}
			}
			// Render Mid.
			else if(i == ([imageBlocks count] / 2) - 1)
			{
				blockPoint.x = position.x + (i - 1) * 16 + 160;
				blockPoint.y = position.y - 128;
				if(blockPoint.x > -48 && blockPoint.x < 480)
				{
					blockPoint = CGPointPortraitToLandscape(blockPoint);
					[[imageBlocks objectAtIndex:i] renderAtPoint:blockPoint centerOfImage:FALSE];
				}
			}
			// Render Last Block
			else if(i == ([imageBlocks count] - 1) )
			{
				blockPoint.x = position.x + (i - 2) * 16 + 160 + 48;
				blockPoint.y = position.y - 128;
				if(blockPoint.x > -160 && blockPoint.x < 480)
				{
					blockPoint = CGPointPortraitToLandscape(blockPoint);
					[[imageBlocks objectAtIndex:i] renderAtPoint:blockPoint centerOfImage:FALSE];
				}
			}
			// Render Last Half.
			else
			{
				blockPoint.x = position.x + (i - 2) * 16 + 160 + 48;
				blockPoint.y = position.y - 128;
				if(blockPoint.x > -16 && blockPoint.x < 480)
				{
					blockPoint = CGPointPortraitToLandscape(blockPoint);
					[[imageBlocks objectAtIndex:i] renderAtPoint:blockPoint centerOfImage:FALSE];
				}
			}
		}
	}
	/*
	CGPoint blockPoint;
	for(int i = 0; i < size.width / 16; i++)
	{
		blockPoint.x = position.x + i * 16;
		// Renders only the visible blocks
		if(blockPoint.x > -16 && blockPoint.x < 496)
		{
			blockPoint.y = position.y - 144;
			blockPoint = CGPointPortraitToLandscape(blockPoint);
			
			if(i <= 15)
			{
				// Only the first needs to draw it.
				if(i == 0)
				{
					[[imageBlocks objectAtIndex:i] renderAtPoint:blockPoint centerOfImage:FALSE];
				}
			}
			else if(i >= (size.width / 16) - 16)
			{
				if(i == (size.width / 16) - 16)
				{
					[[imageBlocks objectAtIndex:i] renderAtPoint:blockPoint centerOfImage:FALSE];
				}
			}
			else 
			{
				[[imageBlocks objectAtIndex:i] renderAtPoint:blockPoint centerOfImage:FALSE];
			}
		}
	}
	 */
}
@end

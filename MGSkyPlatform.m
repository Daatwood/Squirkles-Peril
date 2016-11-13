//
//  MGSkyPlatform.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 2/15/11.
//  Copyright 2011 Litlapps. All rights reserved.
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
- (id) initWithType:(int)type atPosition:(CGPoint)pos withMovementDirection:(int)direction
{
	if((self = [super init]))
	{
		typePlatform = type;
		positionPlatform = pos;
		
		readyForDeletion = FALSE;
		isUsable = TRUE;
		earnedPoints = FALSE;
		supportedJumps = 2 + RANDOM(2);
		movementDirection = direction;
		yOffset = 0;
        
		switch (typePlatform) 
		{
				
			case PlatformType_Normal:
			{
				awardPoints = 5;
				shape = Shape_Circle;
				break;
			}
			case PlatformType_Fake:
			{
				isUsable = FALSE;
				awardPoints = 0;
				shape = Shape_Square;
				break;
			}
			case PlatformType_Dissolve:
			{
				awardPoints = 7;
				supportedJumps = 1;
				shape = Shape_Triangle;
                yOffset += 68.5;
				break;
			}
			case PlatformType_Bouncy:
			{
				supportedJumps--;
				awardPoints = 7;
				shape = Shape_Diamond;
				break;
			}
			case PlatformType_FlyThru:
			{
				awardPoints = 5;
				supportedJumps = 1;
				shape = Shape_Star;
				break;
			}
			case PlatformType_Absorb:
			{
				awardPoints = 0;
				isUsable = FALSE;
				supportedJumps = 1;
				shape = Shape_Oddity;
				break;
			}
			default:
				break;
		}
		colorPlatform = Color4fFromShapeLevel(shape);
		
		imagesPlatform = [[NSMutableArray alloc] initWithCapacity:1];
		Image* imagePlatform;
		// Load Left End Cap
		imagePlatform = [[ResourceManager sharedResourceManager] 
						 getImageWithImageNamed:@"CapLeft32" 
						 withinAtlasNamed:@"ShapesAtlas"];
		[imagePlatform setColourWithColor4f:colorPlatform];
		[imagesPlatform addObject:imagePlatform];
		[imagePlatform release];
        
        // Load Right End Cap
		imagePlatform = [[ResourceManager sharedResourceManager] 
						 getImageWithImageNamed:@"CapRight32" 
						 withinAtlasNamed:@"ShapesAtlas"];
		[imagePlatform setColourWithColor4f:colorPlatform];
		[imagesPlatform addObject:imagePlatform];
		[imagePlatform release];
		
		// Load Mid Section
		imagePlatform = [[ResourceManager sharedResourceManager] 
						 getImageWithImageNamed:NSStringFromShapeLevel(shape)
						 withinAtlasNamed:@"ShapesAtlas"];
		[imagePlatform setColourWithColor4f:colorPlatform];
		[imagesPlatform addObject:imagePlatform];
		[imagePlatform release];
        
	}
	return self;
}

// Reset the Platform
- (void) resetWithType:(int)type atPosition:(CGPoint)pos withMovementDirection:(int)direction
{
	typePlatform = type;
	positionPlatform = pos;
	
	readyForDeletion = FALSE;
	isUsable = TRUE;
	earnedPoints = FALSE;
	supportedJumps = 2 + RANDOM(2);
	movementDirection = direction;
    yOffset = 0;
	
	switch (typePlatform) 
	{
			
		case PlatformType_Normal:
		{
			awardPoints = 5;
			shape = Shape_Circle;
			break;
		}
		case PlatformType_Fake:
		{
			isUsable = FALSE;
			awardPoints = 0;
			shape = Shape_Square;
			break;
		}
		case PlatformType_Dissolve:
		{
			awardPoints = 7;
			supportedJumps = 1;
			shape = Shape_Triangle;
            yOffset += 68.5;
			break;
		}
		case PlatformType_Bouncy:
		{
			supportedJumps--;
			awardPoints = 7;
			shape = Shape_Diamond;
			break;
		}
		case PlatformType_FlyThru:
		{
			awardPoints = 5;
			supportedJumps = 1;
			shape = Shape_Star;
			break;
		}
		case PlatformType_Absorb:
		{
			awardPoints = 0;
			isUsable = FALSE;
			supportedJumps = 1;
			shape = Shape_Oddity;
			break;
		}
		default:
			break;
	}
	colorPlatform = Color4fFromShapeLevel(shape);
	
	[imagesPlatform removeObjectAtIndex:2];
    Image* imagePlatform;
	// Load Mid Section
	imagePlatform = [[ResourceManager sharedResourceManager] 
					 getImageWithImageNamed:NSStringFromShapeLevel(shape)
					 withinAtlasNamed:@"ShapesAtlas"];
	[imagePlatform setColourWithColor4f:colorPlatform];
	[imagesPlatform addObject:imagePlatform];
	[imagePlatform release];
    
    [[imagesPlatform objectAtIndex:0] setColourWithColor4f:colorPlatform];
    [[imagesPlatform objectAtIndex:1] setColourWithColor4f:colorPlatform];
}

- (void)dealloc 
{
    //NSLog(@"Dealloc..");
	[imagesPlatform release];
	imagesPlatform = nil;
	
	[super dealloc];
}

// Kills the Platform
- (void) die
{
	// Play Death Sound
	// Adjust Variables
	isUsable = FALSE;
}

// Update's the Platform
- (BOOL) updateWithDelta:(GLfloat)delta givenPlayer:(MGSkyPlayer*)player
{
	if(readyForDeletion)
		return false;
	if(!isUsable && typePlatform != PlatformType_Fake)
		readyForDeletion = TRUE;
    
    [platformExplosion update:delta];
	
	switch (movementDirection) 
	{
		case -1:
		{
			if(typePlatform == PlatformType_Dissolve)
				positionPlatform.x += (1 + RANDOM_0_TO_1()) * 3 * (1 + delta);
			else
				positionPlatform.x += (1 + RANDOM_0_TO_1()) * (1 + delta);
			break;
		}
		case 1:
		{
			if(typePlatform ==PlatformType_Dissolve)
				positionPlatform.x -= (1 + RANDOM_0_TO_1()) * 3 * (1 + delta);
			else
				positionPlatform.x -= (1 + RANDOM_0_TO_1()) * (1 + delta);
			break;
		}
		default:
			break;
	}
	
	// Wrapping Check
	if(positionPlatform.x < -320)
		positionPlatform.x = positionPlatform.x + 320 + 640;
	else if(positionPlatform.x > 640)
		positionPlatform.x = positionPlatform.x - 640 - 320;
	
	// Collision Check only if isUsable
	if(isUsable)
    {
        if(player == nil)
            return true;
		else
            return [self hasCollidedWithPlayer:player withDelta:delta];
    }
    else
        return false;
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
	if(positionPlatform.y < -100)
	{
       // NSLog(@"Marked For Deletion");
		//[self die];
		//if(typePlatform == PlatformType_Fake || typePlatform == PlatformType_Absorb)
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
	
	int points = floorf(awardPoints / (supportedJumps + 1));
	awardPoints -= points;
	earnedPoints = FALSE;
    return points;
}

- (void) makeExplosion
{
    /*
    platformExplosion = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"imageStar"
                                                                               position:Vector2fMake(positionPlatform.x, 
                                                                                                     positionPlatform.y)
                                                                 sourcePositionVariance:Vector2fMake(0,0)
                                                                                  speed:60.0f
                                                                          speedVariance:30.0f
                                                                       particleLifeSpan:0.4f	
                                                               particleLifespanVariance:0.3f
                                                                                  angle:0.0f  
                                                                          angleVariance:360.0f
                                                                                gravity:Vector2fMake(0.0f, -20.0f)
                                                                             startColor:colorPlatform
                                                                     startColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
                                                                            finishColor:Color4fMake(colorPlatform.red, colorPlatform.green, colorPlatform.blue, 0.0f)  
                                                                    finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
                                                                           maxParticles:10
                                                                           particleSize:50
                                                                   particleSizeVariance:5
                                                                               duration:0.05
                                                                          blendAdditive:NO];
     */
}

#define playerSizeWidth 10

#define ExtraSpacing 16

// Collision Check Method
- (BOOL) hasCollidedWithPlayer:(MGSkyPlayer*)player withDelta:(GLfloat)delta
{
	CGPoint playerPosition = player.playerInfo.playerPosition;
	CGPoint velocity = player.playerInfo.playerVelocity;
	CGSize playerSize = player.sizePlayer;
	playerSize.height /= 2;
	velocity.x *= delta;
	velocity.y *= delta;
	
	float platformWidth = (32 + ExtraSpacing) + (32 * supportedJumps);
	float platformX = positionPlatform.x - (platformWidth / 2);

	// Check to see if the player is above or under the platform
	// Adding a total of 26 to the platform to accomodate the player width
	if(playerPosition.x + playerSize.width > platformX && 
	   playerPosition.x - playerSize.width < platformX + platformWidth)
	{
		// The player has entered the area of the this ground;
		// Checking to see if player is above ground; 
		if(playerPosition.y >= (positionPlatform.y + yOffset))
		{
			// Checking to see if player will hit ground when velocity is applied;
			if(playerPosition.y - playerSize.height + velocity.y < (positionPlatform.y + yOffset )- velocity.y)
			{
				earnedPoints = YES;
				
				switch (typePlatform) 
				{
					case PlatformType_Bouncy:
					{
						if([player applySuperJump] && supportedJumps > 0)
                        {
							supportedJumps--;
                            playerPosition.y = positionPlatform.y + 75+yOffset;
                            [player setPositionTo:playerPosition];
                        }
						
						break;
					}
					case PlatformType_FlyThru:
					{
						if([player applyBoost] && supportedJumps > 0)
                        {
							supportedJumps--;
                            playerPosition.y = positionPlatform.y + 75+yOffset;
                            [player setPositionTo:playerPosition];
                        }
						break;
					}
					case PlatformType_Fake:
					{
						// Don't Do Anything
						earnedPoints = NO;
						break;
					}
					case PlatformType_Absorb:
					{
						// Don't Do Anything
						earnedPoints = NO;
						break;
					}
					default:
					{
						// If type not found just normal jump
						if([player applyJump] && supportedJumps > 0)
                        {
							supportedJumps--;
                            playerPosition.y = positionPlatform.y + 75+yOffset;
                            [player setPositionTo:playerPosition];
                        }
						break;
					}
				}
				
				if(supportedJumps <= 0)
					[self die];
			}
			// The will not hit the ground
			else 
			{
				
				// Do Nothing...
				earnedPoints = NO;
			}
		}
		else 
		{
			// Checking to see if player will hit under the obstacle when velocity is applied;
			if(playerPosition.y + playerSize.height + velocity.y > positionPlatform.y + yOffset- velocity.y)
			{
				earnedPoints = NO;
				if(typePlatform == PlatformType_FlyThru && supportedJumps > 0)
				{
					if([player applyBoost])
					{
						supportedJumps--;
						earnedPoints = YES;
					}
					
					if(supportedJumps <= 0)
						[self die];
				}
			}
			// The player is under the ground and wont hit next update
			else
			{
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
    
    return earnedPoints;
}

// Renders the Platform
- (void) renderWithinBounds:(CGSize)bounds;
{
	if(readyForDeletion)
		return;
	
	switch (supportedJumps) 
	{
		case 1:
		{
			if(positionPlatform.x + 24 + 32 + ExtraSpacing/2 < 0 || positionPlatform.x - 24 - 32 - ExtraSpacing/2 > bounds.width)
				return;
			
			[[imagesPlatform objectAtIndex:2] renderAtPoint:CGPointMake(positionPlatform.x, positionPlatform.y+yOffset) centerOfImage:YES];
			[[imagesPlatform objectAtIndex:0] renderAtPoint:CGPointMake(positionPlatform.x - 24 - ExtraSpacing/2, positionPlatform.y+yOffset) centerOfImage:YES];
			[[imagesPlatform objectAtIndex:1] renderAtPoint:CGPointMake(positionPlatform.x + 24 + ExtraSpacing/2, positionPlatform.y+yOffset) centerOfImage:YES];
			break;
		}
		case 2:
		{
			if(positionPlatform.x + 40 + 16 < 0 || positionPlatform.x - 40 - 16 > bounds.width)
				return;
			
			[[imagesPlatform objectAtIndex:2] renderAtPoint:CGPointMake(positionPlatform.x - 16, positionPlatform.y+yOffset) centerOfImage:YES];
			[[imagesPlatform objectAtIndex:2] renderAtPoint:CGPointMake(positionPlatform.x + 16, positionPlatform.y+yOffset) centerOfImage:YES];
			
			[[imagesPlatform objectAtIndex:0] renderAtPoint:CGPointMake(positionPlatform.x - 40 - ExtraSpacing/2, positionPlatform.y+yOffset) centerOfImage:YES];
			
			[[imagesPlatform objectAtIndex:1] renderAtPoint:CGPointMake(positionPlatform.x + 40 + ExtraSpacing/2, positionPlatform.y+yOffset) centerOfImage:YES];
			break;
		}
		case 3:
		{
			if(positionPlatform.x + 56 + 16 < 0 || positionPlatform.x - 56 - 16 > bounds.width)
				return;
			
			[[imagesPlatform objectAtIndex:2] renderAtPoint:CGPointMake(positionPlatform.x, positionPlatform.y+yOffset) centerOfImage:YES];
			[[imagesPlatform objectAtIndex:2] renderAtPoint:CGPointMake(positionPlatform.x - 32, positionPlatform.y+yOffset) centerOfImage:YES];
			[[imagesPlatform objectAtIndex:2] renderAtPoint:CGPointMake(positionPlatform.x + 32, positionPlatform.y+yOffset) centerOfImage:YES];
			
			[[imagesPlatform objectAtIndex:0] renderAtPoint:CGPointMake(positionPlatform.x - 56 - ExtraSpacing/2, positionPlatform.y+yOffset) centerOfImage:YES];
			
			[[imagesPlatform objectAtIndex:1] renderAtPoint:CGPointMake(positionPlatform.x + 56 + ExtraSpacing/2, positionPlatform.y+yOffset) centerOfImage:YES];
			break;
		}
		default:
			break;
	}
    [platformExplosion renderParticles];
}

@end

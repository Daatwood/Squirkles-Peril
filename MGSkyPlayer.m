//
//  MGSkyPlayer.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 2/16/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import "MGSkyPlayer.h"

#define indexDown 0
#define indexUp 1
#define indexOther 2

@implementation MGSkyPlayer
@synthesize playerInfo, playerSetup, sizePlayer;
@synthesize isAlive, isBoosting, readyForDeletion;

// Initializes the player
- (id) init
{
	if((self = [super init]))
	{
		imagesBody = [[NSMutableArray alloc] initWithCapacity:1];
		imagesEyes = [[NSMutableArray alloc] initWithCapacity:1];
		imagesAntenna = [[NSMutableArray alloc] initWithCapacity:1];
        [self reset];
        //playerInfo.playerPosition = CGPointMake(100, 240);
        //isAlive = FALSE;
	}
	return self;
}

- (void)dealloc 
{
	[imagesBody release];
	imagesBody = nil;
	[imagesEyes release];
	imagesEyes = nil;
	[imagesAntenna release];
	imagesAntenna = nil;
	
	[emitter release];
	emitter = nil;
	
	[super dealloc];
}

- (void) adjustImages
{
    Image* petImage;
    
    // Release
    [imagesBody removeAllObjects];
    
    petImage = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"BodyFall" 
                                                              withinAtlasNamed:[NSString stringWithFormat:@"%@Atlas",playerSetup.playerBody]];//[[Image alloc] initWithImageNamed:@"Shelby-BodyFall"];
    [petImage setColourWithColor4f:playerSetup.playerColor];
    [petImage setScale:0.50];
    [imagesBody addObject:petImage];
    [petImage release];
    petImage = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"BodyRise" 
                                                              withinAtlasNamed:[NSString stringWithFormat:@"%@Atlas",playerSetup.playerBody]];
    [petImage setColourWithColor4f:playerSetup.playerColor];
    [petImage setScale:0.50];
    [imagesBody addObject:petImage];
    [petImage release];
	
    
    // Setup Antenna
    [imagesAntenna removeAllObjects];
    petImage = [[ResourceManager sharedResourceManager] getImageWithImageNamed:[NSString stringWithFormat:@"%@Stand",playerSetup.playerAntenna] 
                                                              withinAtlasNamed:[NSString stringWithFormat:@"%@Atlas",playerSetup.playerBody]];
    [petImage setScale:0.50];
    [petImage setColourWithColor4f:playerSetup.playerColor];
    [imagesAntenna addObject:petImage];
    [petImage release];
    petImage = [[ResourceManager sharedResourceManager] getImageWithImageNamed:[NSString stringWithFormat:@"%@Fall",playerSetup.playerAntenna] 
                                                              withinAtlasNamed:[NSString stringWithFormat:@"%@Atlas",playerSetup.playerBody]];
    [petImage setScale:0.50];
    [petImage setColourWithColor4f:playerSetup.playerColor];
    [imagesAntenna addObject:petImage];
    [petImage release];
	
    
    // Setup Eyes
    [imagesEyes removeAllObjects];
    
    petImage = [[ResourceManager sharedResourceManager] getImageWithImageNamed:[NSString stringWithFormat:@"%@Fall",playerSetup.playerEyes] 
                                                              withinAtlasNamed:[NSString stringWithFormat:@"%@Atlas",playerSetup.playerBody]];
    [petImage setScale:0.50];
    [imagesEyes addObject:petImage];
    [petImage release];
    petImage  = [[ResourceManager sharedResourceManager] getImageWithImageNamed:[NSString stringWithFormat:@"%@Rise",playerSetup.playerEyes] 
                                                               withinAtlasNamed:[NSString stringWithFormat:@"%@Atlas",playerSetup.playerBody]];
    [petImage setScale:0.50];
    [imagesEyes addObject:petImage];
    [petImage release];
}

// Antenna, Eyes, Colors
- (void) adjustImagesBodyType:(NSString*)bodyType
					   Antenna:(NSString*)antennaImage 
						  eyes:(NSString*)eyesImage 
						 color:(NSString*)colorString
{
	// Proper color strings are denoted with braces  
	if ([colorString hasPrefix:@"{"] && [colorString hasSuffix:@"}"])
	{
		// Remove braces      
		colorString = [colorString substringFromIndex:1];  
		colorString = [colorString substringToIndex:([colorString length] - 1)];  
		
		// Separate into components by removing commas and spaces  
		NSArray *components = [colorString componentsSeparatedByString:@", "];
		
		if ([components count] == 3) 
		{
			playerSetup.playerColor = Color4fMake([[components objectAtIndex:0] floatValue], 
									  [[components objectAtIndex:1] floatValue], 
									  [[components objectAtIndex:2] floatValue], 
									  1.0);
		}
	}
	
	Image* petImage;
    
    if([bodyType isEqualToString:@"(null)"] || bodyType == nil || [bodyType isEqualToString:@"1000"])
		bodyType = [NSString stringWithString:@"Squirkle"];
    
    // Release 
    [playerSetup.playerBody release];
    [imagesBody removeAllObjects];
    
    playerSetup.playerBody = [NSString stringWithString:bodyType];
    
    petImage = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"BodyFall" 
                                                              withinAtlasNamed:[NSString stringWithFormat:@"%@Atlas",bodyType]];//[[Image alloc] initWithImageNamed:@"Shelby-BodyFall"];
    [petImage setColourWithColor4f:playerSetup.playerColor];
    [petImage setScale:0.50];
    [imagesBody addObject:petImage];
    [petImage release];
    petImage = [[ResourceManager sharedResourceManager] getImageWithImageNamed:@"BodyRise" 
                                                              withinAtlasNamed:[NSString stringWithFormat:@"%@Atlas",bodyType]];
    [petImage setColourWithColor4f:playerSetup.playerColor];
    [petImage setScale:0.50];
    [imagesBody addObject:petImage];
    [petImage release];
	

    // Setup Antenna
    [imagesAntenna removeAllObjects];
    [playerSetup.playerAntenna release];
    
    playerSetup.playerAntenna = [NSString stringWithString:antennaImage];
    
    petImage = [[ResourceManager sharedResourceManager] getImageWithImageNamed:[NSString stringWithFormat:@"%@Stand",antennaImage] 
                                                              withinAtlasNamed:[NSString stringWithFormat:@"%@Atlas",bodyType]];
    [petImage setScale:0.50];
    [petImage setColourWithColor4f:playerSetup.playerColor];
    [imagesAntenna addObject:petImage];
    [petImage release];
    petImage = [[ResourceManager sharedResourceManager] getImageWithImageNamed:[NSString stringWithFormat:@"%@Fall",antennaImage] 
                                                              withinAtlasNamed:[NSString stringWithFormat:@"%@Atlas",bodyType]];
    [petImage setScale:0.50];
    [petImage setColourWithColor4f:playerSetup.playerColor];
    [imagesAntenna addObject:petImage];
    [petImage release];
	
    
    // Setup Eyes
    [imagesEyes removeAllObjects];
    [playerSetup.playerEyes release];
    
    playerSetup.playerEyes = [NSString stringWithString:eyesImage];
    
    petImage = [[ResourceManager sharedResourceManager] getImageWithImageNamed:[NSString stringWithFormat:@"%@Fall",eyesImage] 
                                                              withinAtlasNamed:[NSString stringWithFormat:@"%@Atlas",bodyType]];
    [petImage setScale:0.50];
    [imagesEyes addObject:petImage];
    [petImage release];
    petImage  = [[ResourceManager sharedResourceManager] getImageWithImageNamed:[NSString stringWithFormat:@"%@Rise",eyesImage] 
                                                                 withinAtlasNamed:[NSString stringWithFormat:@"%@Atlas",bodyType]];
    [petImage setScale:0.50];
    [imagesEyes addObject:petImage];
    [petImage release];
}


#define MaxPetVelocity 300
#define MinPetVelocity 200
#define ShipPetTime 5

// Resets the player back to starting variables;
- (void) reset
{
	if(emitter)
	{
		[emitter release];
		emitter = nil;
	}
	
	isAlive = TRUE;
	isBoosting = FALSE;
	readyForDeletion = FALSE;
	boostTimer = 0;
	playerInfo.playerTilt = 0;
	playerInfo.playerPosition = CGPointMake(160, 0);
	playerInfo.playerVelocity = CGPointMake(0, MaxPetVelocity);	
}

// Spawns Jumping Effect
- (void) createJumpEffect
{
	if(readyForDeletion || !isAlive)
		return;
	
	emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"imageStar"
																	   position:Vector2fMake(playerInfo.playerPosition.x, 
																							 playerInfo.playerPosition.y)
														 sourcePositionVariance:Vector2fMake(0,0)
																		  speed:60.0f
																  speedVariance:30.0f
															   particleLifeSpan:0.4f	
													   particleLifespanVariance:0.3f
																		  angle:270.0f
																  angleVariance:90.0f
																		gravity:Vector2fMake(0.0f, -20.0f)
																	 startColor:playerSetup.playerColor
															 startColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
																	finishColor:Color4fMake(playerSetup.playerColor.red, 
                                                                                            playerSetup.playerColor.green, 
                                                                                            playerSetup.playerColor.blue, 0.0f)  
															finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
																   maxParticles:50
																   particleSize:10
														   particleSizeVariance:5
																	   duration:0.05
																  blendAdditive:YES];
     
}

- (void) setVelocityTo:(CGPoint)newVelocity
{
    playerInfo.playerVelocity = newVelocity;
}

- (void) setPositionTo:(CGPoint)newPosition
{
    playerInfo.playerPosition = newPosition;
}

// Initiates a normal jump;
- (BOOL) applyJump
{
	if(readyForDeletion || !isAlive)
		return FALSE;
	
	// If Apply is true and the player is falling then apply a new velocity.
	if(playerInfo.playerVelocity.y < 0)
	{
        [[SoundManager sharedSoundManager] playSoundWithKey:@"JumpShortSound" gain:1.0f pitch:1.0f location:Vector2fZero shouldLoop:NO sourceID:-1];
		playerInfo.playerVelocity.y = (MaxPetVelocity + MinPetVelocity) / 2;
		[self createJumpEffect];
		return TRUE;
	}
	return FALSE;
}

// Initiates a Small jump
- (BOOL) applySmallJump
{
	if(readyForDeletion || !isAlive)
		return FALSE;
	
	// If Apply is true and the player is falling then apply a new velocity.
	if(playerInfo.playerVelocity.y < 0)
	{
        [[SoundManager sharedSoundManager] playSoundWithKey:@"JumpShortSound" gain:1.0f pitch:1.0f location:Vector2fZero shouldLoop:NO sourceID:-1];
		playerInfo.playerVelocity.y = MinPetVelocity;
		[self createJumpEffect];
		return TRUE;
	}
	return FALSE;
}

// Initiates a Super jump
- (BOOL) applySuperJump
{
	if(readyForDeletion || !isAlive)
		return FALSE;
	
	// If Apply is true and the player is falling then apply a new velocity.
	if(playerInfo.playerVelocity.y < 0)
	{
        [[SoundManager sharedSoundManager] playSoundWithKey:@"JumpSound" gain:1.0f pitch:1.0f location:Vector2fZero shouldLoop:NO sourceID:-1];
		playerInfo.playerVelocity.y = MaxPetVelocity;
		[self createJumpEffect];
		return TRUE;
	}
	return FALSE;
}

// Boost provides speed reguardless of velocity
- (BOOL) applyBoost
{
	if(readyForDeletion || !isAlive)
		return FALSE;
	
	if (playerInfo.playerVelocity.y < 0)
		playerInfo.playerVelocity.y = 0;
	
    [[SoundManager sharedSoundManager] playSoundWithKey:@"JumpSound" gain:1.0f pitch:1.0f location:Vector2fZero shouldLoop:NO sourceID:-1];
	playerInfo.playerVelocity.y += MaxPetVelocity;
	[self createJumpEffect];
	return TRUE;
}

- (BOOL) applyFlyingJump
{
    return FALSE;
}

// Initiates a Ship
- (BOOL) applyShip
{
	if(readyForDeletion || !isAlive)
		return FALSE;
	
	if(isBoosting)
		return FALSE;
	
	isBoosting = TRUE;
	boostTimer += ShipPetTime;
	if(playerInfo.playerVelocity.y < MinPetVelocity)
		playerInfo.playerVelocity.y = MinPetVelocity;
	//[imageShipBack setAlpha:0.0];
	//[imageShipFront setAlpha:0.0];
	emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"imageParticleFire"
																	 position:Vector2fMake(playerInfo.playerPosition.x, 
																						   playerInfo.playerPosition.y-20)
													   sourcePositionVariance:Vector2fMake(0,0)
																		speed:60.0f
																speedVariance:30.0f
															 particleLifeSpan:0.4f	
													 particleLifespanVariance:0.3f
																		angle:270.0f
																angleVariance:90.0f
																	  gravity:Vector2fMake(0.0f, -20.0f)
																   startColor:Color4fMake(1.0f, 0.0f, 0.0f, 1.0f)
														   startColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
																  finishColor:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)  
														  finishColorVariance:Color4fMake(0.00f, 0.00, 0.00, 0.0f)
																 maxParticles:75
																 particleSize:10
														 particleSizeVariance:1
																	 duration:ShipPetTime
																blendAdditive:NO];
	return TRUE;
}



// Kills the player
- (void) die
{
	// Is Not already Marked For Deletion and is Not already Dead
	if(readyForDeletion || !isAlive)
		return;

	// Begin the Emitter;
	emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"imageStar"
																position:Vector2fMake(playerInfo.playerPosition.x, 
																					  playerInfo.playerPosition.y)
												  sourcePositionVariance:Vector2fMake(0,0)
																   speed:40.0f
														   speedVariance:20.0f
														particleLifeSpan:4.0f	
												particleLifespanVariance:1.0f
																   angle:0.0f
														   angleVariance:360.0f
																 gravity:Vector2fMake(0.0f, 0.0f)
															  startColor:playerSetup.playerColor
													  startColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
															 finishColor:Color4fMake(playerSetup.playerColor.red, playerSetup.playerColor.green, playerSetup.playerColor.blue, 0.0f)  
													 finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
															maxParticles:400
															particleSize:10
													particleSizeVariance:5
																duration:3.0
														   blendAdditive:YES];
	
	// Play Death Sound
	// NYI
	// Adjust Variables
	isAlive = FALSE;
    playerInfo.playerVelocity = CGPointZero;
}

// Update's the player
- (void) updateWithDelta:(GLfloat)delta
{
	if(readyForDeletion)
		return;
	
	if(emitter)
		[emitter update:delta];
    
	if(![emitter active] && !isAlive)
		readyForDeletion = TRUE;
	
	if(!isAlive)
		return;
	
	if(isBoosting)
	{
		[emitter setSourcePosition:Vector2fMake(playerInfo.playerPosition.x,
                                                playerInfo.playerPosition.y-20)];
		
		boostTimer -= delta;
		
		// The ship will slowly increase to the max velocity over the lifetime of the ship
		if (playerInfo.playerVelocity.y < 0) 
			playerInfo.playerVelocity.y += MaxPetVelocity;
		if(playerInfo.playerVelocity.y < MaxPetVelocity)
			playerInfo.playerVelocity.y += delta * ((MaxPetVelocity - MinPetVelocity) / ShipPetTime) * 2;
		else if(playerInfo.playerVelocity.y < MaxPetVelocity * 2)
			playerInfo.playerVelocity.y += delta * ((MaxPetVelocity - MinPetVelocity) / ShipPetTime);

		imageIndexBody = indexUp;
		imageIndexEyes = indexUp;
		imageIndexAntenna = indexUp;
		
		if(boostTimer < 0)
		{
			boostTimer = 0;
			isBoosting = FALSE;
			emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"imageShipPart"
																		position:Vector2fMake(playerInfo.playerPosition.x, 
																							  playerInfo.playerPosition.y)
														  sourcePositionVariance:Vector2fMake(0,0)
																		   speed:100.0f
																   speedVariance:25.0f
																particleLifeSpan:1.0f	
														particleLifespanVariance:0.0f
																		   angle:90.0f
																   angleVariance:270.0f
																		 gravity:Vector2fMake(0.0f, -10.0f)
																	  startColor:Color4fMake(0.25f, 0.55f, 0.13f, 1.0f)
															  startColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 1.0f)
																	 finishColor:Color4fMake(0.25f, 0.55f, 0.13f, 0.0f)  
															 finishColorVariance:Color4fMake(0.00f, 0.00, 0.00, 0.0f)
																	maxParticles:20
																	particleSize:20
															particleSizeVariance:1
																		duration:1.0f
																   blendAdditive:NO];
		}
	}
	else
	{
		if(playerInfo.playerVelocity.y > MaxPetVelocity)
			playerInfo.playerVelocity.y = MaxPetVelocity;
			
		float velocityLoss = delta * (MaxPetVelocity + MinPetVelocity) / 3;
		
		// Considered to be Jumping
		if(playerInfo.playerVelocity.y > 0)
		{
			// Decrease the velocity
			playerInfo.playerVelocity.y -= velocityLoss;
			
			// Check to see if will be falling
			if(playerInfo.playerVelocity.y == 0)
			{
				playerInfo.playerVelocity.y -= velocityLoss;
				fallingDistanceLeft = [Director sharedDirector].screenBounds.size.height;
			}
			
			imageIndexBody = indexUp;
			imageIndexEyes = indexUp;
			imageIndexAntenna = indexUp;
		}
		// Considered to be falling
		else if(playerInfo.playerVelocity.y <= 0)
		{
			if(playerInfo.playerPosition.y < -48)
			{
				[self die];
				return;
			}
			playerInfo.playerVelocity.y -= velocityLoss * 2.5;
			
			imageIndexBody = indexDown;
			imageIndexEyes = indexDown;
			imageIndexAntenna = indexDown;
		}
	}
}

// Applys accelerometer to the player.
- (BOOL) applyAccelerometer:(GLfloat)data
{
	if(readyForDeletion || !isAlive)
		return TRUE;
	
	playerInfo.playerTilt = data * 2;
	if (playerInfo.playerTilt > 20) 
		playerInfo.playerTilt = 20;
	if (playerInfo.playerTilt < -20) 
		playerInfo.playerTilt = -20;
	
	playerInfo.playerPosition.x += data;
	if(playerInfo.playerPosition.x < 101 + 12)// || inShip)
	{
		playerInfo.playerPosition.x -= data;
		// Could not apply accelerometer data
		return FALSE;
	}
	else if(playerInfo.playerPosition.x > 221 - 12)// || inShip)
	{
		playerInfo.playerPosition.x -= data;
		// Could not apply accelerometer data
		return FALSE;
	}
	return TRUE;
}

// Applys velocity to the platform
- (void) applyVelocity:(float)velocity
{
	if(readyForDeletion || !isAlive)
		return;
	
	if(velocity > 0)
	{
		playerInfo.playerPosition.y += velocity;
	}
	else if(velocity <= 0)
	{
		if(playerInfo.playerPosition.y > [Director sharedDirector].screenBounds.size.height * 0.25 || fallingDistanceLeft < 0)
			playerInfo.playerPosition.y += velocity;
		else
			fallingDistanceLeft += velocity;	
	}
}

// Render's the player
- (void) render
{
    [emitter renderParticles];
	if(isAlive)
	{
        [[imagesBody objectAtIndex:imageIndexBody] setRotation:playerInfo.playerTilt];
		[[imagesEyes objectAtIndex:imageIndexEyes] setRotation:playerInfo.playerTilt];
		[[imagesAntenna objectAtIndex:imageIndexAntenna] setRotation:playerInfo.playerTilt];
        
        [[imagesBody objectAtIndex:imageIndexBody] renderAtPoint:CGPointMake([[imagesBody objectAtIndex:imageIndexBody] positionImage].x / 2 + playerInfo.playerPosition.x, 
                                                                             [[imagesBody objectAtIndex:imageIndexBody] positionImage].y / 2 + playerInfo.playerPosition.y) centerOfImage:TRUE];
		[[imagesEyes objectAtIndex:imageIndexEyes] renderAtPoint:CGPointMake([[imagesEyes objectAtIndex:imageIndexEyes] positionImage].x / 2 + playerInfo.playerPosition.x, 
                                                                             [[imagesEyes objectAtIndex:imageIndexEyes] positionImage].y / 2 + playerInfo.playerPosition.y) centerOfImage:TRUE];
		[[imagesAntenna objectAtIndex:imageIndexAntenna] renderAtPoint:CGPointMake([[imagesAntenna objectAtIndex:imageIndexAntenna] positionImage].x / 2 + playerInfo.playerPosition.x, 
                                                                                   [[imagesAntenna objectAtIndex:imageIndexAntenna] positionImage].y / 2 + playerInfo.playerPosition.y) centerOfImage:TRUE];
	}
}

@end

//
//  MGSkyPlayer.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 2/16/11.
//  Copyright 2011 Dustin Atwood. All rights reserved.
//

#import "MGSkyPlayer.h"

#define indexDown 0
#define indexUp 1
#define indexOther 2

@implementation MGSkyPlayer
@synthesize positionPlayer, velocityPlayer, sizePlayer;
@synthesize isAlive, inShip, readyForDeletion;

// Initializes the player
- (id) init
{
	if(self = [super init])
	{
		imageShipFront = [[Image alloc] initWithImageNamed:@"imageShipFront"];
		imageShipBack = [[Image alloc] initWithImageNamed:@"imageShipBack"];
		
		imagesBody = [[NSMutableArray alloc] initWithCapacity:1];
		imagesEyes = [[NSMutableArray alloc] initWithCapacity:1];
		imagesAntenna = [[NSMutableArray alloc] initWithCapacity:1];
		sizePlayer = CGSizeMake(15, 25);
	}
	return self;
}

- (void)dealloc 
{
	[imageShipFront release];
	imageShipFront = nil;
	[imageShipBack release];
	imageShipBack = nil;
	[imagesBody release];
	imagesBody = nil;
	[imagesEyes release];
	imagesEyes = nil;
	[imagesAntenna release];
	imagesAntenna = nil;
	
	[emitter release];
	emitter = nil;
	[emitterShip release];
	emitterShip = nil;
	
	[super dealloc];
}

// Antenna, Eyes, Colors
- (void) adjustImagesBodyStyle:(NSString*)bodyStyleImage
				   BodyPattern:(NSString*)bodyPatternImage
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
			playerColor = Color4fMake([[components objectAtIndex:0] floatValue], 
									  [[components objectAtIndex:1] floatValue], 
									  [[components objectAtIndex:2] floatValue], 
									  1.0);
		}
	}
	
	Image* petImage;
	
	if([bodyStyleImage isEqualToString:@"(null)"] || bodyStyleImage == nil)
		bodyStyleImage = [NSString stringWithString:@"Body"];
	if([bodyPatternImage isEqualToString:@"(null)"] || bodyPatternImage == nil)
		bodyPatternImage = [NSString stringWithString:@"Standard"];
	
	// Setting up Body
	[imagesBody removeAllObjects];
	petImage = [[Image alloc] initWithImageNamed:[NSString stringWithFormat:@"PetMinigameFront%@%@Down", bodyStyleImage, bodyPatternImage]];
	[petImage setColourWithString:colorString];
	[imagesBody addObject:petImage];
	[petImage release];
	petImage = [[Image alloc] initWithImageNamed:[NSString stringWithFormat:@"PetMinigameFront%@%@Up", bodyStyleImage, bodyPatternImage]];
	[petImage setColourWithString:colorString];
	[imagesBody addObject:petImage];
	[petImage release];
	
	if([antennaImage isEqualToString:@"(null)"] || 
	   antennaImage == nil || [antennaImage isEqualToString:@"Nothing"] )
	{
		// Setting up No Antenna
		[imagesAntenna removeAllObjects];
		petImage = [[Image alloc] initWithImageNamed:@"Nothing"];
		[imagesAntenna addObject:petImage];
		[petImage release];
		petImage = [[Image alloc] initWithImageNamed:@"Nothing"];
		[imagesAntenna addObject:petImage];
		[petImage release];
	}
	else
	{
		// Setting up Antenna
		[imagesAntenna removeAllObjects];
		petImage = [[Image alloc] initWithImageNamed:[NSString stringWithFormat:@"PetMinigameFront%@Up", antennaImage]];
		[petImage setColourWithString:colorString];
		[imagesAntenna addObject:petImage];
		[petImage release];
		petImage = [[Image alloc] initWithImageNamed:[NSString stringWithFormat:@"PetMinigameFront%@Down", antennaImage]];
		[petImage setColourWithString:colorString];
		[imagesAntenna addObject:petImage];
		[petImage release];
	}
	
	
	// Setting up eyesImage
	if([eyesImage isEqualToString:@"(null)"] || eyesImage == nil)
		eyesImage = [NSString stringWithString:@"EyesBig"];
	[imagesEyes removeAllObjects];
	petImage = [[Image alloc] initWithImageNamed:[NSString stringWithFormat:@"PetMinigameFront%@Down", eyesImage]];
	[imagesEyes addObject:petImage];
	[petImage release];
	petImage = [[Image alloc] initWithImageNamed:[NSString stringWithFormat:@"PetMinigameFront%@Up", eyesImage]];
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
	
	if(emitterShip)
	{
		[emitterShip release];
		emitterShip = nil;
	}
	
	isAlive = TRUE;
	inShip = FALSE;
	readyForDeletion = FALSE;
	shipTimer = 0;
	tiltPlayer = 0;
	positionPlayer = CGPointMake(160, 0);
	velocityPlayer = CGPointMake(0, MaxPetVelocity);	
}

// Spawns Jumping Effect
- (void) createJumpEffect
{
	if(readyForDeletion || !isAlive)
		return;
	
	emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"imageStar"
																	   position:Vector2fMake(positionPlayer.x, 
																							 positionPlayer.y)
														 sourcePositionVariance:Vector2fMake(0,0)
																		  speed:60.0f
																  speedVariance:30.0f
															   particleLifeSpan:0.4f	
													   particleLifespanVariance:0.3f
																		  angle:270.0f
																  angleVariance:90.0f
																		gravity:Vector2fMake(0.0f, -20.0f)
																	 startColor:playerColor
															 startColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
																	finishColor:Color4fMake(playerColor.red, playerColor.green, playerColor.blue, 0.0f)  
															finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
																   maxParticles:50
																   particleSize:10
														   particleSizeVariance:5
																	   duration:0.05
																  blendAdditive:YES];
}

// Initiates a normal jump;
- (BOOL) applyJump
{
	if(readyForDeletion || !isAlive)
		return FALSE;
	
	// If Apply is true and the player is falling then apply a new velocity.
	if(velocityPlayer.y < 0)
	{
		velocityPlayer.y = (MaxPetVelocity + MinPetVelocity) / 2;
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
	if(velocityPlayer.y < 0)
	{
		velocityPlayer.y = MinPetVelocity;
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
	if(velocityPlayer.y < 0)
	{
		velocityPlayer.y = MaxPetVelocity;
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
	
	if (velocityPlayer.y < 0)
		velocityPlayer.y = 0;
	
	velocityPlayer.y += MaxPetVelocity;
	[self createJumpEffect];
	return TRUE;
}

// Initiates a Ship
- (BOOL) applyShip
{
	if(readyForDeletion || !isAlive)
		return FALSE;
	
	if(inShip)
		return FALSE;
	
	inShip = TRUE;
	shipTimer += ShipPetTime;
	if(velocityPlayer.y < MinPetVelocity)
		velocityPlayer.y = MinPetVelocity;
	[imageShipBack setAlpha:0.0];
	[imageShipFront setAlpha:0.0];
	emitterShip = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"imageParticleFire"
																	 position:Vector2fMake(positionPlayer.x, 
																						   positionPlayer.y-20)
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
																position:Vector2fMake(positionPlayer.x, 
																					  positionPlayer.y)
												  sourcePositionVariance:Vector2fMake(0,0)
																   speed:40.0f
														   speedVariance:20.0f
														particleLifeSpan:4.0f	
												particleLifespanVariance:1.0f
																   angle:0.0f
														   angleVariance:360.0f
																 gravity:Vector2fMake(0.0f, 0.0f)
															  startColor:playerColor
													  startColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
															 finishColor:Color4fMake(playerColor.red, playerColor.green, playerColor.blue, 0.0f)  
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
	velocityPlayer = CGPointZero;
}

// Update's the player
- (void) updateWithDelta:(GLfloat)delta
{
	if(readyForDeletion)
		return;
	
	if(emitter)
		[emitter update:delta];
	if(emitterShip)
		[emitterShip update:delta];
	
	if(![emitter active] && !isAlive)
		readyForDeletion = TRUE;
	
	if(!isAlive)
		return;
	
	if(inShip)
	{
		[emitterShip setSourcePosition:Vector2fMake(positionPlayer.x,positionPlayer.y-20)];
		
		shipTimer -= delta;
		
		// The ship will slowly increase to the max velocity over the lifetime of the ship
		if (velocityPlayer.y < 0) 
			velocityPlayer.y += MaxPetVelocity;
		if(velocityPlayer.y < MaxPetVelocity)
			velocityPlayer.y += delta * ((MaxPetVelocity - MinPetVelocity) / ShipPetTime) * 2;
		else if(velocityPlayer.y < MaxPetVelocity * 2)
			velocityPlayer.y += delta * ((MaxPetVelocity - MinPetVelocity) / ShipPetTime);
		
		float shipAlpha = [imageShipFront alpha];
		if(shipAlpha < 1.0)
		{
			shipAlpha +=delta;
			if(shipAlpha > 1.0)
				shipAlpha = 1.0;
			
			[imageShipBack setAlpha:shipAlpha];
			[imageShipFront setAlpha:shipAlpha];
		}
		
		imageIndexBody = indexUp;
		imageIndexEyes = indexUp;
		imageIndexAntenna = indexUp;
		
		if(shipTimer < 0)
		{
			shipTimer = 0;
			inShip = FALSE;
			emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"imageShipPart"
																		position:Vector2fMake(positionPlayer.x, 
																							  positionPlayer.y)
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
		float velocityLoss = delta * (MaxPetVelocity + MinPetVelocity) / 3;
		
		// Considered to be Jumping
		if(velocityPlayer.y > 0)
		{
			// Decrease the velocity
			velocityPlayer.y -= velocityLoss;
			
			// Check to see if will be falling
			if(velocityPlayer.y == 0)
			{
				velocityPlayer.y -= velocityLoss;
				fallingDistanceLeft = [Director sharedDirector].screenBounds.size.height;
			}
			
			imageIndexBody = indexUp;
			imageIndexEyes = indexUp;
			imageIndexAntenna = indexUp;
		}
		// Considered to be falling
		else if(velocityPlayer.y <= 0)
		{
			if(positionPlayer.y < -48)
			{
				[self die];
				return;
			}
			velocityPlayer.y -= velocityLoss * 2.5;
			
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
	
	tiltPlayer = data * 2;
	if (tiltPlayer > 20) 
		tiltPlayer = 20;
	if (tiltPlayer < -20) 
		tiltPlayer = -20;
	
	
	if(!inShip)
	{
		[[imagesBody objectAtIndex:imageIndexBody] setRotation:tiltPlayer];
		[[imagesEyes objectAtIndex:imageIndexEyes] setRotation:tiltPlayer];
		[[imagesAntenna objectAtIndex:imageIndexAntenna] setRotation:tiltPlayer];
	}
	else 
	{
		[[imagesBody objectAtIndex:imageIndexBody] setRotation:0];
		[[imagesEyes objectAtIndex:imageIndexEyes] setRotation:0];
		[[imagesAntenna objectAtIndex:imageIndexAntenna] setRotation:0];
	}
	
	
	positionPlayer.x += data;
	if(positionPlayer.x < 101 + 12)// || inShip)
	{
		positionPlayer.x -= data;
		// Could not apply accelerometer data
		return FALSE;
	}
	else if(positionPlayer.x > 221 - 12)// || inShip)
	{
		positionPlayer.x -= data;
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
		positionPlayer.y += velocity;
	}
	else if(velocity <= 0)
	{
		if(positionPlayer.y > [Director sharedDirector].screenBounds.size.height * 0.25 || fallingDistanceLeft < 0)
			positionPlayer.y += velocity;
		else
			fallingDistanceLeft += velocity;	
	}
}

// Render's the player
- (void) render
{
	if(inShip)
		[imageShipBack renderAtPoint:CGPointMake(positionPlayer.x-42, positionPlayer.y-12) centerOfImage:FALSE];
	
	if(isAlive)
	{
		[[imagesBody objectAtIndex:imageIndexBody] renderAtPoint:CGPointMake(positionPlayer.x - 26, positionPlayer.y - 26) centerOfImage:FALSE];
		[[imagesEyes objectAtIndex:imageIndexEyes] renderAtPoint:CGPointMake(positionPlayer.x - 11, positionPlayer.y) centerOfImage:FALSE];
		[[imagesAntenna objectAtIndex:imageIndexAntenna] renderAtPoint:CGPointMake(positionPlayer.x - 20, positionPlayer.y + 16) centerOfImage:FALSE];
	}
	
	[emitter renderParticles];
	[emitterShip renderParticles];
	
	if(inShip)
		[imageShipFront renderAtPoint:CGPointMake(positionPlayer.x-42, positionPlayer.y-30) centerOfImage:FALSE];
}

@end

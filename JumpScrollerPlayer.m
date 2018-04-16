//
//  JumpScrollerPlayer.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 11/21/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

#import "JumpScrollerPlayer.h"


@implementation JumpScrollerPlayer

@synthesize position, velocity, isAlive, inShip;

// Initializes the player
- (id) init
{
	if(self = [super init])
	{
		petImageBody = [[NSMutableArray alloc] initWithCapacity:1];
		
		Image* petImage = [[Image alloc] initWithImageNamed:@"PetMinigameFront"];
		[petImageBody addObject:petImage];
		[petImage release];
		
		petImage = [[Image alloc] initWithImageNamed:@"PetMinigameFrontFall"];
		[petImageBody addObject:petImage];
		[petImage release];
		
		petImage = [[Image alloc] initWithImageNamed:@"PetMinigameFrontJump"];
		[petImageBody addObject:petImage];
		[petImage release];
		
		imageShipFront = [[Image alloc] initWithImageNamed:@"imageShipFront"];
		imageShipBack = [[Image alloc] initWithImageNamed:@"imageShipBack"];
		
		
		petImageEyes = [[NSMutableArray alloc] initWithCapacity:1];

		petImageAntenna = [[NSMutableArray alloc] initWithCapacity:1];
	}
	return self;
}

- (void) adjustImagesAntenna:(NSString*)antennaImage 
						eyes:(NSString*)eyesImage 
					   color:(NSString*)colorString
{
	if([eyesImage isEqualToString:@"(null)"] || eyesImage == nil)
		eyesImage = [NSString stringWithString:@"EyesBig"];
	
	if([antennaImage isEqualToString:@"(Null)"] || antennaImage == nil || [antennaImage isEqualToString:@"Nothing"] )
	{
		// Setting up Antenna
		[petImageAntenna removeAllObjects];
		
		Image* petImage = [[Image alloc] initWithImageNamed:@"Nothing"];
		[petImageAntenna addObject:petImage];
		[petImage release];
		
		petImage = [[Image alloc] initWithImageNamed:@"Nothing"];
		[petImageAntenna addObject:petImage];
		[petImage release];
		
		[[petImageAntenna objectAtIndex:0] setColourWithString:colorString];
		[[petImageAntenna objectAtIndex:1] setColourWithString:colorString];
	}
	else
	{
		// Setting up Antenna
		[petImageAntenna removeAllObjects];
		
		Image* petImage = [[Image alloc] initWithImageNamed:[NSString stringWithFormat:@"PetMinigameFront%@Down", antennaImage]];
		[petImageAntenna addObject:petImage];
		[petImage release];
		
		petImage = [[Image alloc] initWithImageNamed:[NSString stringWithFormat:@"PetMinigameFront%@Up", antennaImage]];
		[petImageAntenna addObject:petImage];
		[petImage release];
		
		[[petImageAntenna objectAtIndex:0] setColourWithString:colorString];
		[[petImageAntenna objectAtIndex:1] setColourWithString:colorString];
	}
		antennaImage = [NSString stringWithString:@"Nothing"];
	
		
	
	// Setting up Eyes
	[petImageEyes removeAllObjects];
	
	Image* petImage = [[Image alloc] initWithImageNamed:[NSString stringWithFormat:@"PetMinigameFront%@Down", eyesImage]];
	[petImageEyes addObject:petImage];
	[petImage release];
	
	petImage = [[Image alloc] initWithImageNamed:[NSString stringWithFormat:@"PetMinigameFront%@Up", eyesImage]];
	[petImageEyes addObject:petImage];
	[petImage release];
	
	[[petImageBody objectAtIndex:0] setColourWithString:colorString];
	[[petImageBody objectAtIndex:1] setColourWithString:colorString];
	[[petImageBody objectAtIndex:2] setColourWithString:colorString];	
	
	
	// Setup and Changes the Emitter Color to the player's color
	
	[emitterJumping setActive:NO];
	
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
}

#define MaxPetVelocity 300//33
#define MinPetVelocity 200//17
#define ShipPetTime 5//5

// Resets the player back to starting variables;
- (void) reset
{
	position = CGPointMake(160, 0);
	velocity = CGPointMake(0, MaxPetVelocity);
	[self setIsAlive:TRUE];
	inShip = FALSE;
	readyForDeletion = FALSE;
	shipTimer = 0;
}

- (void) createJumpEffect
{
	emitterJumping = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"imageStar"
																	   position:Vector2fMake(position.x, 
																							 position.y)
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

// Initiates a jump;
- (BOOL) applyJump
{
	// If Apply is true and the player is falling then apply a new velocity.
	if(velocity.y < 0)
	{
		velocity.y = (MaxPetVelocity + MinPetVelocity) / 2;
		[self createJumpEffect];
		return TRUE;
	}
	return FALSE;
}

- (BOOL) applySmallJump
{
	// If Apply is true and the player is falling then apply a new velocity.
	if(velocity.y < 0)
	{
		velocity.y = MinPetVelocity;
		[self createJumpEffect];
		return TRUE;
	}
	return FALSE;
}

- (BOOL) applySuperJump
{
	// If Apply is true and the player is falling then apply a new velocity.
	if(velocity.y < 0)
	{
		velocity.y = MaxPetVelocity;
		[self createJumpEffect];
		return TRUE;
	}
	return FALSE;
}

// Boost provides speed reguardless of velocity
- (BOOL) applyBoost
{
	if (velocity.y < 0)
		velocity.y = 0;
	
	velocity.y += MaxPetVelocity;
	[self createJumpEffect];
	return TRUE;
}

- (BOOL) applyShip
{
	if(inShip)
		return FALSE;
	
	inShip = TRUE;
	shipTimer += ShipPetTime;
	if(velocity.y < MinPetVelocity)
		velocity.y = MinPetVelocity;
	[imageShipBack setAlpha:0.0];
	[imageShipFront setAlpha:0.0];
	emitterBoost = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"imageParticleFire"
																position:Vector2fMake(position.x, 
																					  position.y-20)
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

// Update's the player
- (void) updateWithDelta:(GLfloat)delta
{
	[emitter update:delta];
	[emitterJumping update:delta];
	[emitterBoost update:delta];
	[emitterBoostMax update:delta];
	
	if(inShip)
	{
		shipTimer -= delta;
		
		if([emitterBoostMax active])
			[emitterBoostMax setSourcePosition:Vector2fMake(position.x,position.y-20)];
		else
			[emitterBoost setSourcePosition:Vector2fMake(position.x,position.y-20)];
		
		// The ship will slowly increase to the max velocity over the lifetime of the ship
		if (velocity.y < 0) 
			velocity.y += MaxPetVelocity;
		if(velocity.y < MaxPetVelocity)
			velocity.y += delta * ((MaxPetVelocity - MinPetVelocity) / ShipPetTime) * 2;
		else if(velocity.y < MaxPetVelocity * 2)
			velocity.y += delta * ((MaxPetVelocity - MinPetVelocity) / ShipPetTime);
		else if (velocity.y > MaxPetVelocity * 2)
		{
			if(![emitterBoostMax active])
			{
				emitterBoostMax = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"imageParticleFire"
																			position:Vector2fMake(position.x, 
																								  position.y-20)
															  sourcePositionVariance:Vector2fMake(0,0)
																			   speed:60.0f
																	   speedVariance:30.0f
																	particleLifeSpan:0.4f	
															particleLifespanVariance:0.3f
																			   angle:270.0f
																	   angleVariance:90.0f
																			 gravity:Vector2fMake(0.0f, -20.0f)
																		  startColor:Color4fMake(0.0f, 0.0f, 1.0f, 1.0f)
																  startColorVariance:Color4fMake(1.0f, 0.0f, 0.0f, 0.3f)
																		 finishColor:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)  
																 finishColorVariance:Color4fMake(0.00f, 0.00, 0.00, 0.0f)
																		maxParticles:150
																		particleSize:10
																particleSizeVariance:1
																			duration:shipTimer
																	   blendAdditive:NO];
			}
		}
		
		float shipAlpha = [imageShipFront alpha];
		if(shipAlpha < 1.0)
		{
			shipAlpha +=delta;
			if(shipAlpha > 1.0)
				shipAlpha = 1.0;
			
			[imageShipBack setAlpha:shipAlpha];
			[imageShipFront setAlpha:shipAlpha];
		}
		
		currentBodyIndex = 0;
		currentEyesIndex = 1;
		currentAntennaIndex = 0;
		
		if(shipTimer < 0)
		{
			shipTimer = 0;
			inShip = FALSE;
			emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"imageShipPart"
																		position:Vector2fMake(position.x, 
																							  position.y)
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
		if(velocity.y > 0)
		{
			//[emitterJumping setActive:YES];
			//;
			// Decrease the velocity
			velocity.y -= velocityLoss; // --
			// Check to see if will be falling
			if(velocity.y == 0)
			{
				velocity.y -= velocityLoss;// --
				fallingDistanceLeft = [Director sharedDirector].screenBounds.size.height;
			}
		
			currentBodyIndex = 2;
			currentEyesIndex = 1;
			currentAntennaIndex = 0;
		}
		// Considered to be falling
		else if(velocity.y <= 0)
		{
			//[emitterJumping stopParticleEmitter];
			// Check to see if the player is at the bottom of the screen(dead)
			if(position.y < -48)
			{
				isAlive = FALSE;
				return;
			}
			velocity.y -= velocityLoss * 2.5; // --
		
			currentBodyIndex = 1;
			currentEyesIndex = 0;
			currentAntennaIndex = 1;
		}
	}
}

- (BOOL) applyAccelerometer:(GLfloat)data
{
	rotation = data * 2;
	if (rotation > 20) 
		rotation = 20;
	if (rotation < -20) 
		rotation = -20;
	
	
	if(!inShip)
	{
		[[petImageBody objectAtIndex:currentBodyIndex] setRotation:rotation];
		[[petImageEyes objectAtIndex:currentEyesIndex] setRotation:rotation];
		[[petImageAntenna objectAtIndex:currentAntennaIndex] setRotation:rotation];
	}
	else 
	{
		[[petImageBody objectAtIndex:currentBodyIndex] setRotation:0];
		[[petImageEyes objectAtIndex:currentEyesIndex] setRotation:0];
		[[petImageAntenna objectAtIndex:currentAntennaIndex] setRotation:0];
	}

	
	position.x += data;
	if(position.x < 101 + 12 || inShip)
	{
		position.x -= data;
		// Could not apply accelerometer data
		return FALSE;
	}
	else if(position.x > 221 - 12 || inShip)
	{
		position.x -= data;
		// Could not apply accelerometer data
		return FALSE;
	}
	return TRUE;
}

- (void) applyVelocityWithDelta:(GLfloat)delta
{
	if(velocity.y > 0)
	{
		position.y += velocity.y * delta;
	}
	else if(velocity.y <= 0)
	{
		if(position.y > [Director sharedDirector].screenBounds.size.height * 0.25 || fallingDistanceLeft < 0)
			position.y += velocity.y * delta;
		else
			fallingDistanceLeft += velocity.y * delta;	
	}
}

// Render's the player
- (void) render
{
	if(inShip)
		[imageShipBack renderAtPoint:CGPointMake(position.x-42, position.y-12) centerOfImage:FALSE];
	
	[[petImageBody objectAtIndex:currentBodyIndex] renderAtPoint:CGPointMake(position.x - 26, position.y - 26) centerOfImage:FALSE];
	[[petImageEyes objectAtIndex:currentEyesIndex] renderAtPoint:CGPointMake(position.x - 11, position.y) centerOfImage:FALSE];
	[[petImageAntenna objectAtIndex:currentAntennaIndex] renderAtPoint:CGPointMake(position.x - 20, position.y + 16) centerOfImage:FALSE];
	
	[emitter renderParticles];
	[emitterJumping renderParticles];
	
	if([emitterBoostMax active])
		[emitterBoostMax renderParticles];
	else
		[emitterBoost renderParticles];
	
	if(inShip)
		[imageShipFront renderAtPoint:CGPointMake(position.x-42, position.y-30) centerOfImage:FALSE];
}


@end

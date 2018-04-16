//
//  SideScrollerPlayerObject.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 11/5/10.
//  Copyright 2010 Dustin Atwood. All rights reserved.
//

// Speed is the rate at which the ground tiles are moving to the left side of the screen.

// Speed is used to determine how close to the center of the screen the pet should be.
// Speed is used to determine 

// Acceration is used to determine how many pixels to the lef the ground tiles are going to shift.
// Acceration is used to determine how many pixels to the right to move the pet on the screen. 

#import "SideScrollerPlayerObject.h"


@implementation SideScrollerPlayerObject

@synthesize velocity, position, onGround, canDoubleJump, isAlive, isFlying, timerFlying;

// Initializes the player
- (id) init
{
	if(self = [super init])
	{
		petImageBody = [[NSMutableArray alloc] initWithCapacity:1];
		petImageEyes = [[NSMutableArray alloc] initWithCapacity:1];
		petImageAntenna = [[NSMutableArray alloc] initWithCapacity:1];
		
		Image* petImage = [[Image alloc] initWithImageNamed:@"PetMinigameRightBodyPlainRun0"];
		[petImage setRotation:90];
		[petImageBody addObject:petImage];
		[petImage release];
		
		petImage = [[Image alloc] initWithImageNamed:@"PetMinigameRightBodyPlainRun1"];
		[petImage setRotation:90];
		[petImageBody addObject:petImage];
		[petImage release];
		
		petImage = [[Image alloc] initWithImageNamed:@"PetMinigameRightBodyPlainJump"];
		[petImage setRotation:90];
		[petImageBody addObject:petImage];
		[petImage release];
		
		petImage = [[Image alloc] initWithImageNamed:@"PetMinigameRightBodyPlainFall"];
		[petImage setRotation:90];
		[petImageBody addObject:petImage];
		[petImage release];

		
		/*
		
		petImageHopStart = [[Image alloc] initWithImageNamed:@"PetMinigameHopStart"];
		[petImageHopStart setRotation:90];
		petImageHopEnd = [[Image alloc] initWithImageNamed:@"PetMinigameHopEnd"];
		[petImageHopEnd setRotation:90];
		petImageJump = [[Image alloc] initWithImageNamed:@"PetMinigameJump"];
		[petImageJump setRotation:90];
		petImageFall = [[Image alloc] initWithImageNamed:@"PetMinigameFall"];
		[petImageFall setRotation:90];
		
		petEyes = [[Image alloc] initWithImageNamed:@"PetEyes"];
		[petEyes setRotation:90];
		petSmile = [[Image alloc] initWithImageNamed:@"PetSmile"];
		[petSmile setRotation:90];
		*/
		bounceUp = TRUE;
		bounceOffset = 0;
	}
	return self;
}

// Antenna, Eyes, Colors
- (void) adjustImagesAntenna:(NSString*)antennaImage 
						eyes:(NSString*)eyesImage color:(NSString*)colorString;
{
	if(antennaImage == nil || [antennaImage isEqualToString:@"Nothing"])
	{
		[petImageAntenna removeAllObjects];
		
		Image* petImage = [[Image alloc] initWithImageNamed:@"Nothing"];
		[petImageAntenna addObject:petImage];
		[petImage release];
		
		petImage = [[Image alloc] initWithImageNamed:@"Nothing"];
		[petImageAntenna addObject:petImage];
		[petImage release];
	}
	else
	{
		[petImageAntenna removeAllObjects];
		
		Image* petImage = [[Image alloc] initWithImageNamed:[NSString stringWithFormat:@"PetMinigameRight%@Down", antennaImage]];
		[petImage setRotation:90];
		[petImageAntenna addObject:petImage];
		[petImage release];
		
		petImage = [[Image alloc] initWithImageNamed:[NSString stringWithFormat:@"PetMinigameRight%@Up", antennaImage]];
		[petImage setRotation:90];
		[petImageAntenna addObject:petImage];
		[petImage release];
		
		[[petImageAntenna objectAtIndex:0] setColourWithString:colorString];
		[[petImageAntenna objectAtIndex:1] setColourWithString:colorString];	
	}
	
	[petImageEyes removeAllObjects];
	
	Image* petImage = [[Image alloc] initWithImageNamed:[NSString stringWithFormat:@"PetMinigameRight%@", eyesImage]];
	[petImage setRotation:90];
	[petImageEyes addObject:petImage];
	[petImage release];
	
	[[petImageBody objectAtIndex:0] setColourWithString:colorString];
	[[petImageBody objectAtIndex:1] setColourWithString:colorString];
	[[petImageBody objectAtIndex:2] setColourWithString:colorString];
	[[petImageBody objectAtIndex:3] setColourWithString:colorString];
}

// Resets the player back to starting variables;
- (void) reset
{
	position = CGPointMake(112, 160);
	velocity = CGPointMake(100, 0);
	onGround = FALSE;
	canDoubleJump = FALSE;
	isAlive = TRUE;
	isFlying = FALSE;
	timerFlying = 0;
}

// Initiates a jump;
- (void) jump
{
	if(onGround)
	{
		onGround = FALSE;
		velocity.y = 15;
	}
	else
	{
		if(canDoubleJump)
		{
			canDoubleJump = FALSE;
			velocity.y += 10 + (velocity.x / 65);
		}
	}
}

// Update's the player
- (void) updateWithDelta:(GLfloat)delta
{
	// Death Check
	if(position.y < -24)
	{
		isAlive = FALSE;
		return;
	}
	
	if(isFlying && timerFlying <= 0)
	{
		isFlying = FALSE;
		onGround = FALSE;
		velocity.x = 200;
		position.y = 320;
		position.x = 112;
	}
	
	if(!isFlying)
	{
		if(velocity.x >= 0 && velocity.x <= 100)
		{
			velocity.x += (10 * delta);
		}
		else if(velocity.x > 100 && velocity.x <= 200)
		{
			velocity.x += (5 * delta);
		}
		else if(velocity.x > 200 && velocity.x <= 300)
		{
			velocity.x += (1 * delta);
		}
		else if(velocity.x > 300 && velocity.x <= 325)
		{
			velocity.x += (0.5 * delta);
		}
		
		if(!onGround)
		{
			velocity.y--;
			if (velocity.y > 0) 
			{
				currentBodyIndex = 2;
				currentAntennaIndex = 0;
			}
			else
			{
				currentBodyIndex = 3;
				currentAntennaIndex = 1;
			}
		}
		if(onGround)
		{
			velocity.y = 0;
			
			runningTimer +=delta;
			if(runningTimer > 0.2)
			{
				runningTimer -= 0.2;
				currentBodyIndex++;
				bounceOffset += 5;
			}
				
			if(currentBodyIndex > 2)
			{
				currentBodyIndex = 0;
				bounceOffset = 0;
			}
			
			/*
			// ANIMATION BOUNCE, while on ground
			if(bounceUp)
				bounceOffset += delta * (velocity.x / 350 * 50);
			else
				bounceOffset -= delta * (velocity.x / 350 * 50);
			
			if (bounceOffset > 2.5) 
				bounceUp = FALSE;
			else if (bounceOffset < -2.5) 
				bounceUp = TRUE;
			 */
		}
	}
	else 
	{
		// Decrease the time flying
		timerFlying -= delta;
		position.y = 176;
		
		if(timerFlying > 9)
		{
			velocity.x = 200 + 450 * (1 - (timerFlying - 9));
			position.x = 112 + 128 * (1 - (timerFlying - 9));
		}
		else
		{
			velocity.x = 650;
			position.x = 240;
		}
	}
}

// Applys the player's velocity
- (void) applyVelocity
{
	position.y += velocity.y;
}

// Render's the player
- (void) render
{	
	[[petImageBody objectAtIndex:currentBodyIndex] renderAtPoint:CGPointPortraitToLandscape(CGPointMake(position.x, position.y + 40 + bounceOffset)) centerOfImage:TRUE];
	[[petImageEyes objectAtIndex:0] renderAtPoint:CGPointPortraitToLandscape(CGPointMake(position.x + 2, position.y + 40 + 5 + bounceOffset)) centerOfImage:TRUE];
	[[petImageAntenna objectAtIndex:currentAntennaIndex] renderAtPoint:CGPointPortraitToLandscape(CGPointMake(position.x - 8, position.y + 70 + bounceOffset)) centerOfImage:TRUE];
	
	/*
	// When velocity.y is positive show, jumping frame
	if (velocity.y > 0) 
	{
		[petImageJump renderAtPoint:CGPointPortraitToLandscape(CGPointMake(position.x, position.y + 40 + bounceOffset)) centerOfImage:YES];
	}
	// When velocity.y is negative show, falling frame
	if (velocity.y < 0) 
	{
		[petImageFall renderAtPoint:CGPointPortraitToLandscape(CGPointMake(position.x, position.y + 40 + bounceOffset)) centerOfImage:YES];
	}
	// When velocity.y is 0 show the hopping frames.
	if (velocity.y == 0) 
	{
		if(bounceOffset >= 0)
			[petImageHopEnd renderAtPoint:CGPointPortraitToLandscape(CGPointMake(position.x, position.y + 40 + bounceOffset)) centerOfImage:YES];
		else
			[petImageHopStart renderAtPoint:CGPointPortraitToLandscape(CGPointMake(position.x, position.y + 40 + bounceOffset)) centerOfImage:YES];
	}
	
	[petEyes renderAtPoint:CGPointPortraitToLandscape(CGPointMake(position.x + 2, position.y + 40 + 5 + bounceOffset)) centerOfImage:YES];
	[petSmile renderAtPoint:CGPointPortraitToLandscape(CGPointMake(position.x + 4, position.y + 40 - 3 + bounceOffset)) centerOfImage:YES];
	*/
}
@end
